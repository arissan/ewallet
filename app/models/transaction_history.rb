class TransactionHistory < ApplicationRecord
  TYPES= %w(Deposit Withdrawal)
	validates :type, presence: true, inclusion: { in: TYPES }
  validates :amount, numericality: {greater_than: 0}
  belongs_to :item
  belongs_to :user
  belongs_to :donatur, optional: true
	belongs_to :from, class_name: 'Wallet', foreign_key: :from_id, optional: true
	belongs_to :to, class_name: 'Wallet', foreign_key: :to_id, optional: true

  def info
    wn= to.no if [Deposit].include?(self.class)
    wn= from.no if self.is_a?(Withdrawal)
    wn
  end

  def type_ina
    {'Deposit' => 'Pemasukan', 'Withdrawal' => 'Pengeluaran'}[self.type.to_s]
  end

end
