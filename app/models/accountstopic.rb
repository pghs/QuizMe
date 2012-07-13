class Accountstopic < ActiveRecord::Base
	belongs_to :account
	belongs_to :topic
end
