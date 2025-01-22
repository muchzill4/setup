window.addEventListener('load', function() {
  // New question on Cmd+.
  document.addEventListener('keydown', function(event) {
    if ((event.metaKey || event.ctrlKey) && event.key === '.') {
      event.preventDefault();
      window.location.href = "/new";
    }
  });

  // Recent questions on Cmd+;
  document.addEventListener('keydown', function(event) {
    if ((event.metaKey || event.ctrlKey) && event.key === ';') {
      event.preventDefault();
      window.location.href = "/recents";
    }
  });
});
