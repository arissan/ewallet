class Transaction::TransactionController < ApplicationController

	def show
		@trans = TransactionHistory.find(params[:id])
	end

	def deposit
		@trans= current_user.deposits.new
	end

	def withdrawal
		@trans= current_user.withdrawals.new
	end

	def do_deposit
		item= Item.find(params[:item_id]) rescue nil
		donatur= Donatur.find(params[:donatur_id]) rescue nil
		@trans= current_user.deposit(amount, item, donatur, params[:notes])
		if @trans.errors.blank?
			m_tx_success('Deposit')
			redirect_to transactions_path
		else
			m_tx_error('Deposit')
			render action: :deposit
		end
	end

	def do_withdrawal
		item= Item.find(params[:item_id]) rescue nil
		donatur= Donatur.find(params[:donatur_id]) rescue nil
		@trans= current_user.withdraw(amount, item, donatur, params[:notes])
		if @trans.errors.blank?
			m_tx_success('Withdraw')
			redirect_to transactions_path
		else
			m_tx_error('Withdraw')
			render action: :withdrawal
		end
 	end

	private

		def amount
		  	param = params.permit(:amount)
		  	param[:amount].to_f
		end

		def m_tx_error(tx_name)
			flash[:alert] = "#{tx_name} has failed! Check the following details"
		end

		def m_tx_success(tx_name)
			flash[:notice] = "#{tx_name} is completed"
		end
end
