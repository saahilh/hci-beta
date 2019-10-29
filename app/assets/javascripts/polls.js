$(document).ready(function(){
  $(document).on('click', '#start-polling-button', function(e){
    e.preventDefault();

    let firstOption = $('#poll-options .poll-option input').eq(0);
    let secondOption = $('#poll-options .poll-option input').eq(1);

    if($('#poll-question').val()=='' && (firstOption.val()==''||secondOption.val()=='')){
      $('#message-modal .modal-message').text('Please enter a question and at least two options.')
      $('#show-modal').click();
    }
    else if($('#poll-question').val()==''){
      $('#message-modal .modal-message').text('Please enter a question.')
      $('#show-modal').click();
    }
    else if(firstOption.val()==''||secondOption.val()==''){
      $('#message-modal .modal-message').text('Please enter at least two options.')
      $('#show-modal').click();
    }
    else{
      $('#poll-form').submit();
    }
  });

  let optionCount = 0;

  function createPollOption(optionNumber) {
    return `<div class="poll-option"><span>Option ${$('#poll-options .poll-option').length + 1}</span><input name="options[${optionNumber}]" type="textarea" placeholder="Type an answer for the poll here" maxlength="30"/></div>`;
  }

  addOption();
  addOption();

  function addOption(){
    if(optionCount < 5) {
      optionCount += 1;   
      
      $('#poll-options').append($(createPollOption(optionCount)));

      $('#remove-option').removeClass('disabled');
      
      if(optionCount==5){
        $('#add-option').addClass('disabled');
      }
    }
  }

  function removeOption(){
    if(optionCount > 2){
      optionCount -= 1;

      $('#poll-options .poll-option').last().remove();

      $('#add-option').removeClass('disabled');
      if(optionCount==2){
        $('#remove-option').addClass('disabled');
      }
    }
  }

  $(document).on('click', '#add-option', addOption);
  $(document).on('click', '#remove-option', removeOption);

  $(document).on('click', '.response-button', function(){
    $('#responses').hide(); 
    $('#change-response').show();
  });

  $(document).on('click', '#change-response-button', function(){
    $('#responses').show(); 
    $('#change-response').hide();
  });
});