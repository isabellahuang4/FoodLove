class DistributorsController < ApplicationController

  def index
    @dists=Distributor.all.sort_by{|d| d.name}
  end
  
  def show
    @distributor=Distributor.find(params[:id])
  end
   
  def new
    @distributor=Distributor.new
  end

  def edit
    @distributor=Distributor.find(params[:id])
    @farms=@distributor.farms
    @orders=@distributor.orders
    @buyers = Buyer.all.sort_by{|b| b.name}
  end
    
  def create
    @distributor=Distributor.new(params[:user])
    if @distributor.save
      redirect_to @distributor
    else
      render User.new
    end
  end

  def update
    @distributor=Distributor.find(params[:id])
    if @distributor.update()
      redirect_to @distributor
    else
      render 'edit'
    end
  end

  def printall
    @dist=Distributor.find(params[:id])
    @farms=@dist.farms

    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    i=0
    
    #formating
    money_f = Spreadsheet::Format.new :number_format => '$#,##0.00_);($#,##0.00)'

    #header
    sheet.row(i).push @dist.name
    i+=2

    #print each farm
    @farms.sort_by{|fa| [fa.name]}.each do |f|
      sheet.row(i).push f.name
      i+=1
      sheet.row(i).push 'Category', 'Item', 'Unit', 'Price', 'Quantity', 'Description', 'Notes'
      i+=1
      f.products.sort_by{|p| [p.category, p.name.downcase, p.price]}.each do |p|
        if p.quantity > 0
	  sheet.row(i).push p.category, p.name, p.unit, p.price, p.quantity, p.description, p.notes
	  i+=1
	end
      end
      i+=2
    end
    
    sheet.column(2).default_format = money_f
    
    book.write Rails.root.join('print', "#{@dist.name}_#{Date.current}.xls")
    send_file Rails.root.join('print', "#{@dist.name}_#{Date.current}.xls")
    
  end

  def add_farm
    @dist = Distributor.find(params[:id])
    @farms = Farm.all
  end

  def new_farm
    @dist = Distributor.find(params[:id])
    @dist.farms.push(Farm.find(params[:format]))
    redirect_to edit_distributor_path(@dist)
  end

  def remove_farm
    @dist = Distributor.find(params[:id])
    @dist.farms.delete(Farm.find(params[:format]))
    redirect_to edit_distributor_path(@dist)
  end

  def dismiss_order
    @dist = Distributor.find(params[:id])
    @order = @dist.orders.find(params[:format])
    @dist.orders.delete(@order)
    redirect_to edit_distributor_path(@dist)
  end

  def message
    @dist = Distributor.find(params[:id])
    UserMailer.message_send(@dist, User.find(params[:message][:user]), params[:message][:message]).deliver_now
    flash[:notice]="Your message has been set."
    redirect_to distributor_path(@dist)
  end

  def compile_orders
    @dist = Distributor.find(params[:id])
    @orders = @dist.orders

    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    i=0

    bold_f = Spreadsheet::Format.new :weight => :bold

    #header
    sheet.row(i).push 'Compiled Orders', "#{Date.current}"
    sheet.row(i).default_format=bold_f
    sheet.row(i+2).push 'Buyer', 'Farm', 'Product', 'Unit', 'Quantity'
    sheet.row(i+2).default_format=bold_f
    i+=3

    #print each order
    @orders.each do |o|
      if o.buyer_id != nil && o.placed != nil && DateTime.now.days_ago(7) < o.placed
        o.products.each do |p|
          sheet.row(i).push Buyer.find(o.buyer_id).name, Farm.find(p.farm_id).name, 
	  		    p.name, p.unit, o.quantities.find_by(product_id: p.id).quant
          i+=1
        end
      end
    end

    book.write Rails.root.join('print', "#{@dist.name}_orders_#{Date.current}.xls")
    send_file Rails.root.join('print', "#{@dist.name}_orders_#{Date.current}.xls")
  end

end
