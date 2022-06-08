class Procedure < ApplicationRecord
    has_and_belongs_to_many :guides
    def rails_admin_title
        "#{code}: #{name} - #{profile}"
    end
end
