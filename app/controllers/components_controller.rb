class ComponentsController < ApplicationController
  # map component by url
  def component
    # check auth?.. by user_id?

    # TODO: это на самом деле не AppComponent, а какой-то другой сервис
    component = AppComponent.detect(params.delete(:component))
    method = params.delete(:method) # :increment

    # TODO: check user have access to component and method
    # to prevent arbitrary code run
    unless component.public_methods.include?(method)
      raise "Method not found #{method} #{component}"
    end

    # приватные параметры не будут отображаться
    # методов с параметрами не будет? или что-то ещё отправлять
    component = component.new(params).call(method)
    render_component component.render
  end
end
