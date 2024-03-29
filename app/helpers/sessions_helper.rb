module SessionsHelper
  def log_in(user)
    session[:user_id]=user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token]=user.remember_token
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
	@current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    if(order_on?)
      close
    end
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def open(order)
    session[:order_id]=order.id
  end

  def current_order
    if current_user.type == "Buyer"
      @buyer = Buyer.find(current_user.id)
      @current_order ||= @buyer.orders.find_by(id: session[:order_id])
    else
      @current_order = nil
    end
  end

  def order_on?
    !current_order.nil?
  end

  def close
    session.delete(:order_id)
    @current_order = nil
  end

end
