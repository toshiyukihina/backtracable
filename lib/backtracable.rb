require "backtracable/version"

module Backtracable
  
  def self.included(klass)
    klass.class_eval do
      include InstanceMethods
    end
  end
  
  module InstanceMethods
    def backtrace(exception: nil, logger: Rails.logger, method: :warn)
      exception.nil? ?
        backtrace_info(logger, method) :
        backtrace_via_exception(exception, logger, method)
    end

    def backtrace_via_exception(e, logger, method)
      logger.send(method, "#{e.class}: #{e.message}")
      logger.send(method, e.backtrace.join("\n"))
    end

    def backtrace_info(logger, method)
      stack = caller
        .tap {|stack| stack.shift}
        .tap {|stack| stack.unshift("#{'>' * 10} STACKTRACE [TOP] #{'>' * 10}")}
        .tap {|stack| stack.push("#{'>' * 10} STACKTRACE [BOTTOM] #{'>' * 10}")}
      logger.send(method, stack.join("\n"))
    end
  end
  
end


=begin
class SomeClass

  include Backtracable

  def some_method
    # Dump backtrace to the logger. (default: Rails.logger)
    backtrace(method: :debug)
  end

  def some_method_handling_exception

    # do something ...

  rescue RuntimeError => e
    backtrace(exception: e)
  end

end
=end
