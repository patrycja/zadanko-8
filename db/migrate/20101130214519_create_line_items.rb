class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
	  t.integer :product_id, :null => false
	  t.integer :order_id, :null => false
	  t.integer :quantity, :null => false
	  t.decimal :total_price, :null => false, :precision => 8, :scale => 2

      t.timestamps
    end
	
	execute "alter table line_items add constraint fk_line_item_products
              foreign key (product_id) references products(id)"
			  
    execute "alter table line_items add constraint fk_line_item_orders
              foreign key (order_id) references orders(id)"
  end

  def self.down
    drop_table :line_items
  end
end
