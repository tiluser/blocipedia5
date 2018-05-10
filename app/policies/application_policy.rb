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
        scope.where(:id => wiki.id).exists?
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
        true if user.role == 'admin' || wiki.user == user 
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