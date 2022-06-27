# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  extend Devise::Models

  has_many :catalogues, dependent: :destroy, as: :owner
  has_many :shirts, dependent: :destroy, as: :owner
  has_many :stores, dependent: :destroy, as: :owner

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  scope :without_current, ->(id) { where.not(id: id) }
  include DeviseTokenAuth::Concerns::User

  validates :name, :lastname, :country, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  def fullname
    "#{name} #{lastname}"
  end
end
