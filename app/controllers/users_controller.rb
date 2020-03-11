class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(page: params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @search = search_params


    microposts = @user.microposts.includes(:image_attachment, :tags)

    unless @search[:date].blank?
      condition = "<"

      unless (@search[:is_before].blank?)
        condition = @search[:is_before] == "true" ? "<" : ">="
      end
      
      microposts.where!("DATE(microposts.created_at) #{condition} DATE('#{@search[:date]}')")
    end

    unless @search[:tags].blank?
      tags = @search[:tags].split(",").map { |item| item.strip }

      micropostsIds = Micropost.all.joins!(:tags).where!(tags: {content: tags}).having!("COUNT(microposts.id) = ?", tags.size).group!("microposts.id")

      microposts.where!(id: micropostsIds.map(&:id))
    end

    unless @search[:order].blank?
      if @search[:order] == "ascending"
        microposts.reorder!(created_at: :asc)
      elsif @search[:order] == "descending"
        microposts.reorder!(created_at: :desc)
      end
    end
      
    @microposts = microposts.paginate(page: @search[:page])

  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @address = Address.new(address_params)

    unless @user.save
      return render 'new'
    end

    unless @address[:address].blank? || @address[:city].blank? || @address[:zip_code].blank? || @address[:country].blank?
      @address.user_id = @user[:id]
      unless @address.save
        return render 'new'  
      end
    end

    log_in @user
    flash[:success] = "Welcome to the Sample App!"
    redirect_to @user
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])

    unless @user.update(user_params)
      render 'edit'
    end

    if @user.address.nil?
      @address = Address.new(address_params)
      unless @address[:address].blank? || @address[:city].blank? || @address[:zip_code].blank? || @address[:country].blank?
        @address.user_id = @user[:id]
        unless @address.save
          return render 'edit'  
        end
      end
    else
      @user.address.update(address_params)
    end

    flash[:success] = "Profile updated"
    redirect_to @user
  end

  def logged_in_user 
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation)
    end

    def address_params
      params.require(:address).permit(:address, :city, :zip_code, :country)
    end

    def search_params
      params.permit(:order, :date, :is_before, :tags, :page)
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
