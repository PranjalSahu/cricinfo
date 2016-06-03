class Player < ActiveRecord::Base
	has_many :bowling_events, class_name: 'Event', foreign_key: 'bowler_id'
	has_many :batting_events, class_name: 'Event', foreign_key: 'batsman_id'
end
