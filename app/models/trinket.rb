class Trinket < ActiveRecord::Base
  belongs_to :user

  attr_accessible :current_value, :date_acquired, :description, :name, :quantity, :serial_number
  attr_accessible :attachment

  validates :user_id, :presence => true
  validates :name, :presence => true

  has_attached_file :attachment, styles: {
    thumb: '100x100>',
    medium: '300x300>'
  }

  def as_json(options={})
    super(:only => [:id, :user_id, :name, :description, :serial_number, :date_acquired, :quantity, :current_value])
  end
end
