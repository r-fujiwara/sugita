require 'gitter'

class Stream

  def self.run
    instance = new
    instance.run_single
  end

  def initialize
    @token = load_yml.fetch("token")
    @gitter = Gitter::Client.new @token
    @room_ids = @gitter.rooms.map &:id
    @req_urls = build_urls
  end

  def load_yml
    yml_path = File.join Rails.root, 'app/daemon', 'token.yml'
    YAML.load_file(yml_path)
  end

  def build_urls
    @room_ids.map do |id|
      "https://stream.gitter.im/v1/rooms/#{id}/chatMessages"
    end
  end

  def run_single

    EventMachine.run do
      puts "start single process"
      room = @gitter.rooms.select{|room| room[:name] == 'r-fujiwara/private'}.first
      neko_stream_url = "https://stream.gitter.im/v1/rooms/#{room['id']}/chatMessages"
      http = EM::HttpRequest.new(neko_stream_url, keepalive: true, connect_timeout: 0, inactivity_timeout: 0)
      req = http.get(head: {'Authorization' => "Bearer #{@token}", 'accept' => 'application/json'})

      req.stream do |chunk|
        unless chunk.strip.empty?
          message = JSON.parse(chunk)
          PostInjecter.set_record message, @token, room['id'], room['name']
          p [:message, message]
          p "class...#{message.class}"
          p "user_name...#{message['fromUser']['username']}"
          p "html_content...#{message['html']}"
        end
      end

    end
  end

  def run_parallel
    EventMachine.run do
      puts "start multi process"
      multi = EventMachine::MultiRequest.new

      @req_urls.each do |url|
        http = EM::HttpRequest.new(url, keepalive: true, connect_timeout: 0, inactivity_timeout: 0)
        req = http.get(head: {'Authorization' => "Bearer #{@token}", 'accept' => 'application/json'})
        multi.add(req)
      end

      multi.callback do
        multi.stream.each do |chunk|
          unless chunk.strip.empty?
            message = JSON.parse(chunk)
            p [:message, message]
          end
        end

        EventMachine.stop
      end
    end
  end

end

module PostInjecter
  module_function

  def set_record(message, token, room_id, room_name)
    message.deep_symbolize_keys!
    user_id = user message
    room room_name, user_id
    post message, user_id
  end

  def user(message)
    id = message[:fromUser][:id]
    name = message[:fromUser][:username]
    user = User.find_or_create_by name: name, gitter_id: id
    user.id
  end

  def post(message, user_id, room_id)
    gitter_id = message[:id]
    raw_html = message[:html]
    Post.create user_id: user_id, gitter_id: gitter_id, content: raw_html, room_id: room_id
  end

  def room(room_name, user_id)
    room = Room.find_or_create_by name: room_name
    RoomsUser.find_or_create_by room_id: room.id, user_id: user_id
  end

end


#sd = StreamDaemon.new
#sd.run_parallel
#sd.run_single
