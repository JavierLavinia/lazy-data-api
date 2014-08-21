class CreatePages < ActiveRecord::Migration
  def change
    create_table :lazy_dummies do |t|
      t.integer :integer
      t.text :text
      t.string :string

      t.timestamps
    end
  end
end
