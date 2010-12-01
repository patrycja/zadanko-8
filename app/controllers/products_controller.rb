class ProductsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]  
  attr_reader :per_page
  
  def index
  @search = Product.search(params[:search])
  @products = @search.paginate(:page => params[:page], :per_page => 3)
  @cart = find_cart
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
            render :action => 'new', :controller => 'admin/products'
      end
 end
  
  def edit
      @product = Product.find(params[:id])
  end
  
  def update
      @product = Product.find(params[:id])
      if @product.update_attributes(params[:product])
         redirect_to :action => 'show', :id => @product, :controller => 'admin/products'
      else
         render :action => 'edit'
      end
  end
  
  def destroy
      @product = Product.find(params[:id])
	  @product.destroy
      redirect_to products_path
  end
  
  def add_to_cart
    begin
	  product = Product.find(params[:id])
	rescue ActiveRecord::RecordNotFound
	  logger.error("Attempt to access invalid product #{params[:id]}" )
      flash[:notice] = "Invalid product"
      redirect_to :action => :index
	else
	  @cart = find_cart
	  @cart.add_product(product)
	end
  end
  
  def empty_cart
    session[:cart] = nil
    redirect_to :action => :index
  end
  
  def checkout
    @cart = find_cart
    if @cart.items.empty?
      redirect_to :action => :index
	  flash[:notice] = "Twoj koszyk jest pusty"
    else
      @order = Order.new
    end
  end
  
  def save_order
    @cart = find_cart
    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(@cart)
    if @order.save
	  #@order.update_attribute :accepted, true
      session[:cart] = nil
      #flash[:notice] = "dziekujemy za zlozenie zamowienia"
    else
      render :action => :checkout
    end
  end

  private
  
  def find_cart
    session[:cart] ||= Cart.new
  end  
end

