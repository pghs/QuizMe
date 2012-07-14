class Feed
	name: null 
	questions: []
	constructor: ->
		@name = $("#feed_name").val()
		# @initializeInfiniteScroll()
		@initializeNewPostListener()
		@initializeQuestions()
	initializeQuestions: => @questions.push(new Post post) for post in $(".post")
	initializeInfiniteScroll: =>
		console.log $("#feed_content")
	initializeNewPostListener: =>
		pusher = new Pusher('bffe5352760b25f9b8bd')
		channel = pusher.subscribe(@name)
		channel.bind 'new_post', (data) => @displayNewPost(data)
	displayNewPost: (data) => 
		post = $("#post_template").clone().removeAttr("id").addClass("post")
		post.find(".question p").text(data.text)
		post.find(".header").text(@name)
		answers = post.find(".answers")
		for answer in data.answers
			answers.append("<div class='answer'>#{answer.text}</div>")
		$("#feed_content").prepend(post)

class Post
	element: null
	question: null
	answers: []
	constructor: (element) ->
		@element = $(element)
		@question = @element.find(".question").text()
		@answers.push(new Answer answer, @) for answer in @element.find(".answer")
	answerCorrect: =>
		@element.animate({background: "#EBFFF1"}, 1000)
		# @element.css("background", "#EBFFF1")
	# 	for answer in @answers
	# 		if answer.correct
	# 			answer.element.css("background", "#B3F2C7")
	# 		else
	# 			answer.element.css("background", "#FFC4C4")
	answerIncorrect: =>
		@element.animate({background: "#FFEDED"}, 1000)
		# @element.css("background", "#FFEDED")
	# 	for answer in @answers
	# 		if answer.correct
	# 			answer.element.css("background", "#B3F2C7")
	# 		else
	# 			answer.element.css("background", "#FFC4C4")		


class Answer
	post: null
	element: null
	correct: false
	constructor: (element, post) ->
		@post = post
		@element = $(element)
		@correct = true if @element.hasClass("correct")
		@element.on "click", => 
			if @correct
				@post.answerCorrect()
				@element.css("background", "#B3F2C7")
			else
				@post.answerIncorrect()
				@element.css("background", "#FFC4C4")

$ -> window.feed = new Feed