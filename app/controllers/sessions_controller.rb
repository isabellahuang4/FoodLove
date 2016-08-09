class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to edit_user_path(user)
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    if logged_in?
      log_out
      flash[:notice] = "You have successfully logged out."
    end
    redirect_to root_url
  end

  def order_start
    @buyer = Buyer.find(current_user.id)
    order = @buyer.orders.find(params[:order_id])
    open order
    redirect_to edit_buyer_order_path(@buyer.id, order.id)
  end

  def order_end
    close if order_on?
    redirect_to edit_buyer_path(current_user.id)
  end

end
