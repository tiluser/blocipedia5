class WikisController < ApplicationController
   #before_action :require_sign_in, except: :show

    def new
        @user = current_user
        @wiki = Wiki.new
        authorize @wiki
    end

    def create
        @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
        @wiki = Wiki.new
        authorize @wiki
        @wiki.update_attributes(wiki_params)
        @wiki.user_id = current_user.id
        
        @wiki.title = @wiki.title
        @wiki.body = @markdown.render(@wiki.body).html_safe
        if @wiki.save
            flash[:notice] = "Wiki article #{@wiki.id} was saved."
            redirect_to [@wiki]
        else
            flash.now[:alert] = "There was an error saving the wiki article. Please try again."
            render :new
        end
    end
    
    def update
        @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
        @wiki = Wiki.find(params[:id])
        authorize @wiki
        @wiki.update_attributes(wiki_params)
        @wiki.title = @wiki.title
        @wiki.body = @markdown.render(@wiki.body)
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
        @wikis = policy_scope(Wiki)
    end

    def show
        @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
        @wiki = Wiki.find(params[:id])
        authorize @wiki
    end
    
    private
    def wiki_params
        params.require(:wiki).permit(:title, :body, :private)
    end
end