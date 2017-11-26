$(document).on('click', "#new-class-button", function(e){
  e.preventDefault();
  form = $("#new-class-form");
  $.ajax({
    type: form.attr("method"),
    url: form.attr("action"),
    data: form.serialize(),
    success: function(response){
      if(response.data.success!=0){
        $(".modal-body.confirmation h4").text("Success!")
        $("#no-courses").hide();
      }
      else
        $(".modal-body.confirmation h4").text("Error")

      $("#modal-message").text(response.data.msg);

      $("#open-confirmation-modal").click();
      if(response.data.success!=0){
        addClassButton($("#new-course-code").val(), response.data.success)
      }
    },
    dataType: "json"
  });
});

$("#new-course-code").unbind();

$(document).on('keydown', "#new-course-code", function (event) {
  var keypressed = event.keyCode || event.which;
  if (keypressed == 13 && $(this).val()!=""){
    $("#new-class-button").click();
  }
});


function addClassButton(course_name, course_id){
  var class_button = ""

  if($("#class-list").children(".row").last().children().length==3)
    class_button += '<div class="separator-sm"></div><div class="row">'
  
  class_button += '<div class="col-md-4 big-line"><div class="row"><div class="col-md-9">            <a href="/courses/';
  class_button += course_id
  class_button += '/course_page"><div class="btn btn-inverse fit big-btn">';
  class_button += course_name;
  class_button += '</div></a></div>';

  class_button += '<div class="col-md-3"><form action="/courses/';
  class_button += course_id;
  class_button += '/delete" method="post"><button type="submit" class="btn btn-danger fit big-btn">X</button></form></div></div></div>';

  if($("#class-list").children(".row").last().children().length==3){
    class_button += '</div>'
    $("#class-list").html($("#class-list").html() + class_button);
  }
  else{
    $("#class-list").children(".row").last().html($("#class-list").children(".row").last().html() + class_button)
  }

}