{% extends "layout.html.tpl" %}

{% block content %}
<div class="span9">
	<h1 class="text-center">Face Detection</h1>
	<div id="msgbox" class="alert" style="display: none;">
		<span class="close" data-dismiss="alert">x</span>
		<p>Oops, something went wrong.</p>
	</div>

	<div id="dropbox">

		<form id="form-upload" enctype="multipart/form-data" action="/detect" method="POST" style="display: block;">
			<p>Drop your image here</p>
			<p>or</p>
			<p>
				<input id="file-input" type="file" name="image" />
				<button id="select-btn" class="btn btn-large btn-primary">Select from disk</button>
			</p>
		</form>

		<div id="progress" style="display: none;">
			<p>Uploading....</p>
			<div class="progress progress-striped active">
				<div class="bar" style="width: 50%;"></div>
			</div>
		</div>

		<div id="results" style="display: none;">
			<div class="source-img"></div>
			<div class="lightbox hide fade" tabindex="-1" role="dialog">
				<div class="lightbox-content"></div>
			</div>
			<div class="detected-faces"></div>
		</div>

	</div>
	<hr/>
	<a href="/async" id="restart-btn" class="btn btn-large btn-primary">Restart face detection</a>
</div>
{% endblock %}

{% block inline_scripts %}
$(function(){
	var dropbox = $("#dropbox"),
		form = $("#form-upload"),
		progress = $("#progress"),
		results = $("#results"),
		actions = $("#actions"),
		msgbox = $("#msgbox"),
		fileinput = $("#file-input");

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
		var files = e.originalEvent.target.files || e.originalEvent.dataTransfer.files;
		var file = files[0];
		var xhr = new XMLHttpRequest();

		if (file.type != "image/jpg" && file.type != "image/jpeg" && file.type != "image/png" ) {
			show_message("Please upload only JPG and PNG images.", false);
			return;
		} else if (file.size > 1000000) {
			show_message("Maximum file size is 1 MB!", false);
			return;
		} else if (!xhr.upload) {
			show_message("Your browser does not support XMLHttpRequest.upload. Please upgrade your browser.", false);
			return;
		}

		xhr.onreadystatechange = function(e) {
			if (xhr.readyState == 4 && xhr.status == 200) {
				parse_response(xhr.response);
			}
		}

		xhr.open("POST", form.attr("action"), true);
		xhr.setRequestHeader("X_FILENAME", file.name);
		xhr.send(file);

		show_page(progress);
	}

	function parse_response(res) {
		var data = jQuery.parseJSON(res);

		if (data.success == false) {
			show_page(form);
			show_message(data.msg);
			return;
		}

		results
			.find(".source-img").html("").end()
			.find(".detected-faces").html("").append("<p>Found " + (data.images.length-1) + " faces:</p>");

		$.each(data.images, function(i, img) {
			var el = '<img src="/' + img.src + '?r=' + Math.random() + '" alt="" />';
			results.find((i == 0 ? ".source-img" : ".detected-faces")).append(el);
		})

		results.find(".source-img img").bind('click', function(e) {
			var im = data.images[0];
			var el = '<img src="/' + im.src + '" width="' + im.width + '" height="' + im.height + '" alt="" />';
			$(".lightbox", results).find(".lightbox-content").html(el).end().lightbox("show");
		});

		show_page(results, actions);
	}

	// Open file dialog 
	$("#select-btn").click(function(e) {
		e.preventDefault();
		fileinput.click();
	});

	// Restart face detection
	$("#restart-btn").bind("click", function(e) {
		e.preventDefault();
		show_page(form);
	});
})
{% endblock %}