class AddRoomidToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :room_id, :id
  end
end
