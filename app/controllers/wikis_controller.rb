class WikisController < ApplicationController
   #before_action :require_sign_in, except: :show
    
    def new
        @user = current_user
        @wiki = Wiki.new
    end

    def create

        params.require(:wiki).require(:title)
        params.require(:wiki).require(:body)
        @wiki = Wiki.new
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
    end

    def destroy
        @wiki = Wiki.find(params[:id])
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
    end

    def show
        @wiki = Wiki.find(params[:id])
    end
    
    private
    def wiki_params
        params.require(:wiki).permit(:title, :body, :private)
    end
end
