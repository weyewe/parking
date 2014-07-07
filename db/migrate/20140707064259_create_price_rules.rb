class CreatePriceRules < ActiveRecord::Migration
  def change
    create_table :price_rules do |t|
      t.integer :vehicle_case 
      
      t.boolean :is_base_price, :default => false 
      t.integer :hour 
      t.decimal :price , :default        => 0,  :precision => 10, :scale => 2 
      
      t.boolean :is_deleted, :default => false 
      t.datetime :deleted_at 

      t.timestamps
    end
  end
end
