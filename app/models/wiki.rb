class Wiki < ApplicationRecord
    belongs_to :user
    before_save :set_private_default_if_nil
    
    private
    def set_private_default_if_nil
        if self.private == nil 
            self.private = false
        end
    end
end
