class Admin::ProductsController < ApplicationController
before_filter :authenticate_user!

attr_reader :per_page

def index
  @search = Product.search(params[:search])
  @products = @search.paginate(:page => params[:page], :per_page => 2)
  end
 def show
  @product = Product.find(params[:id])
end
 def new
      @product = Product.new
end
 def create
      @product = Product.new(params[:product])
      if @product.save
            redirect_to admin_products_path
      else
            @categories = Category.find(:all)
            render :action => 'new'
      end
 end
 def edit
      @product = Product.find(params[:id])
 end
 def update
      @product = Product.find(params[:id])
      if @product.update_attributes(params[:product])
         redirect_to :action => 'show', :id => @product
      else
         render :action => 'edit'
      end
 end
 def destroy
      @product = Product.find(params[:id])
	  @product.destroy
      redirect_to :action => 'index'
 end
end

