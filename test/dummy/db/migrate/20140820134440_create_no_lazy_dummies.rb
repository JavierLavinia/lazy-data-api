class CreateNoLazyDummies < ActiveRecord::Migration
  def change
    create_table :no_lazy_dummies do |t|
      t.string :string
      t.text :text
      t.integer :integer

      t.timestamps
    end
  end
end
