class DistributorsController < ApplicationController

  def index
    @distributor=Distributor.all
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

end
