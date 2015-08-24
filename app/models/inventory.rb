class Inventory < ActiveRecord::Base
  mount_uploader :spreadsheet_file, FileUploader

  validates_presence_of :spreadsheet_file
  validates :organization, presence: true

  belongs_to :organization
end
