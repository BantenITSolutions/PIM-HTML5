{% extends "layouts/simple.tpl" %}

{% block simple_content %}
	<h1>Media</h1>
	<div class="group">
		<h3>Video</h3>
		<video controls>
			<source type="video/mp4" src="http://www.w3schools.com/html/mov_bbb.mp4" >
			<source type="video/mp4" src="http://www.w3schools.com/html/mov_bbb.webm" >
			<source type="video/mp4" src="http://www.w3schools.com/html/mov_bbb.ogg" >
		</video>
	</div>
	<div class="group">
		<h3>Audio</h3>
		<audio controls>
			<source type="video/mp4" src="http://www.w3schools.com/html/horse.mp3" >
			<source type="video/mp4" src="http://www.w3schools.com/html/horse.ogg" >
			<source type="video/mp4" src="http://www.w3schools.com/html/horse.wav" >
		</audio>
	</div>
{% endblock %}