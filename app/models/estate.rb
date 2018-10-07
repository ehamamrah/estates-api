class Estate < ApplicationRecord
  scope :ordered_by_creation_date, -> { order('created_at DESC') }
end
