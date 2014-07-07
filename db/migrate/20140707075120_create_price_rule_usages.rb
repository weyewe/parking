class CreatePriceRuleUsages < ActiveRecord::Migration
  def change
    create_table :price_rule_usages do |t|
      t.integer :price_rule_id
      t.integer :ticket_id 

      t.timestamps
    end
  end
end
