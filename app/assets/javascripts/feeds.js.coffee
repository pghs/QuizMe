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
		post = $("#post_template").clone().removeAttr("id").addClass("post")
		console.log post.find(".question p")
		post.find(".header p").text("#{@name}:")
		post.find(".question p").text(data.text)
		answers = post.find(".answers")
		for answer in data.answers
			if answer.correct
				answers.append("<div class='answer correct'>#{answer.text}</div>")
			else
				answers.append("<div class='answer'>#{answer.text}</div>")
		if insertType == "prepend"
			$("#feed_content").prepend(post)
		else
			post.insertBefore("#show_more")
		@questions.push(new Post post)
	showMore: => $.getJSON "/feeds/#{@id}/more", (posts) => @displayNewPost(post.question, "append") for post in posts


class Post
	element: null
	question: null
	answers: []
	constructor: (element) ->
		@answers = []
		@element = $(element)
		@question = @element.find(".question").text()
		@answers.push(new Answer answer, @) for answer in @element.find(".answer")
	answered: (correct) =>
		if correct
			@element.css("background", "rgba(0, 59, 5, .2)") #rgba(242, 242, 242, 1)")
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