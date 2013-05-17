{% extends "layouts/cool.tpl" %}

{% block simple_content %}
	<h1>Preview Before Upload</h1>
	
	<div id="dropbox">

		<form id="form-upload" enctype="multipart/form-data" action="/awesome-stuff/detect" method="POST" style="display: block;">
			<p>Drop your image here</p>
			<p>or</p>
			<p>
				<input id="file-input" type="file" name="image" />
				<button id="select-btn" class="btn btn-large btn-primary">Select from disk</button>
			</p>
		</form>
		<div id="previewImage">

		</div>

	</div>
{% endblock %}
{% block inline_scripts %}
jQuery(function($){
	
	var dropbox = $("#dropbox"),
		form = $("#form-upload"),
		progress = $("#progress"),
		results = $("#results"),
		actions = $("#actions"),
		msgbox = $("#msgbox"),
		fileinput = $("#file-input"),
		template=$('<div/>').addClass('preview').append(
			$('<div/>').addClass('image').append($('<img/>')),
			$('<div/>').addClass('progress').append()
		);

	if (window.File && window.FileList && window.FileReader) {
		init();
	}

	function show_page() {
		form.hide();
		progress.hide();
		results.hide();
		actions.hide();
		msgbox.hide();

		for (var i = 0; i < arguments.length; i++)
			arguments[i].show();
	}

	function show_message(msg, success) {
		msgbox
			.removeClass("alert-error")
			.removeClass("alert-success")
			.addClass(success? "alert-success" : "alert-error")
			.find("p").text(msg).end()
			.show();
	}

	function init() {
		dropbox.bind("dragover", fileDragHover);
		dropbox.bind("dragleave", fileDragHover);
		dropbox.bind("drop", fileSelectHandler);
		fileinput.bind("change", fileSelectHandler);
	}

	function fileDragHover(e) {
		e.stopPropagation();
		e.preventDefault();
		dropbox.removeClass("hover").addClass(e.type == "dragover" ? "hover" : "");
	}

	function fileSelectHandler(e) {
		fileDragHover(e);
		e.preventDefault()
		var files = e.originalEvent.target.files || e.originalEvent.dataTransfer.files;
		var xhr = new XMLHttpRequest();
		var formData = new FormData();
		for(key in files)
		{
			var file = files[key];
			var pattern = /image/i;
			if(pattern.test(file.type))
			{
				previewImage(file);
				formData.append(file);
			}
		}

	}
	function previewImage(file)
	{
		var canvasTemplate=template.clone(),canvas = $('<canvas/>').appendTo(canvasTemplate);
		canvasTemplate.appendTo('#previewImage');
		var canvasImage = canvas.getContext('2d'),
		img = new Image();
		img.src = URL.createObjectURL(file);
		img.onload = function(){
			canvasImage.drawImage(img);
		}
	}
})
{% endblock %}