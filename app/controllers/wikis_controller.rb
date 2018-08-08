class WikisController < ApplicationController
   #before_action :require_sign_in, except: :show

    def new
        @user = current_user
        @wiki = Wiki.new
        @users = User.all
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
        @wiki.collab_list = params[:wiki][:collab_list]
        @collaborators = @wiki.collab_list.split(" ")
        @collaborators.each do |coll|
            Collaborator.create!(user_id: coll, wiki_id: @wiki.id)
        end
        
        # @wiki.collaborators.create!(user_id: 5, wiki_id: 10)
        if @wiki.save
            flash[:notice] = "Wiki entry was saved " + params[:wiki][:collab_list]
            redirect_to [@wiki]
        else
            flash.now[:alert] = "There was an error saving the wiki article. Please try again."
            render :edit
        end
    end
    
    def edit
        @users = User.all
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