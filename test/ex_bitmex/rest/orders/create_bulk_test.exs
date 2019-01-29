defmodule ExBitmex.Rest.Orders.CreateBulkTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".create_bulk returns the orders response" do
    use_cassette "rest/orders/create_bulk_buy_limit_ok" do
      assert {:ok, orders, _} =
               ExBitmex.Rest.Orders.create_bulk(
                 default_config(),
                 %{
                   orders: [
                     %{
                       symbol: "XBTUSD",
                       side: "Buy",
                       orderQty: 1,
                       price: 1
                     }
                   ]
                 }
               )

      assert orders == [
               %ExBitmex.Order{
                 currency: "USD",
                 side: "Buy",
                 transact_time: "2019-01-29T00:49:07.582Z",
                 multi_leg_reporting_type: "SingleSecurity",
                 account: 158_898,
                 display_qty: nil,
                 avg_px: nil,
                 ord_rej_reason: "",
                 peg_offset_value: nil,
                 exec_inst: "",
                 ord_type: "Limit",
                 simple_leaves_qty: nil,
                 working_indicator: true,
                 order_qty: 1,
                 order_id: "9ea67d9d-9874-0cf0-432d-c28df696fbcb",
                 simple_order_qty: nil,
                 settl_currency: "XBt",
                 time_in_force: "GoodTillCancel",
                 simple_cum_qty: nil,
                 cum_qty: 0,
                 symbol: "XBTUSD",
                 contingency_type: "",
                 timestamp: "2019-01-29T00:49:07.582Z",
                 stop_px: nil,
                 cl_ord_link_id: "",
                 ex_destination: "XBME",
                 cl_ord_id: "",
                 price: 1,
                 triggered: "",
                 peg_price_type: "",
                 leaves_qty: 1,
                 ord_status: "New",
                 text: "Submitted via API."
               }
             ]
    end
  end

  test ".create_bulk returns an error tuple when there is insufficient balance" do
    use_cassette "rest/orders/create_bulk_insufficient_balance" do
      assert {:error, {:insufficient_balance, msg}, %ExBitmex.RateLimit{}} =
               ExBitmex.Rest.Orders.create_bulk(
                 default_config(),
                 %{
                   orders: [
                     %{
                       symbol: "XBTUSD",
                       side: "Buy",
                       orderQty: 1_000_000,
                       price: 2000
                     }
                   ]
                 }
               )

      assert msg =~ "Account has insufficient Available Balance"
    end
  end

  def default_config, do: nil
end
