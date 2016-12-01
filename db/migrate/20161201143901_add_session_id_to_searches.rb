class AddSessionIdToSearches < ActiveRecord::Migration[5.0]
  def change
    add_reference :searches, :sessions, foreign_key: true
  end
end
