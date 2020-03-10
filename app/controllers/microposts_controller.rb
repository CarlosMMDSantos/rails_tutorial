class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]

  # GET /microposts
  # GET /microposts.json
  def index
    @microposts = Micropost.all
  end

  # GET /microposts/new
  def new
    @micropost = Micropost.new
  end

  # POST /microposts
  # POST /microposts.json
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])

    unless @micropost.save
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end

    unless params[:micropost][:tags_list].blank?
      tags = params[:micropost][:tags_list].split(",").map { |item| item.strip }
      tagIds = []
      tags.each do |tag|
        tagAux = Tag.find_or_create_by(content: tag)
        tagIds << tagAux
      end
      
      @micropost.addTag(tagIds)
      
    end

    flash[:success] = "Micropost created!"
    redirect_to root_url
  end

  # DELETE /microposts/1
  # DELETE /microposts/1.json
  def destroy
    @micropost = Micropost.find(params[:id])
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
