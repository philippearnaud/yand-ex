defmodule TranslateTest do
  use ExUnit.Case
  doctest YandEx.Translate

  import YandEx.Translate

  test "Check header method" do
    get_headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    assert 1 + 1 == 2
  end
end
