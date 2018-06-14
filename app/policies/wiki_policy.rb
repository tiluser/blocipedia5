class WikiPolicy < ApplicationPolicy
    class Scope < Scope
        attr_reader :user, :scope
        
        def initialize(user, scope)
            @user = user
            @scope = scope
        end
        
        # The rules: Admin sees everything, premium users see all public wikis 
        # and their own private ones, and standard users or guests only see public wikis.
        def resolve
            wikis = []   
            all_wikis = []
            wikis_subset_public = []
            wikis_subset_premium = []
            
            all_wikis = scope.all
            
            all_wikis.each do |wiki|
                if (wiki.private == false)
                    wikis_subset_public << wiki
                    wikis_subset_premium << wiki
                elsif wiki.private && wiki.user == user
                    wikis_subset_premium << wiki
                end            
            end
            
            if user.nil?
                wikis = wikis_subset_public
            elsif user.role == 'admin'
                wikis = all_wikis
            elsif user.role == 'premium' 
                wikis = wikis_subset_premium
            else
                wikis = wikis_subset_public
            end
            wikis
        end
    end
end