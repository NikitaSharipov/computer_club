$(document).on('turbolinks:load', function(){

      $(document).ready(function() {
        // Function to change form action.
        $("#computer_id").change(function() {
          var selected_id = $(this).children(":selected").attr('value');
          $("#computer-reservation").attr('url', '/computers/' + selected_id + '/reserve');
        });
      });

});

App.cable.subscriptions.create('ReservationsChannel', {
  connected: function() {
    this.perform('follow');
  },

  received: function(data) {
    var positionNumber = data.search("id")+3;
    var computerReservationId = data.charAt(positionNumber);
    $('.computer_' + computerReservationId).append(data);
  }
});
