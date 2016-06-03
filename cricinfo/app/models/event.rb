class Event < ActiveRecord::Base
	belongs_to :bowler, class_name: 'Player', primary_key: "id", foreign_key: "bowler_id"
	belongs_to :batsman, class_name: 'Player', primary_key: "id", foreign_key: "batsman_id"
end
