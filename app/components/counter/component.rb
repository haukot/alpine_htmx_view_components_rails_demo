# мб рядом положить Counter::View? где какие-то параметры самой вьюхи менеджить?
class Counter::Component < AppComponent #ViewComponent
  # or def initialize(count: 0) ?
  def initialize(params)
    @count = pararms[:count] || 0
  end

  def increment
    @count += 1
  end

  def render
    # some options before render?
  end

  # в статье написать про исходные данные - один разраб, создание в основном админок
  # но с разным функционалом

  # TODO: валидации(просто рисуем? но тоже какой-то общий компонент бы мб)
  # Вообще нужен какой-то лучший пример, вот тут форма класснее
  # https://www.saaspegasus.com/guides/modern-javascript-for-django-developers/htmx-alpine/
  # Counter слишком простой

  # Автодополнение серверное мб? Типо search. Тоже генерить апи.
  # как будто не проблема?
  def search
    # результаты. список options, если надо
    # Но что это за компонент? Или весь html формы перекидывать?
    # Selection не спадёт вообще? А какой selection когда мы в инпуте печатаем?

    # но если нужна будет вторая апиха -
    # то придется что-то дублировать(или в сервисы выносить)
  end

  def component_context
    # need to namespace, because htmx also sends inputs. But maybe it's okay?
    # Do we need to different instance and sended params?
    # (Event component initializes with all params, so maybe not?)

    # { instance_variables: ... }
    self.instance_variables.map do |attribute|
      { attribute => self.instance_variable_get(attribute) }
    end
  end

  ## in routes
  def route
    # parse
    "/components/:component -> components#component"
    "/components/counter?method=increment&count=0"
  end

  # только это будут не view component? а контроллеры фактически.
  # они будут дергать сервисы и всё такое
  # могу в целом базовый контроллер назвать не view_component, а service_component?
  # или как-то так
  # Operations это вроде называлось в traiblazer'e?

  private

  def component_url
    # generate
    "/components/counter?method=increment&count=0"

    # or post(better)
    c("/components/counter", data: {method: 'increment', count: 0 })
  end

  def container_class
    # from evil martians view_components-contrib
  end

  def component_name
    # весь неймспейс до ::Component
    'counter'
  end

  def reflex(method)
    params = {} # all curren instance variables?
    url = component_url(Counter::Component, :increment, params)
    # CHECK: will hx rewrite these attributes, if I'll duplicate them?
    # (if I want to change them)
    # (or we can make them as parameters, ofcourse)
   "hx-post='#{url}' hx-trigger='click' hx-ext='json-enc'
    hx-target='#{container_class}' hx-swap='outerHTML'"
  end

  def reflex_tag(method, tag, name)
    params = {} # all curren instance variables?
    url = component_url(Counter::Component, :increment, params)
    # tag to change with rails tag helpers or something
    "
    <#{tag} hx-post='#{url}'
            hx-trigger='click'
            hx-target='#{container_class}'
            hx-swap='outerHTML'
            >
            #{name}
    </{tag}>
"
  end
end
