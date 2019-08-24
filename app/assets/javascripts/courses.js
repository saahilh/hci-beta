$(document).ready(function(){
  //if($('#poll-body').html().replace(/\s/g,'')!=''){
  // $('#modal-button').click();
  //}
  
  class QuestionList {
    constructor() {
      this.inClassActiveIdentifier = 'btn-success';
      this.inClassInactiveIdentifier = 'text-success btn-default';
      this.afterClassActiveIdentifier = 'btn-primary';
      this.afterClassInactiveIdentifier = 'text-primary btn-default';

      this.upvoteIdentifier = '.fa-thumbs-up';
      this.downvoteIdentifier = '.fa-thumbs-down';
      this.deleteIdentifier = '.fa-trash';
      this.flagIdentifier = '.fa-flag'
    }

    sortQuestion(questionItem) {
      const upvoteCount = parseInt(questionItem.find(this.upvoteIdentifier).text());
      const downvoteCount = parseInt(questionItem.find(this.downvoteIdentifier).text());

      while(upvoteCount > parseInt(questionItem.prev().find(this.upvoteIdentifier).text())){
        questionItem.insertBefore(questionItem.prev());
      }

      while(upvoteCount < parseInt(questionItem.next().find(this.upvoteIdentifier).text())){
        questionItem.insertAfter(questionItem.next());
      }

      while((upvoteCount==parseInt(questionItem.prev().find(this.upvoteIdentifier).text())) && downvoteCount < parseInt(questionItem.prev().find(this.downvoteIdentifier).text())){
        questionItem.insertBefore(questionItem.prev());
      }

      while((upvoteCount==parseInt(questionItem.next().find(this.upvoteIdentifier).text())) && downvoteCount > parseInt(questionItem.next().find(this.downvoteIdentifier).text())){
        questionItem.insertAfter(questionItem.next());
      }
    }

    activateInClassButton(questionItem) {
      questionItem.find('.in-class').addClass(this.inClassActiveIdentifier).removeClass(this.inClassInactiveIdentifier);
    }

    activateAfterClassButton(questionItem) {
      questionItem.find('.after-class').addClass(this.afterClassActiveIdentifier).removeClass(this.afterClassInactiveIdentifier);
    }

    deactivateInClassButton(questionItem) {
      questionItem.find('.in-class').removeClass(this.inClassActiveIdentifier).addClass(this.inClassInactiveIdentifier);
    }

    deactivateAfterClassButton(questionItem) {
      questionItem.find('.after-class').removeClass(this.afterClassActiveIdentifier).addClass(this.afterClassInactiveIdentifier);
    }

    addQuestion(data) {
      $('#questions-container.student-questions').append(data['student_question']);
      $('#questions-container.lecturer-questions').append(data['lecturer_question']);
      this.sortQuestion($(`#q${data["question_id"]}`));
    }

    removeQuestion(data) {
      $(`#q${data["question_id"]}`).remove();
    }

    updateStatus(data) {
      const questionItem = $(`#q${data["question_id"]}`);
      const newStatus = data['new_status'];

      questionItem.find('.question-status').text(`Status: ${newStatus}`);

      if(newStatus=='pending'){
        this.deactivateInClassButton(questionItem);
        this.deactivateAfterClassButton(questionItem);
      }
      else if(newStatus=='answered in class'){
        this.deactivateAfterClassButton(questionItem);
        this.activateInClassButton(questionItem);
      }
      else if(newStatus=='will answer after class'){
        this.deactivateInClassButton(questionItem);
        this.activateAfterClassButton(questionItem);
      }
    }

    vote(data) {
      const questionItem = $(`#q${data["question_id"]}`);
      questionItem.find(this.upvoteIdentifier).text(' ' + data['upvote_count']);
      questionItem.find(this.downvoteIdentifier).text(' ' + data['downvote_count']);
      this.sortQuestion(questionItem);
    }
  }

  const questionList = new QuestionList();

  if(roomName!=""){
    App.room = App.cable.subscriptions.create({
      channel: 'CourseChannel',
      room: roomName
    }, {
      connected: function() {},
      disconnected: function() { 
        App.room.unsubscribe(); 
      },
      received: function(data) {
        const questionId = data['question_id'];

        if(data['action'] == 'new_question'){
          questionList.addQuestion(data);
        }
        else{
          const questionItem = $('#q'+ questionId);

          if(data['action'] == 'newStatus'){
            questionList.updateStatus(data);
          }
          else if(data['action'] == 'delete_question' || data['action'] == 'flag_threshold_exceeded'){
            questionList.removeQuestion(data);
          }
          else if(data['action'] == 'vote'){
            questionList.vote(data);
          }
          //POLLS
          else if(data['answered']&&!data['changed']){
            $('#counter').text(parseInt($('#counter').text()) + 1);
          }
          else if(data['connected']){
            $('#active-connections').text(parseInt($('#active-connections').text())+1)
          }
          else if(data['disconnected']){
            $('#active-connections').text(parseInt($('#active-connections').text())-1)
          }
        }
      },
      speak: function(){}
    });
  }

  $(document).on('click', questionList.downvoteIdentifier, function(){
    $(this).toggleClass('text-danger').toggleClass('btn-danger');
    $(this).closest('.question-item').find(questionList.upvoteIdentifier).removeClass('btn-primary').addClass('text-primary');
  });

  $(document).on('click', questionList.upvoteIdentifier, function(){
    $(this).toggleClass('text-primary').toggleClass('btn-primary');
    $(this).closest('.question-item').find(questionList.downvoteIdentifier).removeClass('btn-danger').addClass('text-danger');
  });


  $(document).on('click', '.leave-class, #home', function(){
    App.room.unsubscribe();
  });

  $(document).on('click', '.ask-question button', function(e){
    e.preventDefault();

    form = $('form.ask-question');
    $.ajax({
      type: form.attr('method'),
      url: form.attr('action'),
      data: form.serialize(),
      success: function(response){ 
        $('form.ask-question input').val('');
      },
      dataType: 'json'
    });
  });
})