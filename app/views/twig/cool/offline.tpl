{% extends "layouts/cool.tpl" %}

{% block simple_content %}
	<h1>Offline cache</h1>
	<p>See on offline mode, if you know what i mean</p>
{% endblock %}
{% block manifest %}{{baseUrl}}cache.appcache{% endblock %}

