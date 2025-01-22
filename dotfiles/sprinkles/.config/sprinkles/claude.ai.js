window.addEventListener('load', function() {
  // Function to focus the specified input on cmd + /
  function focusInput(inputSelector) {
    document.addEventListener('keydown', function(event) {
      if ((event.metaKey || event.ctrlKey) && event.key === '/') {
        event.preventDefault();
        document.querySelector(inputSelector).focus();
      }
    });
  }

  // Function to navigate to a link on cmd + .
  function navigateToLink(linkHref) {
    document.addEventListener('keydown', function(event) {
      if ((event.metaKey || event.ctrlKey) && event.key === '.') {
        event.preventDefault();
        window.location.href = linkHref;
      }
    });
  }

  // Example usage
  focusInput('[contenteditable="true"][translate="no"][enterkeyhint="enter"][tabindex="0"].ProseMirror');
  navigateToLink('/new');
});
