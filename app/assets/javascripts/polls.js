$(document).ready(function(){
  $(document).on('click', "#start-polling-button", function(e){
    e.preventDefault();
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

  var optionCount = 0;

  function createPollOption(optionNumber) {
    opt =   '<div class="poll-option">';
    opt +=    '<span>Option ' + optionNumber + '</span>';
    opt +=    '<input id="opt' + optionNumber + '" name="opt' + optionNumber + '" type="textarea" placeholder="Type an answer for the poll here" maxlength="30"/>';
    opt +=  '</div>';
    return opt;
  }

  addOption();
  addOption();

  function addOption(){
    if(optionCount < 5) {
      optionCount += 1;   
      
      $("#poll-options").append($(createPollOption(optionCount)));

      $("#remove-option").removeClass("disabled");

      if(optionCount==5){
        $("#add-option").addClass("disabled");
      }
    }
  }

  function removeOption(){
    if(optionCount > 2){
      optionCount -= 1;

      $("#poll-options .poll-option").last().remove();

      $("#add-option").removeClass("disabled");
      if(optionCount==2){
        $("#remove-option").addClass("disabled");
      }
    }
  }

  $(document).on("click", "#add-option", addOption);
  $(document).on("click", "#remove-option", removeOption);
});