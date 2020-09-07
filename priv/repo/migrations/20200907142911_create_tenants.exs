defmodule Backend.Repo.Migrations.CreateTenants do
  use Ecto.Migration

  def change do
    create table(:tenants) do
      add :domain, :string

      timestamps()
    end

    create unique_index(:tenants, [:domain])
  end
end
