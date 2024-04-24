# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  balance                :decimal(10, 2)   default(0.0)
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
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :uid, :confirmable, authentication_keys: [:login]

  has_one :status, dependent: :destroy
  accepts_nested_attributes_for :status

  has_many :transactions, dependent: :destroy
  has_many :stocks, through: :transactions

  enum :role, {
    admin: 'admin',
    trader: 'trader'
  }, default: 'trader'

  attr_accessor :login
  STATUS_TYPES = Status.status_types.keys # => ["pending", "approved", "confirmed_email"]

  validates :email, presence: true, uniqueness: true
  validates :balance, numericality: { greater_than_or_equal: 0, message: "Insufficient balance." }
  validates :username, length: {in: 5..20}, uniqueness: true
  validates :password, presence: true, on: :create

  before_create :initialize_status_for_trader
  after_invitation_accepted :update_status_of_invited_user

  scope :approved_traders, -> { includes(:status).where(role: :trader, statuses: { status_type: "approved" }) }
  scope :pending_traders, -> { includes(:status).where(role: :trader, statuses: { status_type: "pending" }).order(:created_at) }
  scope :confirmed_email_traders, -> { includes(:status).where(role: :trader, statuses: { status_type: "confirmed_email" }).order(:updated_at) }
  scope :filter_by_status, ->(filter) {
    if STATUS_TYPES.include?(filter)
      where(status_type: filter)
    else
      sorted_traders
    end
  }

  def self.sorted_traders(traders)
    traders.to_a.sort_by do |trader|
      case trader.status.status_type
      when "pending"
        1
      when "confirmed_email"
        2
      when "approved"
        3
      else
        4
      end
    end
  end

  ## DEVISE STUFF
  # for adding username on login
  def login
    @login || username || email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup

    if (login = conditions.delete(:login))
      where(conditions.to_h).where(['lower(username) = :value OR lower(email) = :value',
                                    { value: login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  # updating status of confirmed email (devise confirmable)
  def after_confirmation
    super
    status.update(status_type: 'confirmed_email') if status.present?
  end

  ## RANSACK STUFF
  # whitelisting params for search
  def self.ransackable_attributes(auth_object = nil)
    authorizable_ransackable_attributes
  end

  def self.ransackable_associations(auth_object = nil)
    authorizable_ransackable_associations
  end

  private

  def initialize_status_for_trader
    return unless trader?
    build_status(status_type: 'pending')
  end

  def update_status_of_invited_user
    status.update(status_type: "confirmed_email")
  end

end
