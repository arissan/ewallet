class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :wallet
  has_many :transaction_histories
  has_many :transfers
  has_many :deposits
  has_many :withdrawals

  def open_wallet
    Wallet.open(self)
  end

end
