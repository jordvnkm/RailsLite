class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  # checks if pattern matches path and method matches request method
  def matches?(req)
    match1 = /#{@pattern}/.match(req.path)

    if !match1.nil? && match1[0] == req.path
      if @http_method == req.request_method.downcase.to_sym
        return true
      end
    end
    false
  end

  # use pattern to pull out route params (save for later?)
  # instantiate controller and call controller action
  def run(req, res)
    if matches?(req)
      @controller = @controller_class.new(req, res, {})
      @controller.invoke_action(http_method)
    end
  end

end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # simply adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes.push(Route.new(pattern, method, controller_class, action_name))
  end

  # evaluate the proc in the context of the instance
  # for syntactic sugar :)
  def draw(&proc)
    
  end

  # make each of these methods that
  # when called add route
  [:get, :post, :put, :delete].each do |http_method|
  end

  # should return the route that matches this request
  def match(req)
  end

  # either throw 404 or call run on a matched route
  def run(req, res)
  end
end
