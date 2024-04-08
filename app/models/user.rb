# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :enum             default("trader"), not null
#  uid                    :string
#  unconfirmed_email      :string
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invited_by            (invited_by_type,invited_by_id)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid                   (uid) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  attr_accessor :login
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable,
          :validatable, :uid, :confirmable, authentication_keys: [:login]

  has_one :status, dependent: :destroy
  accepts_nested_attributes_for :status

  enum :role, {
    admin: "admin",
    trader: "trader"
  }, default: "trader"

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true
  before_create :initialize_status_for_trader

  scope :approved_traders, -> { includes(:status).where(role: :trader, statuses: { status_type: "approved" }) }
  scope :pending_traders, -> { includes(:status).where(role: :trader, statuses: { status_type: "pending" }).order(:created_at) }
  scope :confirmed_email_traders, -> { includes(:status).where(role: :trader, statuses: { status_type: "confirmed_email" }).order(:updated_at) }

  # sort traders to pending first, then confirmed_email, and approved last
  def self.sorted_traders
    pending_traders + confirmed_email_traders + approved_traders
  end

  def login
    @login || username || email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup

    if(login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def after_confirmation
    super
    # update the user's status to confirmed_email
    status.update(status_type: "confirmed_email") if status.present?
  end

  private

  def initialize_status_for_trader
    if trader?
      build_status(status_type: "pending")
    end
  end

end
