class WikiPolicy < ApplicationPolicy
    class Scope
        attr_reader :user, :scope
        
        def initialize(user, scope)
            @user = user
            @scope = scope
        end
        
        def resolve
            wikis = []
            wikis = scope.all # if the user is an admin, show them all the wikis
            wikis # return the wikis array we've built up
        end
    end
end