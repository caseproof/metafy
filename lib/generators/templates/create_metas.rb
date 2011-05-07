class CreateMetas < ActiveRecord::Migration
  def self.up
    create_table(:metas) do |t|
       t.string :meta_key, :null => false
       t.text :meta_value
       t.references :target, :polymorphic => true, :null => false
       
       t.timestamps
    end

    add_index :metas, :meta_key
    add_index :metas, :meta_value, :length => 255
    add_index :metas, :target_id
    add_index :metas, :target_type
  end

  def self.down
    drop_table :metas
  end
end