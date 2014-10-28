require 'eventmachine'
require 'em-http'
require 'yaml'
require 'json'

class StreamDaemon

  def initialize
    @room_ids = load_yml.fetch("rooms").values
    @token = load_yml.fetch("token")
    @req_urls = build_urls
    @injector = PostInjecter.new
  end

  def load_yml
    yml_path = File.join Dir.pwd, 'rooms.yml'
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
      neko_stream_url = "https://stream.gitter.im/v1/rooms/#{@room_ids.last}/chatMessages"
      http = EM::HttpRequest.new(neko_stream_url, keepalive: true, connect_timeout: 0, inactivity_timeout: 0)
      req = http.get(head: {'Authorization' => "Bearer #{@token}", 'accept' => 'application/json'})

      req.stream do |chunk|
        unless chunk.strip.empty?
          message = JSON.parse(chunk)
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

class PostInjecter
  def set_record(message)
  end
end


sd = StreamDaemon.new
#sd.run_parallel
sd.run_single
