module Lita
  module Handlers
    class DockerHub < Handler
      config :room, type: String, default: "general"

      http.post "/docker-hub/receive", :receive

      def receive(request, response)
        target = Source.new(room: find_room_id_by_name(config.room))
        body = parse(request.body.read)
        pushed_at = body.fetch("push_data", {}).fetch("pushed_at", nil)
        pushed_at = Time.at(pushed_at) unless pushed_at.nil?
        tag = body.fetch("push_data", {}).fetch("tag", nil)

        description = body.fetch("repository", {}).fetch("description", nil)
        repo_name = body.fetch("repository", {}).fetch("repo_name", nil)
        repo_url = body.fetch("repository", {}).fetch("repo_url", nil)

        message = "Repository "
        message += "#{repo_name} " unless repo_name.nil?
        message += "at #{repo_url} " unless repo_url.nil?
        message += "built at Docker Hub"
        message += " with tag #{tag}" unless tag.nil?

        Lita.logger.debug target
        Lita.logger.debug message

        robot.send_messages(target, message)

        response.headers["Content-Type"] = "application/json"
        response.write("ok")
      rescue => error
        log_error(robot, error, message: message)
      end

      Lita.register_handler(self)

      private

      def parse(obj)
        MultiJson.load(obj)
      end

      def find_room_id_by_name(room_name)
        case robot.config.robot.adapter.to_s.to_sym
        when :slack
          if room = ::Lita::Room.find_by_name(room_name)
            return room.id
          else
            ::Lita::Room.find_by_name("general").id
          end
        else
          room_name
        end
      end
    end
  end
end
