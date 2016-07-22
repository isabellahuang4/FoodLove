class FarmsController < ApplicationController

  def index
    @farms=Farm.all
  end

  def show
    @farm=Farm.find(params[:id])
  end

  def new
    @farm=Farm.new
  end

  def edit
    @farm=Farm.find(params[:id])
  end

  def create
    @farm=Farm.new(params[:user])
    if @farm.save
      redirect_to @farm
    else 
      render User.new
    end
  end

  def update
    @farm=Farm.find(params[:id])
    
    #uncheck all
    @farm.products.each do |product|
      product.update(available: false)
    end

    #upload
    uploader = FileUploader.new
    uploader.store!(params[:farm][:file])

    book = Spreadsheet.open(Rails.root.join('public', 'uploads',
    	   				    params[:farm][:file].original_filename))
    sheet = book.worksheet 0
    
    #process products
    sheet.each 2 do |row|
      if row[2]==nil
        break
      end
      #if product with name and unit exists, update
      if @farm.products.exists?(name: row[1], unit: row[2])
        @id = @farm.products.where(name: row[1], unit: row[2])
	@farm.products.update(@id, {:category => row[0],
				    :price => row[3],
				    :quantity => row[4],
				    :description => row[5],
				    :notes => row[6],
				    :available => true})
      else
        @farm.products.create(name: row[1],
	                      unit: row[2],
			      category: row[0],
			      price: row[3],
			      quantity: row[4],
			      description: row[5],
			      notes: row[6],
			      available: true)
      end
    end
    redirect_to edit_farm_path(@farm)
  end

  def destroy
    @farm=Farm.find(params[:id])
    @farm.destroy
    redirect_to farms_path
  end

  private
#    def farm_params
#      params.require(:user).permit(:name, :email, :password, :password_confirmation, :location)
#    end

end
