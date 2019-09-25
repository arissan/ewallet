class ApplicationController < ActionController::Base
	protect_from_forgery
	devise_group :user, contains: [:team, :stock]
	before_action :configure_permitted_parameters, if: :devise_controller?

private

    def load_transactions(current_user)
        conditions= {}
        conditions[:type]= params[:type] if params[:type].present?
        @tx_histories = current_user.transaction_histories.where(conditions).order('id ASC')
    end

    def load_wallet_info(current_user)
        wallet = current_user.wallet
        wallet = current_user.open_wallet if wallet.blank?
    end

    def configure_permitted_parameters
        added_attrs = [:email, :password, :password_confirmation, :remember_me, :name]
        devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
        devise_parameter_sanitizer.permit :wallet_update, keys: added_attrs
    end

end
