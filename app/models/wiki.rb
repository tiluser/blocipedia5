class Wiki < ApplicationRecord
    belongs_to :user
    before_save :set_private_default_if_nil
    
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
