class Counter::Component < ViewComponent
  def initialize
    @count = 0
  end

  def increment
    @count += 1
  end
end
