class Topic < ActiveRecord::Base
	has_many :accounts, :through => :accountstopics
end
