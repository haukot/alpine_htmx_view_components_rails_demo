class Counter::Component < AppComponent
  # TODO: опциональные валидации на параметры? И будет ближе к grape
  # но это уже не зона ответственности ViewComponent'a - но поэтому у нас и
  # AppComponent!
  # Но раз у нас AppComponent, то мб и рендер ViewComponent'ов в него вынести?
  component_attributes :count

  def initialize(params)
    @count = params[:count] || 0
  end

  def increment
    @count += 1
  end
end
