class Feed
	constructor: ->
		@initializeInfiniteScroll()
		@initializeNewPostListener()
	initializeInfiniteScroll: =>
		$(window).unbind ".infscr"
		console.log $("#feed_content")
		$(document).trigger "retrieve.infscr"
	# initializeNewPostListener: =>
		# $.ajax
			# url: 


$ -> window.feed = new Feed
