module RenderMethods

  def render_error(object_error)
    render json: object_error
  end
end