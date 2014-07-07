class CreateSubcriptionProducts < ActiveRecord::Migration
  def change
    create_table :subcription_products do |t|
      t.integer :duration, :default => 0  # how many days
      t.string :name 
      t.text :description 
      
      t.decimal :price , :default        => 0,  :precision => 10, :scale => 2 
      
       
      
      t.boolean :is_deactivated, :default => false
      t.boolean :deactivation_date 
      t.text :deactivation_description 
      
      
      t.timestamps
    end
  end
end
