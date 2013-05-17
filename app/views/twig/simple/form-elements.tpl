{% extends "layouts/simple.tpl" %}

{% block simple_content %}
	<h1>Form Elements</h1>
	<div class="forms">
		<form action="#" class="form-horizontal">
			
			<div class="control-group">
				<label class="control-label">Name</label>
				<div class="controls">
					<input type="text" required name="name" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Search</label>
				<div class="controls">
					<input type="search" required name="name" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Email</label>
				<div class="controls">
					<input type="email" required name="name" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Number</label>
				<div class="controls">
					<input type="number" name="name" min="2" max="10" step="2" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Color</label>
				<div class="controls">
					<input type="color" name="name"/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Range</label>
				<div class="controls">
					<input type="range" name="name" value="1" min="1" max="100" onchange="$(this).next().find('.value').text($(this).val());"/>
					<div class="value-context">
						The value of the range is: <strong class="value">1</strong>
					</div>
				</div>
			</div>

			<div class="control-group">
				<label class="control-label">List Type</label>
				<div class="controls">
					<input list="modules" type="text"/>
					<datalist id="modules">
						<option value="Taufan Aditya">
						<option value="Glend Maatita">
						<option value="Mochamad Gufron">
					</datalist>
				</div>
			</div>


		</div>
	</div>
{% endblock %}