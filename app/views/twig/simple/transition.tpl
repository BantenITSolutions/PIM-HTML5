{% extends "layouts/simple.tpl" %}

{% block simple_content %}
	<h1>CSS3 Transition</h1>
	<style>
		.transition{
			margin-bottom:10px;border-bottom:1px solid #e0e0e0;padding-bottom: 10px;
		}
		.transition .button{
			margin-top: 10px;
		}
		.transition .image{background:#f0f0f0;padding:10px;border:1px solid #e0e0e0;}
		.transition .image img{
			-webkit-transition:1s all ease-in-out;
			-moz-transition:1s all ease-in-out;
			-o-transition:1s all ease-in-out;
			-khtml-transition:1s all ease-in-out;
			-ms-transition:1s all ease-in-out;
			transition:1s all ease-in-out;
			position: relative;
		}
		.transition.start.fading .image img{
			opacity:0;
		}
		.transition.start.move .image img{
			left:500px;
		}
		.transition.start.scale .image img{
			transform:scale(0.5,0.5);
			-webkit-transform:scale(0.5,0.5);
			-moz-transform:scale(0.5,0.5);
			left:100px;
		}
		.transition.start.rotate .image img{
			transform:rotate(720deg);
			-webkit-transform:rotate(720deg);
			-moz-transform:scale(720deg);
			left:400px;
		}
	</style>
	<div class="transition-area">
		<div class="fading transition">
			<h3>Fade</h3>
			<div class="image">
				<img src="{{baseUrl}}img/PHP.png" />
			</div>
			<div class="button">
				<a href="#" class="btn btn-primary">Fade It</a>
			</div>
		</div>
		<div class="move transition">
			<h3>Move</h3>
			<div class="image">
				<img src="{{baseUrl}}img/PHP.png" />
			</div>
			<div class="button">
				<a href="#" class="btn btn-primary">Move It</a>
			</div>
		</div>
		<div class="scale transition">
			<h3>Scale</h3>
			<div class="image">
				<img src="{{baseUrl}}img/PHP.png" />
			</div>
			<div class="button">
				<a href="#" class="btn btn-primary">Move It</a>
			</div>
		</div>
		<div class="rotate transition">
			<h3>Rotation</h3>
			<div class="image">
				<img src="{{baseUrl}}img/PHP.png" />
			</div>
			<div class="button">
				<a href="#" class="btn btn-primary">Rotate It</a>
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