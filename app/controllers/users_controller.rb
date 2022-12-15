class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :must_be_logged_in

  # GET /users or /users.json
  def index
    if role? != 'admin'
      redirect_to login_path, notice: 'You do not have permission to access this page.'
    end
    @users = User.all
    session[:profile] = "index"
  end

  # GET /users/1 or /users/1.json
  def show
    if session[:id].to_s != params[:id] and role? != 'admin'
      redirect_to login_path, notice: 'You do not have permission to access this page.'
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if session[:id].to_s != params[:id] and role? != 'admin'
      redirect_to login_path, notice: 'You do not have permission to access this page.'
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def changePassword
    render "changepassword"
  end

  def newPassword
    u = User.where(id: session[:id]).first
    if u and u.authenticate(params[:password])
      if params[:newPassword] and (params[:newPassword] == params[:confirmPassword])
        u.password = params[:newPassword]
        u.save
        url = "/users/" + session[:id].to_s
        redirect_to url, notice: "Your new password already saved."
      else
        redirect_to changepassword_path, notice: "Your new password not matched."
      end
    else
      redirect_to changepassword_path, notice: "Your password is not correct."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :name, :user_type, :lock_version)
    end
end
