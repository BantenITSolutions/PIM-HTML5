<hr/>
<div class="well">
	<h3>Info:</h3>
	<ul>
	{% for info in infos %}
		<li>{{ info.key }} : <strong>{{ info.val }}</strong></li>
	{% endfor %}
	</ul>
</div>