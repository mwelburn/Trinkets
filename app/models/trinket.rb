class Trinket < ActiveRecord::Base
  belongs_to :user

  attr_accessible :current_value, :date_acquired, :description, :name, :original_value, :serial_number

  validates :user_id, :presence => true
  validates :name, :presence => true

  def as_json(options={})
    super(:only => [:id, :user_id, :name, :description, :serial_number, :date_acquired, :original_value, :current_value])
  end
end
