class WikiPolicy < ApplicationPolicy
    class Scope < Scope
        attr_reader :user, :scope
        
        def initialize(user, scope)
            @user = user
            @scope = scope
        end
        
        # The rules: Admin sees everything, premium users see all public wikis 
        # and their own private ones or ones they've collaborated on, 
        # and standard users see public wikis or wikis they're collaborators on.
        # guests only see public wikws
        def resolve
            wikis = []   
            all_wikis = []
            wikis_subset_guest = []
            wikis_subset_standard = []
            wikis_subset_premium = []
            
            all_wikis = scope.all
            all_wikis.each do |wiki|
                puts wiki.collaborators
                if (wiki.private == false)
                    wikis_subset_guest << wiki
                    wikis_subset_standard << wiki
                    wikis_subset_premium << wiki
                else
                    if wiki.collaborators.where(:user_id => user.id).length > 0 || wiki.user == user    
                #    if wiki.collaborators.include?(user) || wiki.user == user
                        wikis_subset_standard << wiki
                        wikis_subset_premium << wiki
                    end
                end
            end
            
            if user.nil?
                wikis = wikis_subset_guest
            elsif user.role == 'admin'
                wikis = all_wikis
            elsif user.role == 'premium' 
                wikis = wikis_subset_premium
            else
                wikis = wikis_subset_standard
            end
            wikis
        end
    end
end