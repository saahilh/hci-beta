$(document).on('click', "#start-polling-button", function(e){
  e.preventDefault();
  console.log("ok");
  form = $("#poll-form");
  if(form.find("#question").val()=="" && (form.find("#opt1").val()==""||form.find("#opt2").val()=="")){
    $("#modal-message").text("Please enter a question and at least two options.")
    $("#show-modal").click();
  }
  else if(form.find("#question").val()==""){
    $("#modal-message").text("Please enter a question.")
    $("#show-modal").click();
  }
  else if(form.find("#opt1").val()==""||form.find("#opt2").val()==""){
    $("#modal-message").text("Please enter at least two options.")
    $("#show-modal").click();
  }
  else{
    form.submit();
  }

});