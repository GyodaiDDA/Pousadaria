class Inn < ApplicationRecord
  belongs_to :user
  has_many :rooms, dependent: :restrict_with_error
  validates :brand_name, :legal_name, :vat_number, :postal_code, presence: true
  validates :vat_number, uniqueness: true, length: { is: 14 }
end
