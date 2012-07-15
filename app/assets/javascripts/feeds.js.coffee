class Feed
	id: null
	name: null 
	questions: []
	constructor: ->
		@name = $("#feed_name").val()
		@id = $("#feed_id").val()
		@initializeNewPostListener()
		@initializeQuestions()
		$("#show_more").on "click", => @showMore()
		$(window).on "scroll", => @showMore() if ($(document).height() == $(window).scrollTop() + $(window).height())
	initializeQuestions: => @questions.push(new Post post) for post in $(".post")
	initializeNewPostListener: =>
		pusher = new Pusher('bffe5352760b25f9b8bd')
		channel = pusher.subscribe(@name)
		channel.bind 'new_post', (data) => @displayNewPost(data, "prepend")
	displayNewPost: (data, insertType) => 
		# $("#feed_content").first().animate({"top": "200px"})
		post = $("#post_template").clone().removeAttr("id").addClass("post").attr("post_id", data.id)
		post.find(".header p").text("#{@name} (3m ago):")
		post.find(".question p").text(data.text)
		post.css "visibility", "hidden"
		answers = post.find(".answers")
		for answer in data.answers#@randomize(data.answers)
			if answer.correct
				answers.append("<div class='answer correct'>#{answer.text}</div>")
			else
				answers.append("<div class='answer'>#{answer.text}</div>")
		if insertType == "prepend"
			$("#feed_content").prepend(post)
		else
			post.insertBefore("#show_more")
		post.css('visibility','visible').hide().fadeIn('slow')
		@questions.push(new Post post)
	showMore: => 
		lastPostID = $(".post").last().attr "post_id"
		$.getJSON "/feeds/#{@id}/more/#{lastPostID}", (posts) => 
			if posts.length > 0
				@displayNewPost(post.question, "append") for post in posts
			else
				$(window).off "scroll"
	randomize: (myArray) =>
		i = myArray.length
		return false if i == 0
		while --i
			j = Math.floor( Math.random() * ( i + 1 ) )
			tempi = myArray[i]
			tempj = myArray[j]
			myArray[i] = tempj
			myArray[j] = tempi				


class Post
	id: null
	element: null
	question: null
	answers: []
	constructor: (element) ->
		@answers = []
		@element = $(element)
		@id = @element.attr "post_id"
		@question = @element.find(".question").text()
		@answers.push(new Answer answer, @) for answer in @element.find(".answer")
	answered: (correct) =>
		if correct
			@element.css("background", "rgba(0, 59, 5, .2)")
		else
			@element.css("background", "rgba(128, 0, 0, .1)")
		for answer in @answers
			answer.element.css("background", "gray")
			if answer.correct
				answer.element.css("color", "#003B05")
			else
				answer.element.css("color", "#A3A3A3")


class Answer
	post: null
	element: null
	correct: false
	constructor: (element, post) ->
		@post = post
		@element = $(element)
		@correct = true if @element.hasClass("correct")
		@element.on "click", =>
			@post.answered(@correct)
			@element.css("color", "#800000") unless @correct
			answer.element.off "click" for answer in @post.answers


$ -> window.feed = new Feed