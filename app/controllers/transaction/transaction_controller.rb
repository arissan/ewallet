class Transaction::TransactionController < ApplicationController

	def transfer
	end

	def deposit
	end

	def withdrawal
	end

	def do_transfer
    recipient_param = params.permit(:wallet_no)
    wallet_to = Wallet.find_by_no(recipient_param[:wallet_no])

  	if recipient_valid(wallet_to, current_user)
    	current_user.transfer(wallet_to.user, amount) ? m_tx_success('Transfer') : m_tx_error
    else
    	flash[:alert] = "Recipient is not valid"
    end

    redirect_back(fallback_location: root_path)
	end

	def do_deposit
		current_user.deposit(amount) ? m_tx_success('Deposit') : m_tx_error
		redirect_back(fallback_location: root_path)
	end

	def do_withdrawal
		current_user.withdraw(amount) ? m_tx_success('Withdrawal') : m_tx_error
		redirect_back(fallback_location: root_path)
 	end

	private

		def recipient_valid(wallet_to, current_user)
			return false if recipient.nil? or (wallet_to.user_id == current_user.id)
			return true
		end

		def amount
		  param = params.permit(:amount)
		 	param[:amount].to_f
		end

		def m_tx_error
			alert= "Tx failed! Check your balance"
			alert= "Tx failed! Amount must be greater than 0.00" if params[:amount].to_i <= 0
			flash[:alert] = alert
		end

		def m_tx_success(tx_name)
			flash[:notice] = "#{tx_name} is completed"
		end
end
