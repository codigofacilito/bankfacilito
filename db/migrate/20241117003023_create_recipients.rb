class CreateRecipients < ActiveRecord::Migration[7.2]
  def change
    create_table :recipients do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
