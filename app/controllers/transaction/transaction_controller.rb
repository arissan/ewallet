class Transaction::TransactionController < ApplicationController
	# before_action :set_wallet, only: [:transfer, :deposit, :withdrawal]

	def transfer
	end

	def deposit
	end

	def withdrawal
	end

	def do_transfer
    recipient_param = params.permit(:wallet_name)
    wallet_to = Wallet.find_by_name(recipient_param[:wallet_name])

  	if recipient_valid(wallet_to, current_user)
    	current_user.wallet.transfer(wallet_to, amount) ? m_tx_success('Transfer') : m_tx_error
    else
    	flash[:alert] = "Recipient is not valid"
    end

    redirect_back(fallback_location: root_path)
	end

	def do_deposit
		wallet= current_user.wallet
		wallet.deposit(amount) ? m_tx_success('Deposit') : m_tx_error
		redirect_back(fallback_location: root_path)
	end

	def do_withdrawal
		wallet= current_user.wallet
		wallet.withdraw(amount) ? m_tx_success('Withdrawal') : m_tx_error
		redirect_back(fallback_location: root_path)
 	end

	private

		def recipient_valid(recipient, current_user)
			if recipient.nil?
				return false
			end

			if (recipient.user_id == current_user.id)
				return false
			end

			return true
		end

		def amount
		  param = params.permit(:amount)
		 	param[:amount].to_f
		end

		def set_wallet
			wallet = current_user.wallet

			if wallet.nil?
				flash[:alert] = "Error when create wallet!" unless current_user.open_wallet.valid?
			else
				@balance = wallet.balance
				@wallet_name = wallet.name
			end
		end

		def m_tx_error
			alert= "Tx failed! Check your balance"
			alert= "Tx failed! Amount must be greater than 0.00" if params[:amount].to_i ==0
			flash[:alert] = alert
		end

		def m_tx_success(tx_name)
			flash[:notice] = "#{tx_name} is completed"
		end
end
