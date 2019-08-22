$(document).ready(function(){
  //if($("#poll-body").html().replace(/\s/g,"")!=""){
  //  $("#modal-button").click();
  //}

  const upvoteIdentifier = ".fa-thumbs-up";
  const downvoteIdentifier = ".fa-thumbs-down";
  const deleteIdentifier = ".fa-trash";
  const flagIdentifier = ".fa-flag"

  function sortQuestion(questionItem){
    const upvoteCount = parseInt(questionItem.find(upvoteIdentifier).text());
    const downvoteCount = parseInt(questionItem.find(downvoteIdentifier).text());

    while(upvoteCount > parseInt(questionItem.prev().find(upvoteIdentifier).text())){
      questionItem.insertBefore(questionItem.prev());
    }

    while(upvoteCount < parseInt(questionItem.next().find(upvoteIdentifier).text())){
      questionItem.insertAfter(questionItem.next());
    }

    while((upvoteCount==parseInt(questionItem.prev().find(upvoteIdentifier).text())) && downvoteCount < parseInt(questionItem.prev().find(downvoteIdentifier).text())){
      questionItem.insertBefore(questionItem.prev());
    }

    while((upvoteCount==parseInt(questionItem.next().find(upvoteIdentifier).text())) && downvoteCount > parseInt(questionItem.next().find(downvoteIdentifier).text())){
      questionItem.insertAfter(questionItem.next());
    }
  }

  const inClassActiveIdentifier = "btn-success";
  const inClassInactiveIdentifier = "text-success btn-default";
  const afterClassActiveIdentifier = "btn-primary";
  const afterClassInactiveIdentifier = "text-primary btn-default";

  function activateInClassButton(questionItem){
    questionItem.find(".in-class").addClass(inClassActiveIdentifier).removeClass(inClassInactiveIdentifier);
  }

  function activateAfterClassButton(questionItem){
    questionItem.find(".after-class").addClass(afterClassActiveIdentifier).removeClass(afterClassInactiveIdentifier);
  }

  function deactivateInClassButton(questionItem){
    questionItem.find(".in-class").removeClass(inClassActiveIdentifier).addClass(inClassInactiveIdentifier);
  }

  function deactivateAfterClassButton(questionItem){
    questionItem.find(".after-class").removeClass(afterClassActiveIdentifier).addClass(afterClassInactiveIdentifier);
  }

  App.room = App.cable.subscriptions.create({
    channel: "CourseChannel",
    room: roomName
  }, {
    connected: function() {},
    disconnected: function() { 
      App.room.unsubscribe(); 
    },
    received: function(data) {
      const questionId = data["question_id"];

      if(data["action"] == "new_question"){
        $("#questions-container.student-questions").append(data["student_question"]);
        $("#questions-container.lecturer-questions").append(data["lecturer_question"]);
        sortQuestion($("#q"+ questionId));
      }
      else{
        const questionItem = $("#q"+ questionId);

        if(data["action"] == "newStatus"){
          const newStatus = data["new_status"];

          questionItem.find(".question-status").text("Status: " + newStatus);

          if(newStatus=="pending"){
            deactivateInClassButton(questionItem);
            deactivateAfterClassButton(questionItem);
          }
          else if(newStatus=="answered in class"){
            deactivateAfterClassButton(questionItem);
            activateInClassButton(questionItem);
          }
          else if(newStatus=="will answer after class"){
            deactivateInClassButton(questionItem);
            activateAfterClassButton(questionItem);
          }
        }
        else if(data["action"] == "delete_question" || data["action"] == "flag_threshold_exceeded"){
          questionItem.remove();
        }
        else if(data["action"] == "vote"){
          questionItem.find(upvoteIdentifier).text(" " + data["upvote_count"]);
          questionItem.find(downvoteIdentifier).text(" " + data["downvote_count"]);
          sortQuestion(questionItem);
        }
        //POLLS
        else if(data["answered"]&&!data["changed"]){
          $("#counter").text(parseInt($("#counter").text()) + 1);
        }
        else if(data["connected"]){
          $("#active-connections").text(parseInt($("#active-connections").text())+1)
        }
        else if(data["disconnected"]){
          $("#active-connections").text(parseInt($("#active-connections").text())-1)
        }
      }
    },
    speak: function(){}
  });

  $(document).on('click', downvoteIdentifier, function(){
    $(this).toggleClass("text-danger").toggleClass("btn-danger");
    $(this).closest(".question-item").find(upvoteIdentifier).removeClass("btn-primary").addClass("text-primary");
  });

  $(document).on('click', upvoteIdentifier, function(){
    $(this).toggleClass("text-primary").toggleClass("btn-primary");
    $(this).closest(".question-item").find(downvoteIdentifier).removeClass("btn-danger").addClass("text-danger");
  });


  $(document).on('click', ".leave-class, #home", function(){
    App.room.unsubscribe();
  });

  $(document).on('click', ".ask-question button", function(e){
    e.preventDefault();

    form = $(".ask-question form");
    $.ajax({
      type: form.attr("method"),
      url: form.attr("action"),
      data: form.serialize(),
      success: function(response){ 
        $(".ask-question form input").val('');
      },
      dataType: "json"
    });
  });
})