class DowngradesController < ApplicationController
    def create
        if current_user.role == 'premium'
            current_user.role = 'standard'
            current_user.save
            flash[:notice] = "You have been reverted to standard, #{current_user.email} ."
            redirect_to user_path(current_user) 
        else
            flash[:notice] = "You're either an admin or already standard. No charge made."
        end
    end
end
