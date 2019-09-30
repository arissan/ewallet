class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :wallet, dependent: :destroy
  has_many :transaction_histories, dependent: :destroy, dependent: :destroy
  has_many :transfers, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :withdrawals, dependent: :destroy

  after_create :open_wallet

  def open_wallet
    Wallet.open(self)
  end

  def deposit(amount)
    d= wallet.deposit(amount)
    self.errors.merge!(d.errors) if d.errors.present?
    self
  end

  def withdraw(amount)
    w= wallet.withdraw(amount)
    self.errors.merge!(w.errors) if w.errors.present?
    self
  end

  def transfer(target_user, amount)
    t= wallet.transfer(target_user.try(:wallet), amount)
    self.errors.merge!(t[:transfer].errors) if t[:transfer].errors.present?
    self.errors.merge!(t[:deposit].errors) if t[:deposit].errors.present?
    self
  end

end
