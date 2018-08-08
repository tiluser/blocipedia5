class User < ApplicationRecord
    has_many :collaborators
    has_many :wikis, through: :collaborators
    
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
    enum role: [:standard, :premium, :admin]
    after_initialize { self.role ||= :standard }

    devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
         
    delegate :wikis, to: :collaborators
         
    def collaborators
        Collaborator.where(user_id: id)
    end
    
end
