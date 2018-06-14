class DowngradesController < ApplicationController
    def create
        if current_user.role == 'premium'
            current_user.role = 'standard'
            current_user.save
            revert_to_public
            flash[:notice] = "You have been reverted to standard, #{current_user.email} ."
            redirect_to user_path(current_user) 
        else
            flash[:notice] = "You're either an admin or already standard. No charge made."
        end
    end
    
    private
    def revert_to_public
        @wikis = Wiki.all
        @wikis.each do |wiki|
            if wiki.user == current_user && wiki.private
                wiki.private = false
                wiki.save
            end
        end
    end
end
