class ComponentsController < ApplicationController
  # map component by url
  def component
    # check auth?.. by user_id?

    # component = 'Counter::Component'.constantize
    component = params.extract(:component).constantize
    method = params.extract(:method) # :increment

    # check component - is ViewComponent, and user have access to it
    # to prevent arbitrary code run

    # приватные параметры не будут отображаться
    # методов с параметрами не будет? или что-то ещё отправлять
    component = component.new(params).call(method)
    render_component component.render
  end
end
