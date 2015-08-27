// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require moment
//= require moment/en-gb
//= require bootstrap-datetimepicker
//= require fullcalendar
//= require select2
//= require react
//= require react_ujs
//= require jquery-ui
//= require components
//= require_self

$(document).on('page:change', function() {
  $('#calendar').each(function() {
    element = $(this);
    element.fullCalendar({
      droppable: true,
      drop: function(date) {
        recipeElement = $(this);
        $('#meal_recipe_id').val(recipeElement.data('id'));
        $('#meal_date').val(date.format());
        $('#meal_serves').val(recipeElement.data('serves'));
        $('#meal-form-modal').modal('show');
      },
      events: element.data('events')
    });
  });

  $('.calendar-droppable').each(function() {
    element = $(this);
    element.draggable({
      revert: true,
      revertDuration: 0
    });
  });

  $('.date-select').datetimepicker({
     format: 'DD-MM-YYYY',
     showClose: true
  });

  $('.select2').select2({
    // options
  });
});
