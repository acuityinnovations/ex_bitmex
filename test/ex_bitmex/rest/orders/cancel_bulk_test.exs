defmodule ExBitmex.Rest.Orders.CancelBulkTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".cancel_bulk returns a list of results" do
    use_cassette "rest/orders/cancel_bulk_ok" do
      {:ok, order, _} =
        ExBitmex.Rest.Orders.create(
          default_config(),
          %{
            symbol: "XBTUSD",
            side: "Buy",
            orderQty: 1,
            price: 1
          }
        )

      assert {:ok, orders, _} =
               ExBitmex.Rest.Orders.cancel_bulk(
                 default_config(),
                 %{orders: [%{orderID: order.order_id}]}
               )

      assert orders == [
               %ExBitmex.Order{
                 exec_inst: "",
                 working_indicator: false,
                 transact_time: "2019-01-29T01:09:46.316Z",
                 avg_px: nil,
                 side: "Buy",
                 order_id: "c904121b-d790-87b8-800e-a4aec8af5b49",
                 peg_offset_value: nil,
                 contingency_type: "",
                 ord_rej_reason: "",
                 stop_px: nil,
                 ord_type: "Limit",
                 simple_cum_qty: nil,
                 ex_destination: "XBME",
                 settl_currency: "XBt",
                 price: 1,
                 account: 158_898,
                 currency: "USD",
                 cl_ord_link_id: "",
                 cl_ord_id: "",
                 ord_status: "Canceled",
                 symbol: "XBTUSD",
                 triggered: "",
                 timestamp: "2019-01-29T01:09:46.665Z",
                 time_in_force: "GoodTillCancel",
                 leaves_qty: 0,
                 simple_order_qty: nil,
                 simple_leaves_qty: nil,
                 cum_qty: 0,
                 peg_price_type: "",
                 order_qty: 1,
                 multi_leg_reporting_type: "SingleSecurity",
                 display_qty: nil,
                 text: "Canceled: Canceled via API.\nSubmitted via API."
               }
             ]
    end
  end

  defp default_config, do: nil
end
