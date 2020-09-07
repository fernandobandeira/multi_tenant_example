defmodule BackendWeb.TestController do
  use BackendWeb, :controller

  def index(%Plug.Conn{assigns: assigns} = conn, _params) do
    json(conn, %{test: assigns[:tenant]})
  end
end
