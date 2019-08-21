$("#new-class-form input").unbind();

$(document).on('click', "#new-class-button", function(e){
  e.preventDefault();
  form = $("#new-class-form");
  $.ajax({
    type: form.attr("method"),
    url: form.attr("action"),
    data: form.serialize(),
    success: function(response){
      if(response.data.errors.length > 0){
        $(".modal-body.confirmation h4").text("Error")
        $("#modal-message").text(response.data.errors.join("\n"));
      }
      else{
        $(".modal-body.confirmation h4").text("Success!")

        $("#modal-message").text("Successfully created course " + response.data.course_name);
        $(".class-list").append(create_course_index_item(response.data.course_id, response.data.course_name));
        $('#new-class-form input[name=\"new_course\"]').val('');
      }

      $("#open-confirmation-modal").click();
    },
    dataType: "json"
  });
});

function create_course_index_item(course_id, course_name){
  let button = "";
  course_select_button = '<a class="btn btn-default big-btn fit course-button" data-method="get" href="/courses/' + course_id + '">' + course_name + '</a>';
  course_delete_button = '<a class="btn btn-danger big-btn delete-button fa fa-arrow-left" data-method="delete" rel="no-follow" href="/courses/' + course_id + '"">Delete</a>';
  return course_select_button + course_delete_button;
}

$(document).on('keydown', "#new-class-form input[name=\"new_course\"]", function (event) {
  var keypressed = event.keyCode || event.which;
  if (keypressed == 13 && $(this).val()!="" && $(".modal-open").length==0){
    $("#new-class-button").click();
  }
});

$(document).on('keydown', function (event) {
  var keypressed = event.keyCode || event.which;
  if (keypressed == 13 && $(".modal-open").length){
    $("#open-confirmation-modal").click();
  }
});