class BuyersController < ApplicationController

  def index
    @buyers=Buyer.all
  end

  def show
    @buyer=Buyer.find(params[:id])
  end
  
  def new
    @buyer=Buyer.new
  end
   
  def edit
    @buyer=Buyer.find(params[:id])
    @farms=Farm.all.sort_by{|f| f.distance_to(@buyer) }
    @nearfarms = Farm.near(@buyer,50)
    @myfarms = @buyer.farms.sort_by{|f| f.distance_to(@buyer) }
    @dists = Distributor.all
    @mydists = @buyer.distributors
  end
  
  def create
    @buyer=Buyer.new(params[:user])
    if @buyer.save
      redirect_to @buyer
    else
      render User.new
    end
  end

  def update
    @buyer=Buyer.find(params[:id])
    @buyer.update_attribute(:name, params[:buyer][:name])
    @buyer.update_attribute(:email, params[:buyer][:email])
    @buyer.update_attribute(:location, params[:buyer][:location])
    redirect_to edit_buyer_path(@buyer)
  end

  def destroy
    @buyer=Buyer.find(params[:id])
    @buyer.destroy
    redirect_to buyers_path
  end

  #for not-yet-specified orders
  def add_prod
    @buyer = Buyer.find(params[:id])
    @order = Order.find_by(name: params[:order][:order])
    @pro = Product.find(params[:format])
    @order.products.push(@pro)

    redirect_to edit_buyer_order_path(@buyer, @order)
  end

  def add_farm
    @buyer = Buyer.find(params[:id])
    @farms = Farm.all
  end

  def new_farm
    @buyer = Buyer.find(params[:id])
    @buyer.farms.push(Farm.find(params[:format]))
    redirect_to edit_buyer_path(@buyer)
  end

  def remove_farm
    @buyer = Buyer.find(params[:id])
    @buyer.farms.delete(Farm.find(params[:format]))
    redirect_to edit_buyer_path(@buyer)
  end

  def add_dist
    @buyer = Buyer.find(params[:id])
    @dists = Distributor.all
  end

  def new_dist
    @buyer = Buyer.find(params[:id])
    @buyer.distributors.push(Distributor.find(params[:format]))
    redirect_to edit_buyer_path(@buyer)
  end

  def remove_dist
    @buyer = Buyer.find(params[:id])
    @buyer.distributors.delete(Distributor.find(params[:format]))
    redirect_to edit_buyer_path(@buyer)
  end

end
