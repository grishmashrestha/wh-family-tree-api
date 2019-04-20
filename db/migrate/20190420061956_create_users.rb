class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :address
      t.integer :father_id

      t.timestamps
    end
  end
end
