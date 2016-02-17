class AddPageToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :page, :string
  end
end
