class Wiki < ApplicationRecord
    has_many :collaborators
    has_many :users, through: :collaborators
    belongs_to :user
    before_save :set_private_default_if_nil
    
    delegate :users, to: :collaborators
    def collaborators
        Collaborator.where(user_id: id)
    end
    
    private
    def set_private_default_if_nil
        if self.private == nil 
            self.private = false
        end
    end
    
    def after_initialize 
        return unless new_record?
        self.status = ACTIVE
    end

end
