class DeletePostIdToPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :post_id, :integer
    add_column :posts, :gitter_id, :string
  end
end
