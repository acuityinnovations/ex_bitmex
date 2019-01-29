defmodule ExBitmex.Rest.Orders.AmendBulkTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".amend_bulk returns the order response" do
    use_cassette "rest/orders/amend_bulk_ok" do
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
               ExBitmex.Rest.Orders.amend_bulk(
                 default_config(),
                 %{
                   orders: [
                     %{
                       orderID: order.order_id,
                       leavesQty: 3
                     }
                   ]
                 }
               )

      assert orders == [
               %ExBitmex.Order{
                 exec_inst: "",
                 working_indicator: true,
                 transact_time: "2019-01-29T01:04:00.844Z",
                 avg_px: nil,
                 side: "Buy",
                 order_id: "1488c13d-972c-e541-905e-c3f93ff92646",
                 text: "Amended leavesQty: Amended via API.\nSubmitted via API.",
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
                 ord_status: "New",
                 symbol: "XBTUSD",
                 triggered: "",
                 timestamp: "2019-01-29T01:04:00.844Z",
                 time_in_force: "GoodTillCancel",
                 leaves_qty: 3,
                 simple_order_qty: nil,
                 simple_leaves_qty: nil,
                 cum_qty: 0,
                 peg_price_type: "",
                 order_qty: 3,
                 multi_leg_reporting_type: "SingleSecurity",
                 display_qty: nil
               }
             ]
    end
  end

  defp default_config, do: nil
end
