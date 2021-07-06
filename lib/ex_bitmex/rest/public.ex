defmodule ExBitmex.PublicApi do
  alias ExBitmex.Rest

  def get_kline_data(instrument, interval, limit) do
    Rest.HTTPClient.non_auth_get(
      "/trade/bucketed",
      %{symbol: instrument, binSize: interval, partial: true, count: limit}
    )
  end
end
