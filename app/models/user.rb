class User < ActiveRecord::Base
  has_secure_password
  has_many :tickets
  has_many :messages

  attr_accessor :public

  def initialize(attributes = {})
    super
    @public ||= false
  end

  def public?
    @public
  end

  # unless this comes from the public facing forms, enforce these validations
  with_options unless: :public? do |o|
    o.validates :email, presence: true
    o.validates_format_of :email, with: /.+@.+\..+/i
    o.validates_uniqueness_of :email
    o.validates :fullname, presence: true
    o.validates :role, presence: true
    o.validates :role, inclusion: {in: %w[normal admin], message: 'is not a valid role.'}
  end

  # if this comes from the public facing forms, enforce these validations
  # usually from tickets#submit
  with_options if: :public? do |o|
    o.validates_format_of :email, with: /.+@.+\..+/i
    o.validates :email, presence: true
    o.validates :password, presence: true
  end
end
