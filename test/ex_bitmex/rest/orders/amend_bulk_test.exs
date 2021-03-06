defmodule ExBitmex.Rest.Orders.AmendBulkTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_API_SECRET")
  }

  test ".amend_bulk returns the order response" do
    use_cassette "rest/orders/amend_bulk_ok" do
      {:ok, order, _} =
        ExBitmex.Rest.Orders.create(
          @credentials,
          %{
            symbol: "XBTUSD",
            side: "Buy",
            orderQty: 1,
            price: 1
          }
        )

      assert order == %ExBitmex.Order{
               stop_px: nil,
               ex_destination: "XBME",
               transact_time: "2019-01-29T03:57:31.751Z",
               peg_offset_value: nil,
               working_indicator: true,
               price: 1,
               ord_rej_reason: "",
               triggered: "",
               contingency_type: "",
               time_in_force: "GoodTillCancel",
               ord_type: "Limit",
               cl_ord_id: "",
               simple_order_qty: nil,
               currency: "USD",
               cum_qty: 0,
               side: "Buy",
               exec_inst: "",
               leaves_qty: 1,
               simple_leaves_qty: nil,
               display_qty: nil,
               symbol: "XBTUSD",
               peg_price_type: "",
               timestamp: "2019-01-29T03:57:31.751Z",
               cl_ord_link_id: "",
               text: "Submitted via API.",
               multi_leg_reporting_type: "SingleSecurity",
               account: 158_898,
               simple_cum_qty: nil,
               ord_status: "New",
               order_qty: 1,
               settl_currency: "XBt",
               avg_px: nil,
               order_id: "c550ced8-063d-5a0e-0fcc-37fd72efa7d3"
             }

      assert {:ok, orders, _} =
               ExBitmex.Rest.Orders.amend_bulk(
                 @credentials,
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
                 stop_px: nil,
                 ex_destination: "XBME",
                 transact_time: "2019-01-29T03:57:32.085Z",
                 peg_offset_value: nil,
                 working_indicator: true,
                 text: "Amended leavesQty: Amended via API.\nSubmitted via API.",
                 price: 1,
                 ord_rej_reason: "",
                 triggered: "",
                 contingency_type: "",
                 time_in_force: "GoodTillCancel",
                 ord_type: "Limit",
                 cl_ord_id: "",
                 simple_order_qty: nil,
                 currency: "USD",
                 cum_qty: 0,
                 side: "Buy",
                 exec_inst: "",
                 leaves_qty: 3,
                 simple_leaves_qty: nil,
                 display_qty: nil,
                 symbol: "XBTUSD",
                 peg_price_type: "",
                 timestamp: "2019-01-29T03:57:32.085Z",
                 cl_ord_link_id: "",
                 multi_leg_reporting_type: "SingleSecurity",
                 account: 158_898,
                 simple_cum_qty: nil,
                 ord_status: "New",
                 order_qty: 3,
                 settl_currency: "XBt",
                 avg_px: nil,
                 order_id: "c550ced8-063d-5a0e-0fcc-37fd72efa7d3"
               }
             ]
    end
  end
end
