class Room < ActiveRecord::Base
  has_many :rooms_users
  has_many :users, through: :rooms_users

  
end
