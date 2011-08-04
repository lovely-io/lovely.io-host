var $ = Lovely.module('dom');
/**
 * The search form handler
 */
$(document).delegate('#search', 'submit', function(event) {
  event.stop();

  document.location.href = event.target.attr('action') + "/" +
    encodeURIComponent(event.target.input('search').value());
});

/**
 * Updating the userbar
 */
$(function() {
  if (document.cookie.indexOf('logged_in=true') != -1) {
    $('a#profile').show();
    $('a#login').hide();
  }
});

/**
 * GA handlers
 */
if (document.location.href.indexOf('lovely.io')) {
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-10292980-2']);
  _gaq.push(['_trackPageview']);

  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
}
