{% extends "layouts/awesome.tpl" %}

{% block simple_content %}
<div class="span9">
	<h1 class="text-center">Device API (Camera)</h1>
	<hr/>
	<video id="cssfilters-stream" class="videostream" autoplay="" title="Click me to apply CSS Filters" alt="Click me to apply CSS Filters"></video>
	<p><button id="capture-button">Capture video</button> <button id="stop-button">Stop</button></p>
</div>
{% endblock %}

{% block inline_scripts %}
$(function(){
	console.log('yay')
	var localMediaStream=null;
	function onFailSoHard(e){
		if(e.code==1){
			alert('User denied access to their camera');
		}else{
			alert('getUserMedia() not supported in your browser.');
		}
	}

	var video=document.querySelector('#cssfilters-stream');
	var button=document.querySelector('#capture-button');
	var localMediaStream=null;
	var idx=0;
	var filters=['grayscale','sepia','blur','brightness','contrast','hue-rotate','hue-rotate2','hue-rotate3','saturate','invert',''];

	function changeFilter(e){
		var el=e.target;
		el.className='';
		var effect=filters[idx++%filters.length];
		if(effect){
			el.classList.add(effect);
		}
	}
	button.addEventListener('click',function(e){
		if(navigator.getUserMedia){
			navigator.getUserMedia('video, audio',function(stream){
				video.src=stream;
				localMediaStream=stream;
			},onFailSoHard);
		}else if(navigator.webkitGetUserMedia){
			navigator.webkitGetUserMedia({video:true},function(stream){
				video.src=window.webkitURL.createObjectURL(stream);
				localMediaStream=stream;
			},onFailSoHard);
		}else{
			onFailSoHard({target:video});
		}
	},false);
	document.querySelector('#stop-button').addEventListener('click',function(e){
		video.pause();
		localMediaStream.stop();
	},false);
	video.addEventListener('click',changeFilter,false);
})
{% endblock %}