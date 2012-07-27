# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
	drawCharts = ->
		drawQuestionsAnswered()
		drawDailyActiveUsers()
		drawRetweets()
		drawRetentionTable('weekly-retention-twitter-graph', 'Weekly Retention: Twitter')
		drawRetentionTable('weekly-retention-studyegg-graph', 'Weekly Retention: StudyEgg')
		drawRetentionTable('daily-retention-twitter-graph', 'Daily Retention: Twitter')
		drawRetentionTable('daily-retention-studyegg-graph', 'Daily Retention: StudyEgg')

	drawQuestionsAnswered = ->
		data = new google.visualization.DataTable()
		data.addColumn "string", "Date"
		data.addColumn "number", "Twitter"
		data.addColumn "number", "QuizMe"
		data.addColumn "number", "Total"

		data.addRow ['7-19', 20, 25, 45]
		data.addRow ['7-20', 23, 25, 48]
		data.addRow ['7-21', 24, 25, 49]
		data.addRow ['7-22', 30, 25, 55]

		options = 
			width: 370
			height: 260

		chart = new google.visualization.LineChart(document.getElementById("questions-answered-graph"))
		chart.draw data, options

	drawDailyActiveUsers = ->
		data = new google.visualization.DataTable()
		data.addColumn "string", "Date"
		data.addColumn "number", "Twitter"
		data.addColumn "number", "QuizMe"
		data.addColumn "number", "Total"

		data.addRow ['7-19', 5, 5, 10]
		data.addRow ['7-20', 7, 4, 11]
		data.addRow ['7-21', 2, 9, 11]
		data.addRow ['7-22', 10, 19, 29]

		options = 
			width: 370
			height: 260

		chart = new google.visualization.LineChart(document.getElementById("daily-active-users-graph"))
		chart.draw data, options

	drawRetweets = ->
		data = new google.visualization.DataTable()
		data.addColumn "string", "Date"
		data.addColumn "number", "Twitter"

		data.addRow ['7-19', 5]
		data.addRow ['7-20', 7]
		data.addRow ['7-21', 2]
		data.addRow ['7-22', 10]

		options = 
			width: 370
			height: 260

		chart = new google.visualization.LineChart(document.getElementById("retweets-graph"))
		chart.draw data, options

	drawRetentionTable = (div, title)->
		data = new google.visualization.DataTable()
		data.addColumn "string", "date"
		data.addColumn "number", "1"
		data.addColumn "number", "2"
		data.addColumn "number", "3"
		data.addColumn "number", "4"
		data.addColumn "number", "5"
		data.addColumn "number", "6"
		data.addColumn "number", "7"
		data.addColumn "number", "8"
		data.addColumn "number", "9"
		data.addColumn "number", "10"

		data.addRow ['7-13', 20, 0, 10, 2, 20, 0, 10, 2, 0, 10]
		data.addRow ['7-14', 20, 0, 10, 2, 20, 0, 10, 2, 0, null]
		data.addRow ['7-15', 20, 0, 10, 2, 20, 0, 10, 2, null, null]
		data.addRow ['7-16', 20, 0, 10, 2, 20, 0, 10, null, null, null]
		data.addRow ['7-17', 20, 0, 10, 2, 20, 0, null, null, null, null]
		data.addRow ['7-18', 20, 0, 10, 2, 20, null, null, null, null, null]
		data.addRow ['7-19', 20, 0, 10, 2, null, null, null, null, null, null]
		data.addRow ['7-20', 20, 0, 10, null, null, null, null, null, null, null]
		data.addRow ['7-21', 20, 0, null, null, null, null, null, null, null, null]
		data.addRow ['7-22', 20, null, null, null, null, null, null, null, null, null]

		for i in [9..0]
			for j in [10..0]
				data.setCell(i, 10-j, null, null, {'className':'blank-cell'}) if i>j
		options = 
			title: 'Test Title'

		table = new google.visualization.Table(document.getElementById("#{div}"))
		table.draw data, options

	drawRepsChart = ->
		data = new google.visualization.DataTable()
		data.addColumn "string", "Date"
		data.addColumn "number", "Items Studied"
		for date, reps of jQuery.parseJSON $("#reps_data").html()
			console.log date
			console.log reps
			data.addRow [date, reps]
		options =
			width: 450
			height: 300
			title: "Items Studied"
		chart = new google.visualization.LineChart(document.getElementById("reps_chart"))
		chart.draw data, options

	if $('.stats').length>0
		google.load "visualization", "1",
			packages: [ "corechart", "table" ],
			callback: drawCharts