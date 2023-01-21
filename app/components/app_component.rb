class AppComponent < ViewComponent::Base
  attr_reader :component_params

  def self.detect(component_name)
    component = (component_name.gsub("-", "/").camelize + "::Component").constantize
    unless component.ancestors.include?(AppComponent)
      raise "Component #{component_name}, #{component} is not a subclass of AppComponent"
    end

    component
  end

  def self.component_name
    # self.name.underscore.dasherize
    # А я точно хочу убирать component?
    self.name.gsub("::Component", "").underscore.dasherize.gsub("/", "-")
  end

  def initialize(params)
    @component_params = params
  end

  def component_context
    # TODO: we don't need instance variables?
    # self.instance_variables.map do |attribute|
    #   { attribute => self.instance_variable_get(attribute) }
    # end

    component_params
  end

  def component_url(method)
    # TODO: use rails routes helpers?
    # TODO: a bit bad that we're using GET and POST params at the same time
    # maybe move it to hx-something
    "/components/#{self.component_name}?method=#{method}"
  end

  # TODO: надо ещё какой-то key добавить, на случай если выводят список
  # Или мб это внутри компонента в этом случае будет писаться
  def component_css_class
    "component-#{self.component_name}"
  end

  def reflex(method)
    params = @params # all curren instance variables?
    # CHECK: will hx rewrite these attributes, if I'll duplicate them?
    # (if I want to change them)
    # (or we can make them as parameters, ofcourse)
   "hx-post='#{self.component_url}' hx-trigger='click' hx-ext='json-enc'
    hx-target='#{component_css_class}' hx-swap='outerHTML'"
  end
end
