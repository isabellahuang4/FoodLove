class UsersController < ApplicationController

  def index
    @users=User.all
  end

  def new
    @user=User.new 
  end

  def create
    type=params[:user][:type]
    case type
      when "Farm"
        puts "farm"
        @user=Farm.new({ :name => params[:user][:name],
			 :email => params[:user][:email],
			 :password => params[:user][:password],
			 :password_confirmation => params[:user][:password_confirmation],
			 :location => params[:user][:location],
			 :type => type })
      when "Buyer"
        puts "buyer"
        @user=Buyer.new({ :name => params[:user][:name],
	                 :email	 => params[:user][:email],
                         :password => params[:user][:password],
                         :password_confirmation	=> params[:user][:password_confirmation],
                         :location => params[:user][:location],
                         :type => type })
      when "Distributor"
        puts "distributor"
        @user=Distributor.new({ :name => params[:user][:name],
		                :email	=> params[:user][:email],
	                        :password => params[:user][:password],
                         	:password_confirmation	=> params[:user][:password_confirmation],
				:location => '',
                          	:type => type })
      else
        render 'new'
    end 
    if @user.save
      log_in @user
      flash[:success]="Welcome!"
      UserMailer.welcome_email(@user).deliver_now
      redirect_to edit_user_path(@user)
    else
      render 'new'
    end
  end

  def show
    type=params[:type]
    case type
      when "Farm"
        @user=Farm.find(params[:id])
      when "Buyer"
        @user=Buyer.find(params[:id])
      when "Distributor"
        @user=Distributor.find(params[:id])
      else
        render 'index'
    end
  end

  def edit
    @user = User.find(params[:id])
    type= @user.type
    case type
      when "Farm"
        redirect_to edit_farm_path(@user)
      when "Buyer"
        redirect_to edit_buyer_path(@user)
      when "Distributor"
        redirect_to edit_distributor_path(@user)
      else 
        render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    @user.update
  end
  
  def destroy
    log_out
    @user = User.find(params[:id])
    @user.destroy

    redirect_to root_url
  end


#  private
#    def user_params
#      params.require(:user).permit(:name, :email, :password, :password_confirmation)
#    end

end
