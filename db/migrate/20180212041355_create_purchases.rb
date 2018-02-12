class CreatePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :purchases, id: :uuid do |t|
      t.boolean :completed, default: false, null: false
      t.references :user, foriegn_key: true
      t.references :content, foriegn_key: true

      t.timestamps
    end
  end
end
