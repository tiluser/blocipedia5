
class ApplicationController < ActionController::Base
    include Pundit
    protect_from_forgery with: :exception
    before_action :authenticate_user!, except: [:index, :show]
    after_action :verify_authorized, except: [:index, :show],  unless: [:devise_controller?, :charges_url]
end
    
