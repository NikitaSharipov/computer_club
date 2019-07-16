$(document).on('turbolinks:load', function(){
  $('.computer').on('click', '.leave-request-link', function(e) {
     e.preventDefault();
     $(this).hide();
     console.log($('computer-request'))
     $('form#computer-request').removeClass('hidden');
  });

  $('.computers').on('click', '.add-computer-link', function(e) {
     e.preventDefault();
     $(this).hide();
     $('form#add-computer').removeClass('hidden');
  });

});
