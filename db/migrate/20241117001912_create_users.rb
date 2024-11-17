class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :pin_digest
      t.boolean :biometric_enabled

      t.timestamps
    end
  end
end
