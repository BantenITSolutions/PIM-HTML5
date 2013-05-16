{% extends "layouts/awesome.tpl" %}

{% block simple_content %}
<div class="span9">
	<h1 class="text-center">Advanced Character Physics</h1>
	<hr/>
	<div class="experiment">
        <canvas height="440px" width="900px">
            <strong>Sorry, It looks as though your browser does not support the canvas tag...</strong> If you can, I suggest that you try Chrome or Safari.
        </canvas>
        <p>Click and drag to move points. Hold down any key to pin them.</p>
        <p class="form-inline"><label class="checkbox"><input type="checkbox" id="constraints" checked="checked"/>Draw Lines</label> &nbsp; <label class="checkbox"><input type="checkbox" id="points" />Draw Points</label><br/></p>
    </div>
    
	<br/>

	<h1 class="text-center">Realtime Chart</h1>
	<hr/>
	<div class="demo-container">
		<div id="placeholder" class="demo-placeholder"></div>
	</div>
	<p>Real-time updates every: <input id="updateInterval" type="text" value="" style="text-align: right; width:5em"> milliseconds</p>

</div>
{% endblock %}

{% block inline_scripts %}
$(function(){
	var data = [],
		totalPoints = 50,
		plot

	function getAnotherData() {

		if (data.length > 0)
			data = data.slice(1);

		// Do a random walk

		while (data.length < totalPoints) {

			var prev = data.length > 0 ? data[data.length - 1] : 50,
				y = prev + Math.random() * 10 - 5;

			if (y < 0) {
				y = 0;
			} else if (y > 100) {
				y = 100;
			}

			data.push(y);
		}

		// Zip the generated y values with the x values

		var res = [];
		for (var i = 0; i < data.length; ++i) {
			res.push([i, data[i]])
		}

		console.log(typeof [res], [res])
		return [res];
	}

	function getRandomData(max, cb) {
		$.ajax({
			type:"POST",
			url:"/awesome-stuff/chart",
			data:{points:max,currentData:data},
			success: function(d) {
				data = [d];
				if (typeof cb == "function") {
					return cb(data)
				} else {
					return data
				}
			}
		})
	}

	// Set up the control widget
	var updateInterval = 2000;
	$("#updateInterval").val(updateInterval).change(function () {
		var v = $(this).val();
		if (v && !isNaN(+v)) {
			updateInterval = +v;
			if (updateInterval < 1) {
				updateInterval = 1;
			} else if (updateInterval > 2000) {
				updateInterval = 2000;
			}
			$(this).val("" + updateInterval);
		}
	});

	getRandomData(totalPoints,function(chartData) {
		plot = $.plot("#placeholder", chartData, {
			series: {
				lines: {
					fill:true
				},
				shadowSize: 0	// Drawing is faster without shadows
			},
			yaxis: {
				min: 0,
				max: 100
			},
			xaxis: {
				show: false
			}
		});

		update();
	})
	

	function update() {
		getRandomData(totalPoints,function(chartData){
			plot.setData(chartData);
			plot.draw();
			setTimeout(update, updateInterval);
		})
	}

})

{% endblock %}