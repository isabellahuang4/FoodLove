class ProductsController < ApplicationController
  def index
    @farm = Farm.find(params[:farm_id])
    @categories = Array.new
    @cat = nil
    @farm.products.sort_by{|p| [p.category]}.each do |pro|
      if pro.category != @cat
        @categories.push pro.category.tr(" ", "_")
	@cat = pro.category
      end 
    end
  end

  def search
    @products = Product.where(nil)
    filtering_params(params).each do |key, value|
      @products = @products.public_send(key, value) if value.present?
    end
    @products=@products.sort_by{|p| [Farm.find(p.farm_id).distance_to(current_user) ,p.name]}
  end

  def new
    @farm = Farm.find(params[:farm_id])
    @product = Product.new
  end

  def create
    @farm = Farm.find(params[:farm_id])
    @product = @farm.products.create(product_params)
    redirect_to farm_products_path(@farm)
  end

  def edit_all
    @farm = Farm.find(params[:farm_id])
    @products = @farm.Product.all
  end

  def update
    @farm = Farm.find(params[:farm_id])
    @product = @farm.products.update(params[:id], product_params)
    redirect_to farm_products_path(@farm)
  end  

  def update_all
    puts 'update_all'
    @farm = Farm.find(params[:farm_id])
    params['products'].keys.each do |id|
      @product=@farm.Product.find(id.to_i)
      @product.update_attributes(params['products'][id])
    end
    redirect_to edit_farm_path(@farm)
  end

  def destroy
    @farm = Farm.find(params[:farm_id])
    @product = @farm.products.find(params[:id])
    @product.destroy
    redirect_to farm_products_path(@farm)
  end

  def show
    @farm = Farm.find(params[:farm_id])
    @product = @farm.products.find(params[:id])
    @pros = @farm.products.where(name: @product.name).sort_by{|p| p.price}
  end

  def edit
    @farm = Farm.find(params[:farm_id])
    @pro = @farm.products.find(params[:id])
    @pros = @farm.products.where(name: @pro.name).sort_by{|p| p.price}
  end


  private
    def product_params
      params.require(:product).permit(:name,:unit,:price,:category,:available,:feature,
	                              :description,:notes,:quantity)
    end

    def filtering_params(params)
      params.slice(:name_search, :category_search, :farm_search, :name_or_cat)
    end

end
