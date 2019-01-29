defmodule ExBitmex.Rest.Orders do
  alias ExBitmex.Rest
  alias ExBitmex.Credentials

  @type config :: map | nil
  @type order :: ExBitmex.Order.t()
  @type orders_params :: %{orders: list(order)}
  @type rate_limit :: ExBitmex.RateLimit.t()
  @type auth_error_reason :: Rest.HTTPClient.auth_error_reason()
  @type params :: map
  @type error_msg :: String.t()
  @type shared_error_reason :: :timeout | auth_error_reason | nonce_not_increasing_error_reason
  @type insufficient_balance_error_reason :: {:insufficient_balance, error_msg}
  @type nonce_not_increasing_error_reason :: {:nonce_not_increasing, error_msg}

  @type create_error_reason ::
          shared_error_reason
          | insufficient_balance_error_reason

  @spec create(config, params) ::
          {:ok, order, rate_limit} | {:error, create_error_reason, rate_limit | nil}
  def create(config, params) when is_map(params) do
    "/order"
    |> Rest.HTTPClient.auth_post(Credentials.config(config), params)
    |> parse_response
  end

  @spec create_bulk(config, orders_params) ::
          {:ok, list(order), rate_limit} | {:error, create_error_reason, rate_limit | nil}
  def create_bulk(config, orders_params) do
    "/order/bulk"
    |> Rest.HTTPClient.auth_post(Credentials.config(config), orders_params)
    |> parse_response
  end

  @type amend_error_reason :: shared_error_reason | insufficient_balance_error_reason

  @spec amend(config, params) ::
          {:ok, order, rate_limit} | {:error, amend_error_reason, rate_limit | nil}
  def amend(config, params) when is_map(params) do
    "/order"
    |> Rest.HTTPClient.auth_put(Credentials.config(config), params)
    |> parse_response
  end

  @spec amend_bulk(config, orders_params) ::
          {:ok, list(order), rate_limit} | {:error, create_error_reason, rate_limit | nil}
  def amend_bulk(config, orders_params) do
    "/order/bulk"
    |> Rest.HTTPClient.auth_put(Credentials.config(config), orders_params)
    |> parse_response
  end

  @type cancel_error_reason :: shared_error_reason

  @spec cancel(config, params) ::
          {:ok, [order], rate_limit} | {:error, cancel_error_reason, rate_limit | nil}
  def cancel(config \\ nil, params) when is_map(params) do
    "/order"
    |> Rest.HTTPClient.auth_delete(Credentials.config(config), params)
    |> parse_response
  end

  @spec cancel_bulk(config, orders_params) ::
          {:ok, list(order), rate_limit} | {:error, create_error_reason, rate_limit | nil}
  def cancel_bulk(config, orders_params) do
    "/order/all"
    |> Rest.HTTPClient.auth_delete(Credentials.config(config), orders_params)
    |> parse_response
  end

  defp parse_response({:ok, data, rate_limit}) when is_list(data) do
    orders =
      data
      |> Enum.map(&to_struct/1)
      |> Enum.map(fn {:ok, o} -> o end)

    {:ok, orders, rate_limit}
  end

  defp parse_response({:ok, data, rate_limit}) when is_map(data) do
    {:ok, order} = data |> to_struct
    {:ok, order, rate_limit}
  end

  defp parse_response(
         {:error,
          {
            :bad_request,
            %{
              "error" => %{
                "message" => "Account has insufficient Available Balance" <> _ = msg,
                "name" => "ValidationError"
              }
            }
          }, rate_limit}
       ) do
    {:error, {:insufficient_balance, msg}, rate_limit}
  end

  defp parse_response({:error, _, _} = error), do: error

  defp to_struct(data) do
    data
    |> Mapail.map_to_struct(
      ExBitmex.Order,
      transformations: [:snake_case]
    )
  end
end
