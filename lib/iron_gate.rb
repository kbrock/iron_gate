module IronGate
end

#require 'iron_gate/extensions/routes'
require 'iron_gate/acts_as_gated'
require 'iron_gate/closed'

ActionController::Base.send :include, IronGate::ActsAsGated


