$(document).on('turbolinks:load', function(){

  //$("#submit_search_form").click (e) ->
  //  search_type = $('select#search_type').val();
  //  if search_type == 'Client' {
  //    $("#search_form").attr("action", "/orders/#{order_id}");
  //  }

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
