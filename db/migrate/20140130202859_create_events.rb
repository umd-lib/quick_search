class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string :category
      t.string :action
      t.string :label

      t.timestamps
    end
  end
end
