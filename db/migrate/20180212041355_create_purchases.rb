class CreatePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :purchases do |t|
      t.boolean :completed, default: false, null: false
      t.string :memo, null: false, index: true
      t.references :user, foriegn_key: true
      t.references :content, foriegn_key: true

      t.timestamps
    end
  end
end
