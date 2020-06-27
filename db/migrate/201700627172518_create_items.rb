class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
   	  t.string :name
   	  t.string :unit
   	  t.integer :target_amount
   	  t.date :target_date
      t.timestamps
    end
  end
end
