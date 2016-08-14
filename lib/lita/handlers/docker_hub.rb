module Lita
  module Handlers
    class DockerHub < Handler
      config :room, type: String, default: "general"

      http.post "/docker-hub/receive", :receive

      def receive(request, response)
        room = config.room
        message = parse(request.body.string)
        send_message_to_room(message.inspect, room)

        response.headers["Content-Type"] = "application/json"
        response.write("ok")
      end

      Lita.register_handler(self)

      private

      def parse(obj)
        MultiJson.load(obj)
      end
    end
  end
end
