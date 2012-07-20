class PostQueue < ActiveRecord::Base
	
	def self.enqueue_questions(current_acct, question_array)
    question_array.each_with_index do |q,i|
      PostQueue.create(:account_id => current_acct.id,
                       :question_id => q.id,
                       :index => i)
    end
  end

  def self.clear_queue(current_acct=nil)
  	if current_acct
  		items = PostQueue.where(:account_id => current_acct.id)
  		items.destroy_all
  	else
  		PostQueue.destroy_all
  	end
  end
end
