# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	$('.btn.btn-success').click -> 
		respond(true, $(this).attr('m_id'))
	$('.btn.btn-danger').click -> 
		respond(false, $(this).attr('m_id'))
	$('.btn.btn-warning').click -> 
		respond(null, $(this).attr('m_id'))

	respond = (correct, id) ->
		mem = {}
		mem['mention_id'] = parseInt id
		mem['correct'] = correct
		console.log mem
		$.ajax '/mentions/update',
			type: 'POST'
			dataType: 'html'
			data: mem
			error: (jqXHR, textStatus, errorThrown) ->
				console.log "AJAX Error: #{errorThrown}"
			success: (data, textStatus, jqXHR) ->
				console.log "Success"
				#$("##{id}").hide()