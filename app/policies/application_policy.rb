class ApplicationPolicy
    attr_reader :user, :wiki

    def initialize(user, wiki)
        @user = user
        @wiki = wiki
    end

    def index?
        true
    end
    
    def show?
        if @user.nil? && @wiki.private
            false
        elsif @user.role == 'standard' && @wiki.private
            false
        elsif  @wiki.user != user && @user.role == 'premium' && @wiki.private
            false
        elsif @user.role == 'admin'
            true
        elsif @user.role == 'standard' && @wiki.private == false
            true
        elsif @user.role == 'premium' && @wiki.private && @wiki.user == user
            true
        else
            true
        end
    end

    def create?
        user.present?
    end

    def new?
        create?
    end

    def update?
        user.present?
    end

    def edit?
        update?
    end
    
    def destroy?
        user.role == 'admin' || wiki.user == user 
    end

    def scope
        Pundit.policy_scope!(user, wiki.class)
    end

    class Scope
        attr_reader :user, :scope

        def initialize(user, scope)
            @user = user
            @scope = scope
        end

        def resolve
            scope
        end
    end
end