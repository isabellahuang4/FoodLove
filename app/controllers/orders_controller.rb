class OrdersController < ApplicationController

  def show
    @buyer = Buyer.find(params[:buyer_id])
    @order = Order.find(params[:id])
    @products = @order.products
    if logged_in? && current_user.type == "Farm"
      @farm = Farm.find(current_user.id)
    else
    end
  end

  def new
    @order=Order.new
  end

  def create
    @buyer = Buyer.find(params[:buyer_id])
    @order = @buyer.orders.create({:name => params[:order][:name],
    	                           :buyer_id => params[:order][:buyer_id]})
    redirect_to edit_buyer_path(@buyer)
  end

  def edit
    @buyer = Buyer.find(params[:buyer_id])
    @order = Order.find(params[:id])
    @products = @order.products
  end

  def add_product
    @buyer = Buyer.find(params[:buyer_id])
    @order = Order.find(params[:id])
    @product = Product.find(params[:format])
    @order.products.push(@product)
    @farm = Farm.find(@product.farm_id)
    redirect_to @farm
  end

  def remove_product
    @buyer = Buyer.find(params[:buyer_id])
    @order = Order.find(params[:id])
    @product = Product.find(params[:format])
    @order.products.delete(@product)

    redirect_to edit_buyer_order_path(@buyer,@order)
  end

  def place
    @buyer = Buyer.find(params[:buyer_id])
    @order = Order.find(params[:id])
    @prods = @order.products.flatten

    @order.update_attribute(:placed, DateTime.now)

    #print order spreadsheet
    print_all
    #send entire order sheet to self and download
    send_file Rails.root.join('print', 'orders', "#{@buyer.name}_#{Date.current}.xls")
    UserMailer.order_self(@order).deliver_now
    
    #print sheet for each farm and send to each farm
    @prods = @prods.sort_by{|p| [p.farm_id]}
    while @prods != []
      i = -1
      @farm = @prods[0].farm_id
      @prods.each do |p|
        if p.farm_id == @farm
	  i+=1
	else
	  break
	end
      end

      #splice
      @farm_pros = @prods.slice!(0..i)

      #print and send
      print_farm(@farm_pros)
      UserMailer.order_farm(@farm_pros, @order).deliver_now

      #give order to farm
      Farm.find(@farm).add_order(@order,@farm)
    end

    #print sheet for each distributor and send
    @dists=@buyer.distributors
    @dists.each do |d|
      @list = included(d,@order)      
      if @list != nil
        d.orders.push(@order)
	print_farms(@list,d)
        #send distributor order for farms included
	UserMailer.order_dist(d,@order).deliver_now
      end
    end
    
  end

  def print
    print_all
    redirect_to edit_buyer_order_path(@buyer,@order)    
  end

  private
    
    def print_all
      @buyer = Buyer.find(params[:buyer_id])
      @order = Order.find(params[:id])
      @products = @order.products

      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet
      i=0

      #header
      sheet.row(i).push @buyer.name, @order.name
      i+=1

      #print products by farm
      @currfarm = ''
      @products.sort_by{|p| [p.farm_id, p.name, p.price]}.each do |pro|
        #check if new farm or first farm, add farm heading
        if @currfarm != Farm.find(pro.farm_id)
          i+=1 #add space
          @currfarm = Farm.find(pro.farm_id)
          sheet.row(i).push @currfarm.name
          sheet.row(i+1).push 'Item', 'Unit', 'Price'
          i+=2
        end
        sheet.row(i).push pro.name, pro.unit, pro.price
        i+=1
      end

      book.write Rails.root.join('print', 'orders', "#{@buyer.name}_#{Date.current}.xls")
    end

    def print_farm(products)
      @buyer = Buyer.find(params[:buyer_id])
      @products = products
      @farm = Farm.find(products[0].farm_id)

      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet
      i=0

      #header
      sheet.row(i).push @buyer.name, 'order to', @farm.name
      i+=2

      @products.sort_by{|p| [p.category, p.name]}.each do |pro|
        sheet.row(i).push pro.name, pro.unit, pro.price
        i+=1
      end

      book.write Rails.root.join('print', 'orders', "#{@farm.name}_#{@buyer.name}_#{Date.current}.xls")
    end

    def print_farms(farms,dist)
      @dist = dist
      @buyer = Buyer.find(params[:buyer_id])
      @order = Order.find(params[:id])
      @pros = @order.products.sort_by{|p| [p.farm_id, p.category, p.name]}.flatten
      @farms = farms      

      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet
      i=0

      #header
      sheet.row(i).push @buyer.name, 'order through', @dist.name
      i+=2

      @farms.each do |f|
        sheet.row(i).push f.name
	i+=1
	@pros.each do |p|
	  if p.farm_id == f.id
	    sheet.row(i).push p.name, p.unit, p.price
	    i+=1
	  end
	end
	#blank row
	i+=1
      end

      book.write Rails.root.join('print', 'orders', "#{@dist.name}_#{@buyer.name}_#{Date.current}.xls")
    end
  
    def included(dist, order)
      @shared = Array.new
      @dfarms = dist.farms.sort_by{|f| f.id}.flatten
      @ofarms = order.farms.sort_by{|f| f.id}.flatten
      @dpoint = 0
      @opoint = 0
      while @dpoint < @dfarms.length && @opoint < @ofarms.length
        if @dfarms[@dpoint].id == @ofarms[@opoint].id
	  puts @shared.push(@dfarms[@dpoint])
	  @dpoint+=1
	  @opoint+=1
	elsif @dfarms[@dpoint].id < @ofarms[@opoint].id
	  @dpoint+=1
	elsif @dfarms[@dpoint].id > @ofarms[@opoint].id
	  @opoint+=1
	end
      end
      return @shared
    end
  
end
