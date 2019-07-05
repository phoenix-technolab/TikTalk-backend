module RenderMethods

  def render_error(message, status = 400)
    render json: { error: message }, status: status
  end
end