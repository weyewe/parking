class CreatePriceRules < ActiveRecord::Migration
  def change
    create_table :price_rules do |t|

      t.timestamps
    end
  end
end
