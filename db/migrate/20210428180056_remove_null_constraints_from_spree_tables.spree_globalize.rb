# This migration comes from spree_globalize (originally 20150217095648)
class RemoveNullConstraintsFromSpreeTables < SpreeExtension::Migration[4.2]
  def up
    change_column :spree_properties, :presentation, :string, null: true
    change_column :spree_taxonomies, :name,         :string, null: true
    change_column :spree_taxons,     :name,         :string, null: true
  end

  def down
    change_column :spree_properties, :presentation, :string, null: false
    change_column :spree_taxonomies, :name,         :string, null: false
    change_column :spree_taxons,     :name,         :string, null: false
  end
end
