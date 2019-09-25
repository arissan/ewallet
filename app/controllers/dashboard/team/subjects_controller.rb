class Dashboard::Team::SubjectsController < ApplicationController
	before_action :authenticate_team!

	def index
    load_wallet_info(current_user)
    load_transactions(current_user)
	end


end
