defmodule Backend.Tenants.Tenant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tenants" do
    field :domain, :string

    timestamps()
  end

  @doc false
  def changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [:domain])
    |> validate_required([:domain])
    |> unique_constraint(:domain)
  end
end
