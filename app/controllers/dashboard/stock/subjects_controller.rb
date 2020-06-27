class Dashboard::Stock::SubjectsController < ApplicationController
	before_action :authenticate_stock!

	def index
		load_wallet_info(current_user)
    	load_transactions(current_user)
	end

end
