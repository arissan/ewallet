class Withdrawal < TransactionHistory

  def self.save_history(wallet_from, amount)
    return false unless self.amount_valid?(amount)
    transaction_history = wallet_from.user.withdrawals.new
    transaction_history.amount = amount
    transaction_history.from = wallet_from
    transaction_history.last_balance = wallet_from.balance
    transaction_history.save!
  end

end