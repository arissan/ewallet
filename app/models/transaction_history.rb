class TransactionHistory < ApplicationRecord
	TYPES= %w(Transfer Deposit Withdrawal)
	validates :type, presence: true
  belongs_to :user
	belongs_to :from, class_name: 'Wallet', foreign_key: :from_id, optional: true
	belongs_to :to, class_name: 'Wallet', foreign_key: :to_id, optional: true

  def info
    wn= to.name if self.is_a?(Transfer)
    wn= from.name if self.is_a?(Withdrawal)
    wn= to.name if self.is_a?(Deposit)
    wn
  end

	private

	def self.amount_valid?(amount)
		return amount > 0
	end

end
