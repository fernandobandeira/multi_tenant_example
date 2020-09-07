defmodule Mix.Tasks.Backend.Ecto.MigrateTenants do
  use Mix.Task

  alias Backend.TenantActions

  @shortdoc "Runs the repository migrations in tenants"

  @doc false
  def run(_args) do
    Code.compiler_options(ignore_module_conflict: true)
    {:ok, _, _} = Ecto.Migrator.with_repo(Backend.Repo, fn _repo ->
      tenants = TenantActions.list_tenants(Backend.Repo)
      Enum.each(tenants, &migrate_tenant/1)
      Mix.shell().info("Migrations completed")
    end)
  end

  defp migrate_tenant(tenant) do
    TenantActions.migrate_tenant(Backend.Repo, tenant, :up)
    Mix.shell().info("#{tenant} migrated")
  end
end
