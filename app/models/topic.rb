class Topic < ActiveRecord::Base
	has_many :accounts, :through => :accountstopics
	has_many :accountstopics
end
