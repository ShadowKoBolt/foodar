$(document).on('page:change', function() {
  $('#calendar').each(function() {
    var element = $(this);
    element.fullCalendar({
      drop: function(date) {
        var recipeElement = $(this);
        $('#meal_recipe_id').val(recipeElement.data('id'));
        $('#meal_date').val(date.format());
        $('#meal_serves').val(recipeElement.data('serves'));
        $('#meal-form-modal').modal('show');
      },
      droppable: true,
      events: element.data('events'),
      selectable: true,
      select: function(start, end) {
        $('#duplicate_start_date').val(start.format());
        $('#duplicate_end_date').val(end.format());
        $('#duplicate_target_date').val(moment().format('DD-MM-YYYY'));
        $('#duplicate-form-modal').modal('show');
      }
    });
  });

  $('.calendar-droppable').each(function() {
    var element = $(this);
    element.draggable({
      revert: true,
      revertDuration: 0
    });
  });
});
