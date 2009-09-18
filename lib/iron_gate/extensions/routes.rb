if defined?(ActionController::Routing::RouteSet) && defined?(Rails) #&& !Rails.env.production?
  class ActionController::Routing::RouteSet
    def load_routes_with_iron_gate!
      lib_path = File.dirname(__FILE__)
      iron_gate_routes = File.join(lib_path, *%w[.. .. .. config iron_gate_routes.rb])
      unless configuration_files.include?(iron_gate_routes)
        add_configuration_file(iron_gate_routes)
      end
      load_routes_without_iron_gate!
    end

    alias_method_chain :load_routes!, :iron_gate
  end
end
