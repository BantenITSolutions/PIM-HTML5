<!DOCTYPE html>
<html{% set _manifest=block('manifest') %}{% if _manifest %} manifest="{{ _manifest|raw }}"{% endif %}>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title>{{ title }}</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width">

        <!-- Place favicon.ico and apple-touch-icon.png in the root directory -->

        <link rel="stylesheet" href="{{baseUrl}}css/normalize.css">
        <link rel="stylesheet" href="{{baseUrl}}css/main.css">
        <link rel="stylesheet" href="{{baseUrl}}css/bootstrap.min.css">
        <link rel="stylesheet" href="{{baseUrl}}css/bootstrap-responsive.min.css">

        {% if app.css %}
        {% for css in app.css %}
            <link rel="stylesheet" href="{{baseUrl}}{{ css }}">
        {% endfor %}
        {% endif %}

        <script src="{{baseUrl}}js/vendor/modernizr-2.6.2.min.js"></script>
    </head>
    <body>
        <!--[if lt IE 7]>
            <p class="chromeframe">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">activate Google Chrome Frame</a> to improve your experience.</p>
        <![endif]-->
        {% include "twig/header.tpl" %}
        <div class="container">
            <br/>
            <div class="row-fluid">
                {% block content %}{% endblock %}
            </div>
        </div>
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
        <script>window.jQuery || document.write('<script src="js/vendor/jquery-1.9.1.min.js"><\/script>')</script>
        <script src="{{baseUrl}}js/bootstrap.min.js"></script>
        <script src="{{baseUrl}}js/plugins.js"></script>
        <script src="{{baseUrl}}js/main.js"></script>
        {% if app.js %}
        {% for script in app.js %}
            <script src="{{baseUrl}}{{ script }}"></script>
        {% endfor %}
        {% endif %}
        <script>
            {% block inline_scripts %}{% endblock %}
        </script>
    </body>
</html>