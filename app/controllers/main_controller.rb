class MainController < ApplicationController
  $startDate = ''
  $finalDate = ''
  $c_search = "all"
  def login
    # is_login? if login already cant login again until logout 
    login_again?
  end

  def create
    # check overlap login?
    if is_login?
      redirect_to main_path, notice: 'Please logout your account before login again!'
    else
      # check login authenticate with password?
      u = User.where(email: params[:email]).first
      if u and u.authenticate(params[:password])
        redirect_to main_path
        session[:id] = u.id
        session[:logged_in] = true
      else
        redirect_to login_path, notice: 'your username or your password is wrong. please try again!'
      end
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: 'logout already!'
  end

  def home
    if session[:logged_in]
      @role = role?
      @id = session[:id]
      session[:create] = false
      session[:search] = false
      session[:profile] = "home"
    else
      @role = 'guest'
    end
    
  end

  def profile
    must_be_logged_in
    redirect_to "/users/" + session[:id].to_s
  end

  def market
    if role? == 'seller'
      redirect_to main_path, notice: 'You are not a buyer'
    else
      @c_default = $c_search
      @u = Market.joins(:item).select(:id ,:user_id,:name,:item_id, :price, :quantity, :category, :enable)
      @categories = Item.select(:category).distinct
      n = @categories.length + 2
      @c = Array.new(n)
      @c[0] = [@c_default,@c_default]
      @c[1] = ["all","all"]
      i = 2
      for x in @categories do
        @c[i] = [x.category,x.category]
        i = i+1
      end
      $c_search = "all"
      if session[:logged_in]
        @role = role?
      else
        @role = 'guest'
      end
    end
  end

  def phistory
    must_be_logged_in
    if role? == 'seller'
      redirect_to main_path, notice: "You have no permission to access this page"
    end
    @history = Inventory.where(user_id: session[:id]).order(:created_at)
  end

  def shistory
    must_be_logged_in
    if role? == 'buyer'
      redirect_to main_path, notice: "You have no permission to access this page"
    end
    @history = Inventory.where(seller_id: session[:id]).order(:created_at)
  end

  def inventory
    must_be_logged_in
    if role? == 'buyer'
      redirect_to main_path
    end
    @inven = Market.where(user_id: session[:id])
    @items = Item.where(enable: true)
  end

  def topseller
    must_be_logged_in
    if role? == 'buyer'
      redirect_to main_path, notice: "You have no permission to access this page"
    end
    if session[:create]
      @startDate = $startDate
      @finalDate = $finalDate
    end
  end

  def create_tables
    $startDate = params[:startdate]
    $finalDate = params[:finaldate]
    session[:create] = true
    redirect_to top_seller_path
  end

  def buy
    @amount = params[:amount].to_i
    $m = Market.where(id: params[:f_id]).first
    $I = Inventory.new
    a = params[:amount_check]
    if a.to_i == $m.quantity
      if @amount > $m.quantity
        redirect_to my_market_path , notice: "the quantity of this goods is not enough"
      else
        $m.quantity -= @amount
        $m.save
        $I.user_id = session[:id].to_i
        $I.item_id = $m.item_id
        $I.seller_id = $m.user_id
        $I.price = $m.price
        $I.quantity = @amount
        $I.save
        redirect_to my_market_path , notice: "transaction success"
      end
    else
      redirect_to my_market_path , notice: "Information need to be updated before editted"
    end
  end

  def search
    $c_search = params[:c_search]
    redirect_to my_market_path
  end
end
