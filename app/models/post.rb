class Post < ActiveRecord::Base
  belongs_to :users
  belongs_to :rooms

  searchable do
    text :content
  end
end
