# encoding: UTF-8
require 'active_support/concern'

module RocketJob
  module Concerns
    # Define before and after callbacks
    #
    # class MyJob < RocketJob::Job
    #   before_perform do
    #     puts "BEFORE 1"
    #   end
    #
    #   around_perform do |job, block|
    #     puts "AROUND 1 BEFORE"
    #     block.call
    #     puts "AROUND 1 AFTER"
    #   end
    #
    #   before_perform do
    #     puts "BEFORE 2"
    #   end
    #
    #   after_perform do
    #     puts "AFTER 1"
    #   end
    #
    #   around_perform do |job, block|
    #     puts "AROUND 2 BEFORE"
    #     block.call
    #     puts "AROUND 2 AFTER"
    #   end
    #
    #   after_perform do
    #     puts "AFTER 2"
    #   end
    #
    #   def perform
    #     puts "PERFORM"
    #     23
    #   end
    # end
    #
    # MyJob.new.work_now
    #
    # Output from the example above
    #
    #  BEFORE 1
    #  AROUND 1 BEFORE
    #  BEFORE 2
    #  AROUND 2 BEFORE
    #  PERFORM
    #  AFTER 2
    #  AROUND 2 AFTER
    #  AFTER 1
    #  AROUND 1 AFTER
    module Callbacks
      extend ActiveSupport::Concern
      include ActiveSupport::Callbacks

      included do
        @rocketjob_callbacks = ThreadSafe::Hash.new

        define_callbacks :perform

        def self.before_perform(*filters, &blk)
          set_callback(:perform, :before, *filters, &blk)
        end

        def self.after_perform(*filters, &blk)
          set_callback(:perform, :after, *filters, &blk)
        end

        def self.around_perform(*filters, &blk)
          set_callback(:perform, :around, *filters, &blk)
        end

        def self.before(method_name, *filters, &blk)
          define_callbacks(method_name) unless callbacks_defined?(method_name)
          set_callback(method_name, :before, *filters, &blk)
        end

        def self.after(method_name, *filters, &blk)
          define_callbacks(method_name) unless callbacks_defined?(method_name)
          set_callback(method_name, :after, *filters, &blk)
        end

        def self.around(method_name, *filters, &blk)
          define_callbacks(method_name) unless callbacks_defined?(method_name)
          set_callback(method_name, :around, *filters, &blk)
        end

        protected

        # Returns [true|false] whether callbacks are defined for the supplied perform method
        def self.callbacks_defined?(method_name)
          respond_to?("_#{method_name}_callbacks".to_sym)
        end

      end

    end
  end
end