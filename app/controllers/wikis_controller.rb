class WikisController < ApplicationController
   #before_action :require_sign_in, except: :show
    
    def new
        @user = current_user
        authorize @wiki
        @wiki = Wiki.new
    end

    def create
        @wiki = Wiki.new
        authorize @wiki
        @wiki.update_attributes(wiki_params)
        @wiki.user_id = current_user.id
        
        if @wiki.save
            flash[:notice] = "Wiki article #{@wiki.id} was saved."
            redirect_to [@wiki]
        else
            flash.now[:alert] = "There was an error saving the wiki article. Please try again."
            render :new
        end
    end
    
    def update
        @wiki = Wiki.find(params[:id])
        authorize @wiki
        @wiki.update_attributes(wiki_params)
        if @wiki.save
            flash[:notice] = "Wiki article was updated"
            redirect_to [@wiki]
        else
            flash.now[:alert] = "There was an error saving the wiki article. Please try again."
            render :edit
        end
    end
    
    def edit
        @wiki = Wiki.find(params[:id])
        authorize @wiki
    end

    def destroy
        @wiki = Wiki.find(params[:id])
        authorize @wiki
        if @wiki.destroy
            flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
            redirect_to wikis_path
        else
            flash.now[:alert] = "There was an error deleting the wiki article."
            render :show
        end
    end

    def index
        @wikis = Wiki.all
        authorize @wikis
    end

    def show
        @wiki = Wiki.find(params[:id])
        authorize @wiki
    end
    
    private
    def wiki_params
        params.require(:wiki).permit(:title, :body, :private)
    end
end