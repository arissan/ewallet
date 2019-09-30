class Transaction::TransactionController < ApplicationController

	def transfer
    recipient_param = params.permit(:wallet_no)
    wallet_to = Wallet.find_by_no(recipient_param[:wallet_no])

		@trans= current_user.transfers.new
		@trans.to= wallet_to
		@trans.from= current_user.wallet
		@trans.amount= @amount
	end

	def deposit
		@trans= current_user.deposits.new
	end

	def withdrawal
		@trans= current_user.withdrawals.new
	end

	def do_transfer
    recipient_param = params.permit(:wallet_no)
		@amount= params[:amount]
		@name= params[:wallet_no]
    wallet_to = Wallet.find_by_no(recipient_param[:wallet_no])
    target= wallet_to.try(:user)
    if target.blank?
    	@trans= current_user.transfers.new
    	@trans.amount= @amount
    	@trans.valid?
    	m_tx_error('Transfer')
			render action: :transfer
			return
    end

		@trans= current_user.transfer(target, @amount)
		if @trans.errors.blank?
			m_tx_success('Transfer')
			redirect_to transactions_path
		else
			m_tx_error('Transfer')
			render action: :transfer
		end
	end

	def do_deposit
		@trans= current_user.deposit(amount)
		if @trans.errors.blank?
			m_tx_success('Deposit')
			redirect_to transactions_path
		else
			m_tx_error('Deposit')
			render action: :deposit
		end
	end

	def do_withdrawal
		@trans= current_user.withdraw(amount)
		if @trans.errors.blank?
			m_tx_success('Withdraw')
			redirect_to transactions_path
		else
			m_tx_error('Withdraw')
			render action: :withdrawal
		end
 	end

	private

		# def recipient_valid(wallet_to, current_user)
		# 	return false if wallet_to.nil? or (wallet_to.user_id == current_user.id)
		# 	return true
		# end

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
