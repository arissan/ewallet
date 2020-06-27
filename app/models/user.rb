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

  def deposit(amount, item, donatur, notes)
    d= wallet.deposit(amount, item, donatur, notes)
    self.errors.merge!(d.errors) if d.errors.present?
    self
  end

  def withdraw(amount, item, donatur, notes)
    w= wallet.withdraw(amount, item, donatur, notes)
    self.errors.merge!(w.errors) if w.errors.present?
    self
  end

end
