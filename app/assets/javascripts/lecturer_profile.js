$("#new-class-form input").unbind();

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
      else{
        $(".modal-body.confirmation h4").text("Error")
      }

      $("#modal-message").text(response.data.msg);

      $("#open-confirmation-modal").click();

      if(response.data.success!=0){
        $(".class-list").append($(response.data.success));
        $('#new-class-form input[name=\"new_course\"]').val('');
      }
    },
    dataType: "json"
  });
});

$(document).on('keydown', "#new-class-form input[name=\"new_course\"]", function (event) {
  var keypressed = event.keyCode || event.which;
  if (keypressed == 13 && $(this).val()!=""){
    $("#new-class-button").click();
  }
});

$(document).on('keydown', function (event) {
  var keypressed = event.keyCode || event.which;
  if (keypressed == 13 && $(".modal-open").length){
    $("#open-confirmation-modal").click();
  }
});