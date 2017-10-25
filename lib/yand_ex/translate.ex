defmodule YandEx.Translate do
  @moduledoc ""

  @api_key Application.get_env(:yand_ex, :translate_api_key)
  @api_endpoint "https://translate.yandex.net/api/v1.5/tr.json/"

  @doc """
  """
  def supported_langs(ui_lang \\ "en") do
    req_params = [ui: ui_lang]
    YandEx.request(get_endpoint(:supported),  get_body([text: ""]), get_params(req_params))
    |> parse_response(fn dict -> dict["langs"] end)
  end

  @doc """

  """
  def supported_dirs(ui_lang \\ "en") do
    req_params = [ui: ui_lang]
    YandEx.request(get_endpoint(:supported),  get_body([text: ""]), get_params(req_params))
    |> parse_response(fn dict -> dict["dirs"] end)
  end

  @doc """
  Detect language of `text`.
  Passing `hints_list` containing hints of possible languages is optional.

  Returns `{:ok, detected_lang}` or `{:error, message}`
  """
  def detect_lang(text, hints_list \\ []) do
    hints_str = Enum.join(hints_list, ",")
    req_params = [hint: hints_str]
    YandEx.request(get_endpoint(:detect),  get_body([]), get_params(req_params))
    |> parse_response(fn dict -> dict["lang"] end)
  end

  @doc """
  Translate `text` to `dst_lang` from `src_lang`.
  Passing `src_lang` is optional, if no value is passed Yandex will try to guess source language.
  For list of handled valid languages and translation directions call `supported_langs` or
  `supported_dirs`.

  Returns `{:ok, {translation_dir, text}` or `{:error, message}`
  """
  def translate(text, dst_lang,  src_lang \\ nil) do
    req_params = [lang: dst_lang]
    YandEx.request(get_endpoint(:translate),  get_body([text: text]), get_params(req_params))
    |> parse_response(fn dict -> {dict["lang"], List.first(dict["text"])} end)
  end


  # Private helper methods

  # generate full endpoint address
  defp get_endpoint(:supported), do: @api_endpoint <> "getLangs"
  defp get_endpoint(:detect), do: @api_endpoint <> "detect"
  defp get_endpoint(:translate), do: @api_endpoint <> "translate"

  # define request body
  defp get_body(kv_list), do: {:form, kv_list}

  # get request parameters
  defp get_params(request_params), do: [params: request_params ++ [key: @api_key]]

  # parse response, for success call handler on body, in case of error return message.
  defp parse_response(response, handler) do
    with {:ok, response_dict} <- response do 
      {:ok, handler.(response_dict)}
    end |> case do
      {:ok, value} -> {:ok, value}
      {:error, value} -> {:error, value["message"]}
    end
  end
end
