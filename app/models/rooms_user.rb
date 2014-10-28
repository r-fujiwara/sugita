class RoomsUser < ActiveRecord::Base
  belongs_to :users
  belongs_to :rooms
end
