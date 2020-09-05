defmodule ExBitmex.Credentials do
  require Logger

  @type t :: %ExBitmex.Credentials{
          api_key: String.t(),
          api_secret: String.t()
        }

  @enforce_keys [:api_key, :api_secret]
  defstruct [:api_key, :api_secret]

  @doc """
  Default credentials

  ## Examples
      iex> ExBitmex.Credentials.config()
  """
  def config(nil) do
    %__MODULE__{
      api_key: System.get_env("BITMEX_API_KEY"),
      api_secret: System.get_env("BITMEX_API_SECRET")
    }
  end

  @doc """
  Get static API configs passed in directly

  ## Examples
      iex> ExBitmex.Credentials.config(%{api_key: "abcdef", secret_key: "123456"})
  """
  def config(%{
        api_key: api_key,
        secret_key: secret_key
      }) do
    %__MODULE__{
      api_key: api_key,
      api_secret: secret_key
    }
  end

  def config(_) do
    Logger.error("Incorrect config setup.")
  end
end
