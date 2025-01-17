# frozen_string_literal: true

module SessionsHelper
    # Logs in the given user.
    def log_in(user)
        session[:user_id] = user.id
    end
    
    def current_user
        # Returns the user corresponding to the remember token cookie.
        if (user_id = session[:user_id])
            @current_user ||= User.find_by(id: user_id) 
        elsif (user_id = cookies.signed[:user_id])
            user = User.find_by(id: user_id)
            if user&.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end
    
    def current_user?(user)
        user && user == current_user
    end
    
    def logged_in?
        !current_user.nil?
    end
    
    def log_out
        session.delete(:user_id)
        @current_user = nil
    end
    
    # Redirects to stored location (or to the default).
    def redirect_back_or(default)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
    end
    
    # Stores the URL trying to be accessed.
    def store_location
        session[:forwarding_url] = request.original_url if request.get?
    end
end