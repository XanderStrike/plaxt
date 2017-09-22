var Home = new Object();

Home.init = function(authorization_link) {
  $('.js-authorize').click(function() {
    var username = $('.js-username').val();

    window.location = authorization_link.replace('USERNAME', username);
  });
}
