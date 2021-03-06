require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @already_built_response = false
    @session = Session.new(req)
    @params = route_params
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    if @already_built_response
      return true
    end
    false
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response?
      raise "Error, already rendered"
    end
    @res["Location"] = url
    @res.status = 302
    @already_built_response = true
    @session.store_session(@res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    if already_built_response?
      raise "Error already rendered content"
    end
    @res["Content-Type"] = content_type
    @res.write(content)
    @res.finish
    @already_built_response = true
    @session.store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    path_to_template = "#{Dir.pwd}/views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    content = File.read(path_to_template)
    render_content(content, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name.to_sym)
  end
end
