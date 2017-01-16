module DeviseHelper

  def show_error_messages

    alert_title = "警告！" if alert || devise_error_messages?
    alert_messages = add_content(nil, alert) if alert
    resource.errors.values.each {|msg| alert_messages = add_content(alert_messages || nil, msg[0])} if devise_error_messages?

    if alert_title
      html = <<-HTML
      <div id="error_explanation">
        <div class="alert alert-warning alert-dismissible" role="alert">
          <button type="button" class="close" data-dismiss="alert">
            <span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
          </button>
          <h2 style="margin-top: 0px;">#{alert_title}</h2>
          <ul>#{alert_messages}</ul>
        </div>
      </div>
      HTML
      html.html_safe
    end
  end

  private

  def devise_error_messages?
    !resource.errors.empty?
  end

  def add_content(msg, content)
    msg.present? ? msg += content_tag(:li, content) : msg = content_tag(:li, content)
  end

end