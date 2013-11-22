jQuery(document).ready(function() {
  setTimeout(function() {
    var source = new EventSource('/tweets');
//console.log(source);
    source.addEventListener('refresh', function(e) {
//console.log('refresh fired');
      window.location.reload();
    });
  }, 1);
});
