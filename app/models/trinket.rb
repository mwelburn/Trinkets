class Trinket < ActiveRecord::Base
  belongs_to :user
  has_many :trinket_attachments

  attr_accessible :current_value, :date_acquired, :description, :name, :quantity, :serial_number

  validates :user_id, :presence => true
  validates :name, :presence => true
  validates :quantity, :numericality => { :only_integer => true,
                                          :greater_than_or_equal_to => 0,
                                          :message => "must be a positive whole number" }
  validates :current_value, :numericality => true

  def as_json(options={})
    super(:only => [:id, :user_id, :name, :description, :serial_number, :date_acquired, :quantity, :current_value])
  end
end
