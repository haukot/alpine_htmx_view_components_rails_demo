class ComponentsController < ApplicationController
  # map component by url
  def component
    # check auth?.. by user_id?

    # TODO: это на самом деле не AppComponent, а какой-то другой сервис
    component_class = AppComponent.detect(params.delete(:component))
    method = params.delete(:component_method) # :increment

    # TODO: check user have access to component and method
    # to prevent arbitrary code run
    unless component_class.method_defined?(method)
      raise "Method not found #{method} #{component_class}"
    end

    # приватные параметры не будут отображаться
    # методов с параметрами не будет? или что-то ещё отправлять
    component = component_class.new(params)
    component.send(method)

    render component, content_type: "text/html", layout: false
  end
end
