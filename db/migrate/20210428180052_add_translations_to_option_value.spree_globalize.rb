# This migration comes from spree_globalize (originally 20131009091000)
class AddTranslationsToOptionValue < SpreeExtension::Migration[4.2]
  def up
    unless table_exists?(:spree_option_value_translations)
      params = { name: :string, presentation: :string }
      Spree::OptionValue.create_translation_table!(params, { migrate_data: true })
    end
  end

  def down
    Spree::OptionValue.drop_translation_table! migrate_data: true
  end
end
