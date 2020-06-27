class Deposit < TransactionHistory
  validate :validate_source_target

  def validate_source_target
    return to.valid? if from.blank?
    from.valid? and to.valid? and from != to
  end

  def self.save_history(wallet_to, amount, item, donatur, notes)
    transaction_history = wallet_to.user.deposits.new
    transaction_history.item = item
    transaction_history.donatur = donatur
    transaction_history.notes = notes
    transaction_history.amount = amount
    transaction_history.to = wallet_to
    transaction_history.save
    transaction_history
  end
end