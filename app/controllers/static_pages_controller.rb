class StaticPagesController < ApplicationController
  
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @search = search_params

      userFeed = current_user.feed

      unless @search[:date].blank?
        condition = "<"

        unless (@search[:is_before].blank?)
          condition = @search[:is_before] == "true" ? "<" : ">="
        end
        
        userFeed.where!("DATE(microposts.created_at) #{condition} DATE('#{@search[:date]}')")
      end

      unless @search[:tags].blank?
        tags = @search[:tags].split(",").map { |item| item.strip }
        userFeed.joins!(:tags).where!("tags.content IN (#{tags.map{|item| "'#{item}'"}.join(",")})")
      end

      unless @search[:order].blank?
        if @search[:order] == "ascending"
          userFeed.reorder!(created_at: :asc)
        elsif @search[:order] == "descending"
          userFeed.reorder!(created_at: :desc)
        end
      end

      @feed_items = userFeed.paginate(page: @search[:page])

    end
  end
  
  def help
  end

  def about
  end

  def contacts
  end

  private
    def search_params
      params.permit(:order, :date, :is_before, :tags)
    end

end