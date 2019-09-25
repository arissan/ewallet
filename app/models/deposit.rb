class Deposit < TransactionHistory

  def self.save_history(wallet_to, amount)
    return false unless self.amount_valid?(amount)
    transaction_history = wallet_to.user.deposits.new
    transaction_history.amount = amount
    transaction_history.to = wallet_to
    transaction_history.last_balance = wallet_to.balance
    transaction_history.save!
  end
end