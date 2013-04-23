{% extends "layout.html.tpl" %}

{% block content %}
<div class="span9">
	<h1 class="text-center">Web Socket Chat</h1>
	<hr/>
	<div id="input"></div>
	<div id="box">
		<center><button class="btn btn-primary btn-large" id="btn-socket">Enter awesome channel</button></center>
	</div>
</div>
{% endblock %}

{% block inline_scripts %}
$(function(){
	var conn,
		isConnected = false,
		username

	$("#btn-socket").click(function(){
		var that = $(this),
			input = $('#input'),
			box = $('#box')

		username = prompt("Please enter your name:", "Web socket Noob")

		if (username) {
			conn = new WebSocket('ws://localhost:8080')

			conn.onopen = function(e) {
				// Connection is established
				isConnected = true

				conn.send('join.'+username+' joining the awesomeness')

				// Create simple interface for input
				input.append('<input class="input-block-level" type="text" placeholder="Type a message..."/>')
				input.find('.input-block-level').keypress(function(event) {
					if ( event.which == 13 ) {
						conn.send('msg.'+username+': <strong>'+$(this).val()+'</strong>')
						$(this).val('')
						event.preventDefault();
					}
				})

				// Create quit button
				that.replaceWith($('<button id="btn-socket-out" class="btn btn-primary btn-large">Quit</button>'))
				$("#btn-socket-out").click(function(){
					location.reload()
				})

				// Put the user into text input
				input.find('.input-block-level').focus()
			}

			conn.onmessage = function(e) {
				var type,
					message,
					date = new Date(),
					data_arr = e.data.split('.')

				if (data_arr.length == 2) {
					type = data_arr[0],
					message = data_arr[1]
					message += '<span class="pull-right">'+date+'</span>'

					if (type == "join") {
					    box.prepend('<p class="alert alert-success">'+message+'</p>')
					} else if (type == "msg") {
					    box.prepend('<p class="alert alert-info">'+message+'</p>')
					} else {
					    box.prepend('<p class="alert">'+message+'</p>')
					}
				} else {
				    box.prepend('<p class="alert-error">'+e.data+'</p>')
				}
			}
		}
	})
})
{% endblock %}