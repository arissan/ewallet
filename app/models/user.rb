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
    wallet.deposit(amount)
  end

  def withdraw(amount)
    wallet.withdraw(amount)
  end

  def transfer(target_user, amount)
    wallet.transfer(target_user.wallet, amount)
  end

end
