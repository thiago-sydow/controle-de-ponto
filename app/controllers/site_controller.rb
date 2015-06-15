class SiteController < ApplicationController
  def index
    @contact = Contact.new
    render layout: false
  end

  def contact
    @contact = Contact.new(contact_params)
    @contact.request = request

    if @contact.deliver
      flash.now[:notice] = t 'mail_form.action.success'
    else
      flash.now[:error] = t 'mail_form.action.error'
    end

    @render_from_form = true
    render 'index', layout: false
  end

  def thank_you
    render layout: 'authentication'
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message, :nickname)
  end

end
