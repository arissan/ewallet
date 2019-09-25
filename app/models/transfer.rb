class Transfer < TransactionHistory

  def self.save_history(wallet_from, wallet_to, amount)
    return false unless self.amount_valid?(amount)
    ActiveRecord::Base.transaction do
        transaction_history = wallet_from.user.transfers.new
        transaction_history.amount = amount
        transaction_history.from = wallet_from
        transaction_history.to = wallet_to
        transaction_history.last_balance = wallet_from.balance
        transaction_history.save!

        transaction_history = wallet_to.user.deposits.new
        transaction_history.amount = amount
        transaction_history.from = wallet_from
        transaction_history.to = wallet_to
        transaction_history.last_balance = wallet_to.balance
        transaction_history.save!
    end
  end

end