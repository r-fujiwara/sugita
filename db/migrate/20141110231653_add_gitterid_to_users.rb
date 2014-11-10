class AddGitteridToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gitter_id, :string
  end
end
