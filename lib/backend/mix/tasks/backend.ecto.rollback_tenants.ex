defmodule Mix.Tasks.Backend.Ecto.RollbackTenants do
  use Mix.Task

  import Mix.Ecto

  alias Backend.TenantActions

  @shortdoc "Rolls back the repository migrations in tenants"

  @doc false
  def run(_args) do
    Code.compiler_options(ignore_module_conflict: true)
    {:ok, _, _} = Ecto.Migrator.with_repo(Backend.Repo, [])
    Ecto.Adapters.SQL.Sandbox.checkin(Backend.Repo)

    tenants = TenantActions.list_tenants(Backend.Repo)
    Enum.each(tenants, &migrate_tenant/1)
    Mix.shell().info("Rollback completed")
  end

  defp migrate_tenant(tenant) do
    TenantActions.migrate_tenant(Backend.Repo, tenant, :down)
    Mix.shell().info("#{tenant} rolled back")
  end
end
