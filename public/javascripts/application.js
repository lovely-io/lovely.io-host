/**
 * The search form handler
 */
document.addEventListener('submit', function(event) {
  if (event.target.id == 'search') {
    event.preventDefault();
    var value = event.target.search.value;
    if (value) {
      document.location.href = "/packages/search/"+
        encodeURIComponent(value);
    }
  }
}, false);

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
