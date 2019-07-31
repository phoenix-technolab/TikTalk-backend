class RenameSpeakColumnToLanguagesInProfile < ActiveRecord::Migration[5.2]
  def change
    rename_column :profiles, :speak, :languages
  end
end
