defmodule BackendWeb.Plugs.Tenant do
  import Plug.Conn

  alias Backend.Tenants

  def init(default), do: default

  def call(conn, _default) do
    conn
    |> get_platform_header()
    |> fetch_tenant()
    |> assign_tenant(conn)
  end

  defp get_platform_header(conn) do
    conn
    |> get_req_header("platform")
    |> List.first()
  end

  defp fetch_tenant(platform) when platform != nil and is_bitstring(platform) do
    %Tenants.Tenant{id: id} = Tenants.get_tenant!(platform)
    "tenant_" <> Integer.to_string(id)
  end

  defp fetch_tenant(_platform), do: fetch_tenant("foo.localhost")

  defp assign_tenant(tenant, conn) when tenant != nil do
    conn
    |> assign(:tenant, tenant)
  end

  defp assign_tenant(_tenant, conn) do
    conn
    |> put_status(:not_found)
    |> Phoenix.Controller.render(BackendWeb.ErrorView, :"404")
    |> halt()
  end
end
