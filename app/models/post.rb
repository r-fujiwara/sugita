class Post < ActiveRecord::Base
  belongs_to :users
  belongs_to :rooms

  searchable do
    text :content, :stored => true
  end

  def around(number)
    previous = with_previous_same_room number
    nexts = with_next_same_room number
    ((nexts << previous) << self).flatten.uniq.sort_by &:id
  end

  def with_previous_same_room(number)
    self.class.where("id < ?", id).where(room_id: room_id).last(number)
  end

  def with_next_same_room(number)
    self.class.where("id > ?", id).where(room_id: room_id).first(number)
  end

end
