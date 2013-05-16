{% extends "layouts/awesome.tpl" %}

{% block simple_content %}
<div class="span9">
	<h1 class="text-center">Geolocation Positioning</h1>
	<hr/>
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
					lng = position.coords.longitude

				drawMap(container,{lat:lat,lng:lng})
			})
		} else{
			alert('Not supported browser')
		}
	})

	function drawMap(container,data) {
		var lat = data.lat,
			lng = data.lng,
			map = "https://maps.googleapis.com/maps/api/staticmap?center={0},{1}&zoom=6&size=640x200&scale=2&maptype=roadmap&markers=color:green%7Clabel:X%7C{0},{1}&sensor=false",
			geo_api = "http://maps.googleapis.com/maps/api/geocode/json?latlng={0},{1}&sensor=false"

		// Reverse geolocation
		$.ajax({
			url:geo_api.format(lat.toFixed(6)+"",lng.toFixed(6)+""),
			success:function(data){
				// Save and get parsed data
				$.ajax({
					type:"POST",
					url:"/awesome-stuff/georeverse",
					data:{info:data},
					success:function(location) {
						$('<img src="'+ map.format(lat.toFixed(6)+"",lng.toFixed(6)+"") +'">').load(function() {
							var that = $(this)
							container.html(that)
							container.append(location)
						})
					}
				})
			}
		})
	}
})

{% endblock %}