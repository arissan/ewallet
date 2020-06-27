class Withdrawal < TransactionHistory
  validate :validate_balance

  def validate_balance
    w= user.wallet
    if not w.is_balance_enought?(self.amount, self.item)
      self.errors.add(:balance, Wallet::BALANCE_NOT_ENOUGHT)
    end
    return self.errors.blank?
  end

  def self.save_history(wallet_from, amount, item, donatur, notes)
    transaction_history = wallet_from.user.withdrawals.new
    transaction_history.item = item
    transaction_history.donatur = donatur
    transaction_history.notes = notes
    transaction_history.amount = amount
    transaction_history.from = wallet_from
    transaction_history.save
    transaction_history
  end

end