module Lita
  module Handlers
    class DockerHub < Handler
      config :room, type: String, default: "general"

      http.post "/docker-hub/receive", :receive

      def receive(request, response)
        response.headers["Content-Type"] = "application/json"

        body = parse(request.body.read)
        repo_name = body.fetch("repository", {}).fetch("repo_name", nil)
        repo_url = body.fetch("repository", {}).fetch("repo_url", nil)
        tag = body.fetch("push_data", {}).fetch("tag", nil)
        pushed_at = body.fetch("push_data", {}).fetch("pushed_at", nil)

        if repo_name.present? && repo_url.present? && tag.present? && pushed_at.present?
          build_time = time_interval(Time.at(pushed_at), Time.now)

          target = Lita::Source.new(room: '#general') #Source.new(room: find_room_id_by_name(config.room))
          message = render_template("build", repo_name: repo_name,
                                             repo_url: repo_url,
                                             tag: tag,
                                             build_time: build_time)
          Lita.logger.debug target.id + " " + target.name
          Lita.logger.debug message

          robot.send_message(target, message)

          response.write("ok")
        else
          response.write("error")
        end
      rescue => error
        Lita.logger.error error.message

        response.write("error")
      end

      Lita.register_handler(self)

      private

      def parse(obj)
        MultiJson.load(obj)
      end

      def time_interval(start_time, end_time)
        interval = (end_time - start_time).round
        min, sec = interval.divmod(60)
        "#{min} min and #{sec} sec"
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
