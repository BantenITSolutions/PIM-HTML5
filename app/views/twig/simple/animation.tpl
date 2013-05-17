{% extends "layouts/simple.tpl" %}

{% block simple_content %}

	<h1>CSS3 Animation</h1>
	<style>
		.animate .image img{
			-webkit-animation:rotating 10s infinite linear;position:relative;
		}
		@-webkit-keyframes rotating{
			0%{-webkit-transform:rotate(0deg);left:0;}
			50%{left:500px;}
			100%{-webkit-transform:rotate(1440deg);}
		}
	</style>
	<div class="animation-area">
		<div class="animate rotate">
			<div class="image">
				<img src="{{baseUrl}}img/PHP.png" />
			</div>
		</div>
	</div>
{% endblock %}

{% block inline_scripts %}
	jQuery(function($){
		$('.transition .button a').click(function(){
			$(this).closest('.transition').toggleClass('start');
			return false;
		});
	})
{% endblock %}