defmodule YandEx do
  @moduledoc ~S"""
  """
  use HTTPoison.Base
  alias HTTPoison.Response, as: Response

  @default_headers [{"Content-Type", "application/x-www-form-urlencoded"}]

  @doc ""
  def request(endpoint, body, params \\ []) do
    post(endpoint, body, @default_headers, params) |> handle_response
  end

  @doc ""
  def process_response_body(body) do
    URI.decode_www_form(body) |> JSX.decode!
  end

  @doc ""
  def process_request(body) do
    URI.encode_www_form(body)
  end

  defp handle_response({:ok, %Response{status_code: code, body: body}}) when code in 200..299, do: {:ok, body}
  defp handle_response({:ok, %Response{status_code: code, body: body}}) when code in 300..599, do: {:error, body}
  defp handle_response({:error, error}), do: {:error, error}
end
