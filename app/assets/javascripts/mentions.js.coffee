# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	$('.btn.btn-success.correct').click -> 
		respond(true, false$(this).attr('m_id'))
	$('.btn.btn-success.first').click -> 
		respond(true, true, $(this).attr('m_id'))
	$('.btn.btn-danger.incorrect').click -> 
		respond(false, null, $(this).attr('m_id'))
	$('.btn.btn-warning.skip').click -> 
		respond(null, null, $(this).attr('m_id'))

	respond = (correct, first, id) ->
		mem = {}
		mem['mention_id'] = parseInt id
		mem['correct'] = correct
		mem['first'] = first
		console.log mem
		$.ajax '/mentions/update',
			type: 'POST'
			dataType: 'html'
			data: mem
			error: (jqXHR, textStatus, errorThrown) ->
				console.log "AJAX Error: #{errorThrown}"
			success: (data, textStatus, jqXHR) ->
				console.log "Success"
				$(".well[m_id=#{id}]").hide()