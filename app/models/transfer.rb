class Transfer < TransactionHistory
  attr_accessor :as_source_transfer
  validate :validate_balance, if: :as_source_transfer?
  validate :validate_source_target

  def as_source_transfer?
    @as_source_transfer
  end

  def validate_balance
    if not user.wallet.is_balance_enought?(self.amount)
      self.errors.add(:balance, Wallet::BALANCE_NOT_ENOUGHT)
    end
  end

  def validate_source_target
    if not (from.try(:valid?) and to.try(:valid?) and from != to )
      self.errors.add(:target, 'transfer doesnt not valid')
    end
  end

  def self.save_history(wallet_from, wallet_to, amount)
    transfer = wallet_from.user.transfers.new
    deposit = wallet_to.user.deposits.new
    ActiveRecord::Base.transaction do
        transfer.as_source_transfer= true
        transfer.amount = amount
        transfer.from = wallet_from
        transfer.to = wallet_to
        transfer.valid?
        transfer.save!

        deposit.amount = amount
        deposit.from = wallet_from
        deposit.to = wallet_to
        deposit.valid?
        deposit.save!
    end rescue false
    return {transfer: transfer, deposit: deposit}
  end

end