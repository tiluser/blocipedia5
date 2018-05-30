class ChargesController < ApplicationController
    def new
        @stripe_btn_data = {
            key: "#{ Rails.configuration.stripe[:publishable_key] }",
            description: "BigMoney Membership - #{current_user.email}",
            amount: Amount.default
        }
    end

    def create
        if current_user.role != 'standard'
            flash[:notice] = "You already have a premium or admin account, #{current_user.email} . No charge made."
            redirect_to user_path(current_user) 
            return
        end
        # Creates a Stripe Customer object, for associating
        # with the charge
        customer = Stripe::Customer.create(
            email: current_user.email,
                card: params[:stripeToken]
        )
        
        # Where the real magic happens
        charge = Stripe::Charge.create(
                customer: customer.id, # Note -- this is NOT the user_id in your app
                amount: Amount.default,
                description: "BigMoney Membership - #{current_user.email}",
                currency: 'usd'
        )
        former_role = current_user.role
        current_user.role = 'premium'
        current_user.save
        flash[:notice] = "Thanks for your order, #{current_user.email} ."
        redirect_to user_path(current_user) 
        
        # Stripe will send back CardErrors, with friendly messages
        # when something goes wrong.
        # This "rescue block" catches and displays those errors.
        rescue Stripe::CardError => e
            flash[:alert] = e.message
            current_user.role = former_role
            current_user.save
            redirect_to new_charge_path
    end
end

class Amount
    # class-level instance variable

    # setting initial value (optional)
    @default = 1500  

    # making getter/setter methods on the class itself
    class << self
        attr_reader :default
    end
end
