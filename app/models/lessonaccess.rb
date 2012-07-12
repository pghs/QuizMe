class Lessonaccess < ActiveRecord::Base
	belongs_to :account
	belongs_to :question
end
