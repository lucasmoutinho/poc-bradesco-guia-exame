class Guide < ApplicationRecord
  belongs_to :provider
  belongs_to :patient
  has_many :procedures

  after_create :call_guide_service

  def call_guide_service
    local = false
    if local
      GuideService.new(self).update_guide_local
    else
      GuideService.new(self).update_guide_api
    end
  end
end
