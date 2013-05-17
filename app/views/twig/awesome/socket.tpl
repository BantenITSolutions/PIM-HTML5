{% extends "layouts/awesome.tpl" %}

{% block simple_content %}
<div class="span9">
	<style>
		.chat-area{border:1px solid #e0e0e0;position: relative}
		.chat-area header{background:#5388a7;color:#fff;border-bottom:1px solid #5388a9;}
		.chat-area header h1{font-size:24px;margin:0;}
		.chat-area .message #box{height:400px;overflow: auto}
		.chat-area .message #input input{border-radius:0;margin:0;border:none;border-top: 1px solid #e0e0e0;background: #fff;padding:16px;display:block;}
		.chat-area .message #input input:focus{-webkit-box-shadow:none;border-color:#e0e0e0;}
		.chat-area #btn-socket{position: absolute;top:50%;left:50%;margin-left:-116.5px;margin-top:-22px;}
		.chat-area #btn-socket-out{position: absolute;margin: 0;right:0;top:0;}
		.chat-area .overlay{background:rgba(0,0,0,0.5);width:100%;height:100%;position: absolute;;top:0;left: 0;}
		.chat-area .msg-container .date{position: absolute;
			right: 10px;
			top: 10px;
			font-size: 12px;
			color: #909090;
		}
		.chat-area .msg-container{position: relative;padding: 10px;min-height: 60px;border-bottom:1px solid #e0e0e0;}
		.chat-area .msg-container.joining{min-height: auto;color:#909090;font-style: italic;}
		.chat-area .msg-container.message .msg-content{font-weight: bold;font-size: 16px;}
		.chat-area .msg-container.message .msg-content strong{font-weight: normal;font-size: 14px;display:block;margin-top:5px;}
	</style>
	<div class="chat-area">
		<header>
			<h1 class="text-center">HTML5 + PHP Chat</h1>
		</header>
		<section class="message">
			<div id="box">
				
			</div>
			<div id="input"></div>
		</section>
		<div class="overlay"></div>
		<button class="btn btn-primary btn-large" id="btn-socket">Enter awesome channel</button>
	</div>
</div>
{% endblock %}

{% block inline_scripts %}
$(function(){
	var conn,
		isConnected = false,
		username,input = $('#input'),
			box = $('#box')

	input.append('<input class="input-block-level" type="text" placeholder="Type a message..."/>')
	input.find('.input-block-level').keypress(function(event) {
		if ( event.which == 13 ) {
			conn.send('msg.'+username+': <strong>'+$(this).val()+'</strong>')
			$(this).val('')
			event.preventDefault();
		}
	})
	$("#btn-socket").click(function(){
		var that = $(this)
			

		username = prompt("Please enter your name:", "Web socket Noob")

		if (username) {
			conn = new WebSocket('ws://localhost:8080')

			conn.onopen = function(e) {
				// Connection is established
				isConnected = true

				conn.send('join.'+username+' joining the awesomeness')

				// Create simple interface for input

				// Create quit button
				that.replaceWith($('<button id="btn-socket-out" class="btn btn-primary btn-danger"><i class="icon-trash icon-white"></i></button>'))
				$("#btn-socket-out").click(function(){
					location.reload()
				})

				// Put the user into text input
				input.find('.input-block-level').focus()
				$('.chat-area .overlay').fadeOut(500);
			}

			conn.onmessage = function(e) {
				var type,
					message,
					date = new Date(),
					data_arr = e.data.split('.')
				console.log(e.data);
				if (data_arr.length == 2) {
					type = data_arr[0],
					message = data_arr[1];
					var msgContainer = $('<div/>').addClass('msg-container'),
						dateContainer = $('<div/>').addClass('date'),
						msgContent = $('<div/>').addClass('msg-content');
					//message += '<span class="pull-right">'+date+'</span>'
					dateContainer.text(date.getHours()+':'+date.getMinutes()).attr('title',date.toDateString());
					msgContent.append(message);

					if (type == "join") {
					    msgContainer.addClass('joining').append(msgContent, dateContainer)
					} else if (type == "msg") {
						msgContainer.addClass('message').append(msgContent, dateContainer)
					} else {
					    msgContainer.addClass('error').append(msgContent)
					}
					box.append(msgContainer);
				} else {
				    box.append('<p class="alert-error">'+e.data+'</p>')
				}
			}
		}
	})
})
{% endblock %}