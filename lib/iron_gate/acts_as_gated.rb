module IronGate
  module ActsAsGated
    def self.included(base) # :nodoc:
      base.extend ClassMethods
      base.send :include,SingletonMethods
    end
  end

  module ClassMethods
    def acts_as_gated(options = {})
      #metaclass = (class << self; self; end)
      
      template = options.delete(:template)||'shared/gate_closed'
      gate_name = options.delete(:gate_name)
      cattr_accessor :iron_gate_closed_template
      self.iron_gate_closed_template=template

      self.send :before_filter, :deny_not_nice, options
      self.send :rescue_from, IronGate::Closed, :with => :render_iron_gate_closed

      #gate_name specifies the route name
      #e.g. :gate_name => 'green' means green/open starts things and green/closed stops

      #adding directly to the config files would be better (would show up in rake routes)
      #but want the gate name to be custom per application. (security by obscurity)
      if gate_name
        ActionController::Routing::Routes.draw do |map|
          map.resource gate_name,
            :controller => 'iron_gate/gate',
            :only       => nil, :collection => %w(open close)
        end
      end
    end
  end

  module SingletonMethods
    def render_iron_gate_closed
      render :template => self.iron_gate_closed_template, :layout => false
    end

    def deny_not_nice
      raise IronGate::Closed if cookies['nice']!='true'
    end
  end
end