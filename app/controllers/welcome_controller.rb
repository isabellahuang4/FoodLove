class WelcomeController < ApplicationController

  def about
  end

  def contact
  end

  def send_contact
    UserMailer.contact(params[:contact][:message], params[:contact][:name], params[:contact][:email]).deliver_now
    flash[:notice] = "Your message has been sent! We will be in touch shortly."
    redirect_to root_path
  end

end
