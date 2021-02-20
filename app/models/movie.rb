class Movie < ActiveRecord::Base
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    
    def self.all_ratings()
        @all_ratings
    end
        
    
    # def self.with_ratings(rating_list)
    #     if rating_list.nil? 
    #         return self.all
    #     end
    #     where('upper(rating) IN (?)', ratings_list)
    # end
end
