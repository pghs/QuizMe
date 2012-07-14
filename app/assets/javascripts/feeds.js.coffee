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
		post.find(".question p").text(data.text)
		post.find(".header").text(@name)
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
		console.log element
		@answers = []
		@element = $(element)
		@question = @element.find(".question").text()
		@answers.push(new Answer answer, @) for answer in @element.find(".answer")
	answered: =>
		@element.css("background", "rgba(242, 242, 242, .2)")
		for answer in @answers
			answer.element.css("background", "gray")
			if answer.correct
				answer.element.css("color", "#003B05")
				# answer.element.css("font-weight", "bold")
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
			@post.answered()
			@element.css("color", "#800000") unless @correct
				

$ -> window.feed = new Feed