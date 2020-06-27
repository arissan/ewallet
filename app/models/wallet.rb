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

	def get_running_balance(running_id, item_id)
		sum_credit(running_id, item_id) -  sum_debit(running_id, item_id)
	end

	def deposit(amount, item, donatur, notes)
		Deposit.save_history(self, amount, item, donatur, notes)
	end

	def withdraw(amount, item, donatur, notes)
		Withdrawal.save_history(self, amount, item, donatur, notes)
	end

	def is_balance_enought?(amount, item)
		if amount.to_f > self.get_running_balance(TransactionHistory.last.id, item.id)
			self.errors.add(:balance, BALANCE_NOT_ENOUGHT)
		end
		return self.errors.blank?
	end

	private

		def sum_debit(running_id, item_id)
			summing_resources.where(['item_id = ? AND type IN (?) AND id <= ?', item_id, ['Withdrawal'], running_id]).order('id ASC').sum(:amount)
		end
Withdrawal
		def sum_credit(running_id, item_id)
			summing_resources.where(['item_id = ? AND type IN (?) AND id <= ?', item_id, ['Deposit'], running_id]).order('id ASC').sum(:amount)
		end

		def summing_resources
			TransactionHistory.order('id ASC')
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
