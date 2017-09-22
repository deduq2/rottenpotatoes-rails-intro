class Movie < ActiveRecord::Base
    
    def self.get_ratings
        Movie.select(:rating).distinct.order(:rating).map { |r| r.rating }
    end
end
