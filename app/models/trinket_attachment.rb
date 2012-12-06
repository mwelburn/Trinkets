class TrinketAttachment < ActiveRecord::Base
  belongs_to :trinket

  attr_accessible :description
  attr_accessible :attachment

  validates :trinket_id, :presence => true
  validates_attachment :attachment, :presence => true,
                                    :size => { :in => 0..5.megabytes,
                                                 :message => 'File upload limited to 5MB' }
                                    #:content_type => { :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/,
                                    #                     :message => 'Only JPEG/PNG/GIF images are allowed' },

  has_attached_file :attachment, styles: {
    thumb: '100x100>',
    medium: '300x300>',
    large: '700x700>'
  }

  before_post_process :skip_for_non_image

  def skip_for_non_image
    attachment_content_type =~ /^image/
  end
end
