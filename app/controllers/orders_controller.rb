class OrdersController < ApplicationController

  def show
    @buyer = Buyer.find(params[:buyer_id])
    @order = Order.find(params[:id])
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
    @pros = @order.products

    #create array
    @prods = Array.new
    @pros.each do |p|
      @prods.push(p)
    end

    #print order spreadsheet
    print_all
    #send entire order sheet to self
    UserMailer.order_self(@order)
    
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
      UserMailer.order_farm(@farm_pros, @order)
    end

    #print sheet for each distributor and send
    

    redirect_to edit_buyer_order_path(@buyer,@order)
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
  
end
