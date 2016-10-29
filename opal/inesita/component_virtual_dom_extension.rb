module Inesita
  module ComponentVirtualDomExtension
    def self.included(base)
      base.alias_method :__a, :a
      base.define_method(:a) do |params, &block|
        params = { onclick: -> { router.go_to(params[:href]) } }.merge(params) if params[:href] && respond_to?(:router)
        __a(params, &block)
      end
    end

    def component(comp, opts = {})
      raise Error, "Component is nil in #{self.class} class" if comp.nil?
      @__virtual_nodes__ ||= []
      @__virtual_nodes__ << cache_component(comp) do
        comp.is_a?(Class) ? comp.new : comp
      end.with_props(opts[:props] || {}).render_virtual_dom
    end
  end
end
