require "active_support"
require "active_support/core_ext"
require "erb"
require_relative "./session"

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "double render error" if already_built_response?
    @already_built_response = true
    @res.status = 302
    @res["Location"] = url
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type = "text_html")
    raise "double render error" if already_built_response?
    @already_built_response = true
    @res.write(content)
    @res["Content-Type"] = content_type
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    path = File.dirname(__FILE__)
    file_path = File.join(Path, "views", "#{template_name}.html.erb")
    content = File.read(title_path)
    erb_code = ERB.new(content).result(binding)
    render_content(erb_code)
  end

  # method exposing a `Session` object
  def session
    @session = {}
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
