module DeviseHelper

  def devise_alert_messages!
   return '' unless alert

   formatted_login_error(alert)
 end

  private

  def formatted_login_error(alert)
    html = <<-HTML
    <div class="alert alert-danger">
        <h4 class="alert-heading">Oops</h4>
        <p>#{alert}</p>
    </div>
    HTML

    html.html_safe
  end

end
