class Wallet < ApplicationRecord
	belongs_to :user
	validates_presence_of :no
	validates_uniqueness_of :user_id
	BALANCE_NOT_ENOUGHT= 'doesnt enought. Check your request amount'

	class << self
		def open(user)
			return user.wallet if user.wallet.present?

			wallet = user.build_wallet
			wallet.no = random_wallet_number
			wallet.save!
			wallet
		end

		private

		  def random_wallet_number
				ptrn = [('0'..'0'), ('A'..'Z')].map(&:to_a).flatten
				wallet_number = (0...8).map { ptrn[rand(ptrn.length)] }.join
				return wallet_number
		  end

	end

	def balance
		debit= user.transfers.sum(:amount) + user.withdrawals.sum(:amount)
		credit= user.deposits.sum(:amount)
		(credit - debit)
	end

	def get_running_balance(running_id)
		# as the instruction to summing records...
		sum_credit(running_id) -  sum_debit(running_id)
	end

	def deposit(amount)
		Deposit.save_history(self, amount)
	end

	def withdraw(amount)
		Withdrawal.save_history(self, amount)
	end

	def transfer(wallet_to, amount)
		# ActiveRecord::Base.transaction do
		Transfer.save_history(self, wallet_to, amount)
	end

  def is_balance_enought?(amount)
  	if amount.to_f > self.balance
  		self.errors.add(:balance, BALANCE_NOT_ENOUGHT)
  	end
  	return self.errors.blank?
  end

	private

		def sum_debit(running_id)
			summing_resources.where(['type IN (?) AND id <= ?', ['Withdrawal','Transfer'], running_id]).order('id ASC').sum(:amount)
		end

		def sum_credit(running_id)
			summing_resources.where(['type IN (?) AND id <= ?', ['Deposit'], running_id]).order('id ASC').sum(:amount)
		end

		def summing_resources
			user.transaction_histories.order('id ASC')
		end

		def amount_valid?(amount)
			return amount > 0
		end

		def amount_enough?(amount, balance)
			if amount <= 0 || balance < amount
				return false
			end
			return true
		end

end
