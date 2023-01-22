class AppComponent < ViewComponent::Base
  attr_reader :component_params

  def self.component_attributes(*attributes)
    @@component_attributes = attributes
    attr_accessor(*attributes)
  end

  def self.component_attribute(attribute)
    @@component_attributes ||= []
    @@component_attributes << attribute
    attr_accessor(attribute)
  end

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

  def self.component_url
    # TODO: use rails routes helpers?
    "/components/#{self.component_name}"
  end

  # TODO: это хелпер
  def self.render_with_htmx(component)
    render_inline(component, layout: 'with_htmx_state')
  end

  def initialize(params)
    #@component_params = params
  end

  def component_name
    self.class.component_name
  end

  def component_context
    # TODO: приватные переменные не очень хотелось бы выдавать? тут и классы могут
    # быть всякие, и на вход то мы только параметры принимаем!
    # т.е. instance_variable должен названием совпадать с параметром

    # self.instance_variables.each_with_object({}) do |attribute, hash|
    #   hash[attribute] = self.instance_variable_get(attribute)
    # end

    # параметры не меняеются после вызова метода - а нам надо выдавать обновленное
    # component_params

    puts "HUI #{@@component_attributes}"
    res = @@component_attributes.each_with_object({}) do |attr, h|
      h[attr] = instance_variable_get("@#{attr}")
    end
    res['component_url'] = self.class.component_url
    res['component_css_class'] = component_css_class

    res
  end

  # TODO: надо ещё какой-то key добавить, на случай если выводят список
  # Или мб это внутри компонента в этом случае будет писаться
  def component_css_class
    "component-#{self.class.component_name}"
  end

  def use_htmx_reflex
    render "/reflex_component_base", component: self, captured: capture {
      yield
    }
  end
end
