require "backtracable/version"
require "logger"

module Backtracable
  
  def self.included(klass)
    klass.class_eval do
      include InstanceMethods
    end
  end
  
  module InstanceMethods
    def logger
      @logger ||= Logger.new(STDOUT)
    end
    
    def callstack(e)
      if e.nil?
        caller
          .tap { |stack| stack.shift }
          .tap { |stack| stack.unshift("#{'>' * 10} STACKTRACE [TOP] #{'>' * 10}") }
          .tap { |stack| stack.push("#{'>' * 10} STACKTRACE [BOTTOM] #{'>' * 10}") }
      else
        e.backtrace
      end
    end

    def backtrace(exception: nil)
      logger.warn callstack(exception).join("\n")
    end
  end
  
end
