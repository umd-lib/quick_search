class AddPageToSearches < ActiveRecord::Migration[4.2]
  def change
    add_column :searches, :page, :string
  end
end
