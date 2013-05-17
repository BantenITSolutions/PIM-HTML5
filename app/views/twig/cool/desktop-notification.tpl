{% extends "layouts/cool.tpl" %}

{% block simple_content %}
	<h1>Desktop Notification</h1>
	<p>See on Notification</p>

	<section id="desktop">
    <p class="callout notificationText">
      This presentation currently <strong class="displayBox">has</strong>
      permission to display notifications.
    </p>
    <p class="hcenter">
      <button class="showButton" style="display: inline; ">Show a notification</button>
      <button class="requestButton">Ask again</button>
    </p>
  </section>

{% endblock %}

{% block inline_scripts %}
var NotificationManager = function(slide) {
  this.DOM_SLIDE = slide;
  this.DISPLAY_BOX = slide.getElementsByClassName('displayBox')[0];
  this.SHOW_BUTTON = slide.getElementsByClassName('showButton')[0];
  this.PERM_BUTTON = slide.getElementsByClassName('requestButton')[0];
  
  this.SHOW_BUTTON.addEventListener('click', $.proxy(this, 'show'), false);
  this.PERM_BUTTON.addEventListener('click', $.proxy(this, 'request'), false);
  this.displayState();
};
NotificationManager.prototype.displayState = function() {
  if (!window.hasOwnProperty('webkitNotifications')) { 
    this.DISPLAY_BOX.innerHTML = 'does not support requesting';
    this.SHOW_BUTTON.style.display = 'none';
    this.PERM_BUTTON.style.display = 'none';
    return; 
  }
  var perm = window.webkitNotifications.checkPermission();
  if (perm == 0) {
    this.DISPLAY_BOX.innerHTML = 'has';
    this.SHOW_BUTTON.style.display = 'inline';
    this.PERM_BUTTON.innerText = 'Ask again';
  } else {
    this.DISPLAY_BOX.innerHTML = 'does not have';
    this.SHOW_BUTTON.style.display = 'none';
    this.PERM_BUTTON.innerText = 'Request permission';
  }
};
NotificationManager.prototype.request = function() {
  if (!window.hasOwnProperty('webkitNotifications')) { return; }
  window.webkitNotifications.requestPermission($.proxy(this, 'displayState'));
};
NotificationManager.prototype.show = function() {
  if (!window.hasOwnProperty('webkitNotifications')) { return; }
  if (window.webkitNotifications.checkPermission() == 0) {
    window.webkitNotifications.createNotification(
      '/img/notification.png', 
      'It\'s Meetup Time!', 
      '4th Meetup PHP Indonesia Surabaya!').show();
  } else {
    this.request();
  }
};

var notification = new NotificationManager(document);

{% endblock %}

