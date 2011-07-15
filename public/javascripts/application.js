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