class Procedure < ApplicationRecord

    def rails_admin_title
        "#{code}: #{name} - #{profile}"
    end
end
