class Counter::Component < AppComponent
  # должен совпадать с параметром в initialize, и с instance_variable
  component_attributes :count

  def initialize(params)
    # TODO: can we store params somehow withot super?
    super(params) # to store params to @params. maybe can be cleaner?
    @count = params[:count] || 0
  end

  def increment
    @count += 1
  end
end
