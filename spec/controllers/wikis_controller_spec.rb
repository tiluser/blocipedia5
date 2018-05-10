require 'rails_helper'

RSpec.describe WikisController, type: :controller do
    describe "GET #index" do 
        it "redirects to sign-in if not logged in" do        
            get :index
            expect(response).to redirect_to('http://test.host/users/sign_in') 
        end
    end
end
