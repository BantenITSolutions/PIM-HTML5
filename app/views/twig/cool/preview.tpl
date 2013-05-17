{% extends "layouts/cool.tpl" %}

{% block simple_content %}
	<h1>File system API</h1>
	
	<section>
	    <div id="dropzone" class="centercontents">
	      <p>Drag in image files from your desktop</p>
	    </div>
	</section>
	<section>
	    <div id="thumbnails"></div>
	</section>
{% endblock %}
{% block inline_scripts %}
function DNDFileController(id) {
  var el_ = document.getElementById(id);
  var thumbnails_ = document.getElementById('thumbnails');
  window.URL = window.URL ? window.URL :
             window.webkitURL ? window.webkitURL : null;

  this.dragenter = function(e) {
    e.stopPropagation();
    e.preventDefault();
    el_.classList.add('rounded');
  };

  this.dragover = function(e) {
    e.stopPropagation();
    e.preventDefault();
    e.dataTransfer.dropEffect = 'copy'; // Explicitly show this is a copy.
  };

  this.dragleave = function(e) {
    e.stopPropagation();
    e.preventDefault();
    el_.classList.remove('rounded');
  };

  this.drop = function(e) {
    e.stopPropagation();
    e.preventDefault();

    el_.classList.remove('rounded');

    var files = e.dataTransfer.files;

    for (var i = 0, file; file = files[i]; i++) {
      var imageType = /image.*/;
      if (!file.type.match(imageType)) {
        continue;
      }

      var fileUrl = window.URL.createObjectURL(file);
      var fileAttr = ['name', 'type', 'size', 'lastModifiedDate'];
      var fileProps = [];

      for (i=0;i<fileAttr.length;i++) {
      	var fileAttrVal = file[fileAttr[i]];
      	fileProps[i] = '<p><strong>' + fileAttr[i].toLowerCase() + '</strong> : ' + fileAttrVal + '</p>';
      }

      thumbnails_.insertAdjacentHTML(
        'afterBegin', fileProps.join('')+'<img src="' + fileUrl +
        '" width="100%" height="auto" alt="' + file.name + '" title="' + 
        file.name + '" />');
    }

    return false;
  };

  el_.addEventListener("dragenter", this.dragenter, false);
  el_.addEventListener("dragover", this.dragover, false);
  el_.addEventListener("dragleave", this.dragleave, false);
  el_.addEventListener("drop", this.drop, false);
};

document.addEventListener('DOMContentLoaded', function(e) {
  var dndc = new DNDFileController('dropzone');
}, false);
{% endblock %}