$(document).ready(function(){
  //if($("#poll-body").html().replace(/\s/g,"")!=""){
  //  $("#modal-button").click();
  //}

  let upvote_identifier = ".fa-thumbs-up";
  let downvote_identifier = ".fa-thumbs-down";
  let delete_identifier = ".fa-trash";

  function sort_question(question){
    let num_upvotes = parseInt(question.find(upvote_identifier).text());
    let num_downvotes = parseInt(question.find(downvote_identifier).text());

    while(num_upvotes > parseInt(question.prev().find(upvote_identifier).text())){
      $(question).insertBefore($(question).prev());
    }

    while(num_upvotes < parseInt(question.next().find(upvote_identifier).text())){
      $(question).insertAfter($(question).next());
    }

    while((num_upvotes==parseInt(question.prev().find(upvote_identifier).text())) && num_downvotes < parseInt(question.prev().find(downvote_identifier).text())){
      $(question).insertBefore($(question).prev());
    }

    while((num_upvotes==parseInt(question.next().find(upvote_identifier).text())) && num_downvotes > parseInt(question.next().find(downvote_identifier).text())){
      $(question).insertAfter($(question).next());
    }
  }

  /* STUDENTS
  App.room = App.cable.subscriptions.create({
    channel: "CourseChannel",
    room: room_name
  }, {
    connected: function() {},
    disconnected: function() { App.room.unsubscribe(); },
    received: function(data) {
      if(data["question"]){
        $("#questions-container").append(data["question"]);
        $("#no-quest").hide();
        sort_question(data["question_id"], "0", "0");
      }
      else if(data["delete_question"]){
        $("#questions-container #q" + data["delete_question"]).remove();
        if($(".question").length==0){
          $("#no-quest").show();
        }
      }
      else if(data["thumbsup"]){
        $("#q"+ data["thumbsup"] + " .upvotes").text(" " + data["upvote_count"]);
        $("#q"+ data["thumbsup"] + " .downvotes").text(" " + data["downvote_count"]);
        sort_question(data["thumbsup"], data["upvote_count"], data["downvote_count"])
      }
      else if(data["thumbsdown"]){
        $("#q"+ data["thumbsdown"] + " .upvotes").text(" " + data["upvote_count"]);
        $("#q"+ data["thumbsdown"] + " .downvotes").text(" " + data["downvote_count"]);
        sort_question(data["thumbsdown"], data["upvote_count"], data["downvote_count"])
      }
      else if(data["poll"]){
        $("#poll-body").html(data["poll"])
        if($("#poll-modal")[0].style.display=="none"||$("#poll-modal")[0].style.display=="")
          $("#modal-button").click()
      }
      else if(data["poll_end"]){
        $("#poll-body").html(data["chart"])
        if($("#poll-modal")[0].style.display=="none"||$("#poll-modal")[0].style.display=="")
          $("#modal-button").click()
      }
      else if(data["flag_thresh_alert"]){
        $("#q" + data["flag_thresh_alert"]).remove();
        if($(".question:visible").length==0)
          $("#no-quest").show();
      }
    },
    speak: function(){}
  });
  */

  if(room_name === undefined){
    App.room = App.cable.subscriptions.create({
      channel: "CourseChannel",
      room: room_name
    }, {
      connected: function() {},
      disconnected: function() { 
        App.room.unsubscribe(); 
      },
      received: function(data) {
        if(data["question"]){
          $("#questions-container.student-questions .mCSB_container").append(data["student_question"]);
          $("#questions-container.lecturer-questions .mCSB_container").append(data["lecturer_question"]);
          sort_question($("#q"+ data["question_id"]));
        }
        else if(data["pending"]){
          $("#questions-container #q" + data["question_id"] + " .question-status").text("Status: pending");
          $("#questions-container #q" + data["question_id"] + " .in-class button").removeClass("btn-success").addClass("text-success");
          $("#questions-container #q" + data["question_id"] + " .after-class button").removeClass("btn-primary").addClass("text-primary");
        }
        else if(data["in_class_enabled"]){
          $("#questions-container #q" + data["question_id"] + " .question-status").text("Status: answered in class");
          $("#questions-container #q" + data["question_id"] + " .in-class button").addClass("btn-success").removeClass("text-success");
          $("#questions-container #q" + data["question_id"] + " .after-class button").removeClass("btn-primary").addClass("text-primary");
        }
        else if(data["after_class_enabled"]){
          $("#questions-container #q" + data["question_id"] + " .question-status").text("Status: will answer after class");
          $("#questions-container #q" + data["question_id"] + " .in-class button").removeClass("btn-success").addClass("text-success");
          $("#questions-container #q" + data["question_id"] + " .after-class button").addClass("btn-primary").removeClass("text-primary");
        }
        else if(data["delete_question"]){
          $("#questions-container #q" + data["delete_question"]).remove();
        }
        else if(data["vote"]){
          let question = $("#q"+ data["vote"]);
          question.find(upvote_identifier).text(" " + data["upvote_count"]);
          question.find(downvote_identifier).text(" " + data["downvote_count"]);
          sort_question(question);
        }
        else if(data["flag_thresh_alert"]){
          $("#q" + data["flag_thresh_alert"]).remove();
        }
      },
      speak: function(){}
    });
  }

  $(document).on('click', '.btn-danger, .text-danger', function(){
    $(this).toggleClass("text-danger").toggleClass("btn-danger");
    $(this).closest(".question-item").find(upvote_identifier).removeClass("btn-primary").addClass("text-primary");
  });

  $(document).on('click', '.btn-primary, .text-primary', function(){
    $(this).toggleClass("text-primary").toggleClass("btn-primary");
    $(this).closest(".question-item").find(downvote_identifier).removeClass("btn-danger").addClass("text-danger");
  });

  $(document).on('click', '.fa-flag', function(){
    $(this).closest(".question-item").remove();
  })

  $(document).on('click', "#leave-class, #home", function(){
    App.room.unsubscribe();
  })

  $(".ask-question form input").unbind();

  $(document).on('keypress', '.ask-question form input', function(e){
    if (e.keyCode == 13 && $('.ask-question form input').val()!=""){
      $(".ask-question button").click();
      $('.ask-question form input').val('');
    }
  })

  $(document).on('click', ".ask-question button", function(){
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


  $(document).on('click', delete_identifier, function(){
    $(this).closest(".question-item").hide();
  });
})