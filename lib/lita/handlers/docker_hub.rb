require "time_difference"

module Lita
  module Handlers
    class DockerHub < Handler
      config :room, type: String, default: "general"

      http.post "/docker-hub/receive", :receive

      def receive(request, response)
        target = Source.new(room: find_room_id_by_name(config.room))
        body = parse(request.body.read)

        repo_name = body.fetch("repository", {}).fetch("repo_name", nil)
        repo_url = body.fetch("repository", {}).fetch("repo_url", nil)
        tag = body.fetch("push_data", {}).fetch("tag", nil) || "nil"

        pushed_at = body.fetch("push_data", {}).fetch("pushed_at", Time.now)
        started_at = Time.at(pushed_at)
        build_time = TimeDifference.between(started_at, Time.now).humanize

        message = "Docker Hub build of #{repo_name}@#{tag} passed in #{build_time}"

        Lita.logger.debug target
        Lita.logger.debug message

        robot.send_message(target, message)

        response.headers["Content-Type"] = "application/json"
        response.write("ok")
      rescue => error
        Lita.logger.error error.message
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
