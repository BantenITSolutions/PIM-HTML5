{% extends "layout.html.tpl" %}

{% block content %}
<div class="span9">
	<img src="https://maps.googleapis.com/maps/api/staticmap?center=Semarang&zoom=4&size=640x200&scale=2&maptype=roadmap&sensor=false"/><hr/>
	<center><button class="btn btn-primary btn-large" id="btn-geo">Find me!</button></center>
</div>
{% endblock %}

{% block inline_scripts %}
$(function(){
	$('#btn-geo').click(function(){
		var container = $(this).parent().parent()
		if (navigator.geolocation) {
			navigator.geolocation.getCurrentPosition(function(position) {
				var lat = position.coords.latitude,
					lng = position.coords.longitude,
					map = "https://maps.googleapis.com/maps/api/staticmap?center={0},{1}&zoom=6&size=640x200&scale=2&maptype=roadmap&markers=color:green%7Clabel:X%7C{0},{1}&sensor=false"

				$('<img src="'+ map.format(lat.toFixed(6)+"",lng.toFixed(6)+"") +'">').load(function() {
					var that = $(this)
					container.html(that)
				});
			})
		} else{
			alert('Not supported browser')
		}
	})
})

{% endblock %}