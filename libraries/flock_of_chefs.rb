module FlockOfChefs
  class << self
    def search(*args)
      Array(Chef::Query::Search.new.search(*args).first).map do |n|
        FlockOfChefs[n.name]
      end
    end
  end
  module Waiter
    def do_wait_until(pause = 1.0, &block)
      until(block.call)
        sleep(pause)
      end
    end

    def do_wait_while(pause = 1.0, &block)
      while(block.call)
        sleep(pause)
      end
    end

    def wait_until(pause = 1.0, &block)
      @wait_until = {:pause => pause, :block => block}
    end

    def wait_while(pause, &block)
      @wait_while = {:pause => pause, :block => block}
    end

    def flocked_provider_for_action(*args)
      if(@wait_until)
        do_wait_until(@wait_until[:pause]) do
          @wait_until[:block].call
        end
      end
      if(@wait_while)
        do_wait_while(@wait_while[:pause]) do
          @wait_while[:block].call
        end
      end
      unflocked_provider_for_action(*args)
    end

    class << self
      def included(base)
        base.class_eval do
          unless(instance_methods.map(&:to_sym).include?(:unflocked_provider_for_action))
            alias_method :unflocked_provider_for_action, :provider_for_action
            alias_method :provider_for_action, :flocked_provider_for_action
          end
        end
      end
    end
  end
end

unless(Chef::Resource.ancestors.include?(FlockOfChefs::Waiter))
  klasses = Chef::Resource.constants.map{|x| Chef::Resource.const_get(x) }.find_all do |con|
    con.is_a?(Class) && con < Chef::Resource
  end
  klasses.push(Chef::Resource).each do |klass|
    klass.send(:include, FlockOfChefs::Waiter)
  end
end
