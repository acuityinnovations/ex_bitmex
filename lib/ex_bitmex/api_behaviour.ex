defmodule ExBitmex.ApiBehaviour do
  @type credentials :: ExBitmex.Credentials.t()
  @type order :: ExBitmex.Order.t()
  @type rate_limit :: ExBitmex.RateLimit.t()
  @type auth_error_reason :: Rest.HTTPClient.auth_error_reason()
  @type params :: map
  @type error_msg :: String.t()
  @type shared_error_reason :: :timeout | auth_error_reason | nonce_not_increasing_error_reason
  @type insufficient_balance_error_reason :: {:insufficient_balance, error_msg}
  @type nonce_not_increasing_error_reason :: {:nonce_not_increasing, error_msg}
  @type amend_error_reason :: shared_error_reason | insufficient_balance_error_reason
  @type create_error_reason ::
          shared_error_reason
          | insufficient_balance_error_reason
  @type cancel_error_reason :: shared_error_reason


  @callback create(credentials, params) ::
          {:ok, order, rate_limit} | {:error, create_error_reason, rate_limit | nil}
  @callback create_bulk(credentials, params) ::
          {:ok, order, rate_limit} | {:error, create_error_reason, rate_limit | nil}
  @callback amend(credentials, params) ::
          {:ok, order, rate_limit} | {:error, amend_error_reason, rate_limit | nil}
  @callback amend_bulk(credentials, params) ::
          {:ok, order, rate_limit} | {:error, create_error_reason, rate_limit | nil}
  @callback cancel(credentials, params) ::
          {:ok, [order], rate_limit} | {:error, cancel_error_reason, rate_limit | nil}
  @callback cancel_bulk(credentials, params) ::
          {:ok, list(order), rate_limit} | {:error, create_error_reason, rate_limit | nil}
  @callback get(credentials, params) ::
          {:ok, list(order), rate_limit} | {:error, create_error_reason, rate_limit | nil}
end
