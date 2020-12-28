defmodule ExBitmex.Rest.Instruments do
  alias ExBitmex.Rest

  def all do
    "/instrument"
    |> Rest.HTTPClient.non_auth_get()
  end

  def get_instrument_detail(instrument) do
    Rest.HTTPClient.non_auth_get("/instrument", %{symbol: instrument})
  end
end
