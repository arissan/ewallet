class Wallet < ApplicationRecord
	belongs_to :user
	validates_presence_of :name
	validates_uniqueness_of :user_id

	def balance
		debit= user.transfers.sum(:amount) + user.withdrawals.sum(:amount)
		credit= user.deposits.sum(:amount)
		(debit - credit).abs
	end

	def get_running_balance(running_id)
		# as the instruction to summing records...
		sum_credit(running_id) -  sum_debit(running_id)
	end

	class << self
		def open(user)
			return user.wallet if user.wallet.present?

			wallet = user.build_wallet
			wallet.name = random_wallet_number
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

	def deposit(amount)
		return false unless amount_valid?(amount)
		ActiveRecord::Base.transaction do
			# self.balance = (self.balance += amount).round(2)
			self.save!
			Deposit.save_history(self, amount)
		end
	end

	def withdraw(amount)
		return false unless amount_enough?(amount, self.balance)
		ActiveRecord::Base.transaction do
			# self.balance = (self.balance -= amount).round(2)
			self.save!
			Withdrawal.save_history(self, amount)
		end
	end

	def transfer(wallet_to, amount)
		return false unless amount_enough?(amount, self.balance)
		ActiveRecord::Base.transaction do
			# reduce from
			# self.balance = (self.balance -= amount).round(2)
			self.save!
			# add to
			# wallet_to.balance = (wallet_to.balance += amount).round(2)
			wallet_to.save!

			Transfer.save_history(self, wallet_to, amount)
		end
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
