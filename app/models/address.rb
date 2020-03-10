class Address < ApplicationRecord
    belongs_to :user

    def to_s
        "#{address}, #{zip_code} #{city} #{country}"
    end
end
