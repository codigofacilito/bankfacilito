class AddDefaultOnAccount < ActiveRecord::Migration[7.2]
  def change
    add_column :accounts, :default, :boolean, default: false
  end
end
