class CreateMattrs < ActiveRecord::Migration
  def self.up
    create_table(:mattrs) do |t|
       t.string :meta_key, :null => false
       t.text :meta_value
       t.references :target, :polymorphic => true, :null => false
       
       t.timestamps
    end

    add_index :mattrs, :meta_key
    add_index :mattrs, :meta_value, :length => 255
    add_index :mattrs, :target_id
    add_index :mattrs, :target_type
  end

  def self.down
    drop_table :mattrs
  end
end
