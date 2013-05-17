{% extends "layout.html.tpl" %}

{% block content %}
	{% include "twig/sidebar/simple.tpl" %}
	<div class="span9">
		{% block simple_content %}{% endblock %}
	</div>
{% endblock %}