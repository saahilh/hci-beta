$(document).ready(function(){
  //if($("#poll-body").html().replace(/\s/g,"")!=""){
  //  $("#modal-button").click();
  //}

  let upvote_identifier = ".fa-thumbs-up";
  let downvote_identifier = ".fa-thumbs-down";
  let delete_identifier = ".fa-trash";
  let flag_identifier = ".fa-flag"

  function sort_question(question_item){
    let num_upvotes = parseInt(question_item.find(upvote_identifier).text());
    let num_downvotes = parseInt(question_item.find(downvote_identifier).text());

    while(num_upvotes > parseInt(question_item.prev().find(upvote_identifier).text())){
      question_item.insertBefore(question_item.prev());
    }

    while(num_upvotes < parseInt(question_item.next().find(upvote_identifier).text())){
      question_item.insertAfter(question_item.next());
    }

    while((num_upvotes==parseInt(question_item.prev().find(upvote_identifier).text())) && num_downvotes < parseInt(question_item.prev().find(downvote_identifier).text())){
      question_item.insertBefore(question_item.prev());
    }

    while((num_upvotes==parseInt(question_item.next().find(upvote_identifier).text())) && num_downvotes > parseInt(question_item.next().find(downvote_identifier).text())){
      question_item.insertAfter(question_item.next());
    }
  }

  let in_class_active = "btn-success";
  let in_class_inactive = "text-success btn-default";
  let after_class_active = "btn-primary";
  let after_class_inactive = "text-primary btn-default";

  function activate_in_class_button(question_item){
    question_item.find(".in-class").addClass(in_class_active).removeClass(in_class_inactive);
  }

  function activate_after_class_button(question_item){
    question_item.find(".after-class").addClass(after_class_active).removeClass(after_class_inactive);
  }

  function deactivate_in_class_button(question_item){
    question_item.find(".in-class").removeClass(in_class_active).addClass(in_class_inactive);
  }

  function deactivate_after_class_button(question_item){
    question_item.find(".after-class").removeClass(after_class_active).addClass(after_class_inactive);
  }

  App.room = App.cable.subscriptions.create({
    channel: "CourseChannel",
    room: room_name
  }, {
    connected: function() {},
    disconnected: function() { 
      App.room.unsubscribe(); 
    },
    received: function(data) {
      let question_id = data["question_id"];

      if(data["action"] == "new_question"){
        console.log(data["student_question"]);
        let questions_container = $("#questions-container");
        $("#questions-container.student-questions").append(data["student_question"]);
        $("#questions-container.lecturer-questions").append(data["lecturer_question"]);
        sort_question($("#q"+ question_id));
      }
      else{
        let question_item = $("#q"+ question_id);

        if(data["action"] == "new_status"){
          let new_status = data["new_status"];

          question_item.find(".question-status").text("Status: " + new_status);

          if(new_status=="pending"){
            deactivate_in_class_button(question_item);
            deactivate_after_class_button(question_item);
          }
          else if(new_status=="answered in class"){
            deactivate_after_class_button(question_item);
            activate_in_class_button(question_item);
          }
          else if(new_status=="will answer after class"){
            deactivate_in_class_button(question_item);
            activate_after_class_button(question_item);
          }
        }
        else if(data["action"] == "delete_question" || data["action"] == "flag_threshold_exceeded"){
          question_item.remove();
        }
        else if(data["action"] == "vote"){
          question_item.find(upvote_identifier).text(" " + data["upvote_count"]);
          question_item.find(downvote_identifier).text(" " + data["downvote_count"]);
          sort_question(question_item);
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

  $(document).on('click', downvote_identifier, function(){
    $(this).toggleClass("text-danger").toggleClass("btn-danger");
    $(this).closest(".question-item").find(upvote_identifier).removeClass("btn-primary").addClass("text-primary");
  });

  $(document).on('click', upvote_identifier, function(){
    $(this).toggleClass("text-primary").toggleClass("btn-primary");
    $(this).closest(".question-item").find(downvote_identifier).removeClass("btn-danger").addClass("text-danger");
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