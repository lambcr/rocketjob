require "mongo/monitoring/command_log_subscriber"

module Mongo
  class Monitoring
    class CommandLogSubscriber
      include SemanticLogger::Loggable
      logger.name = "Mongo"

      undef :started
      def started(event)
        @event_command = event.command
      end

      undef :succeeded
      def succeeded(event)
        logger.debug(message:  prefix(event),
                     duration: (event.duration * 1000),
                     payload:  @event_command)
      end

      undef :failed
      def failed(event)
        logger.debug(message:  "#{prefix(event)} Failed: #{event.message}",
                     duration: (event.duration * 1000),
                     payload:  @event_command)
      end

      undef :prefix
      def prefix(event)
        "#{event.address} | #{event.database_name}.#{event.command_name}"
      end
    end
  end
end
