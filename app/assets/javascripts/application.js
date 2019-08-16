// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require turbolinks
//= require jsapi
//= require_tree .
//= require chartkick
//= require bootstrap.min
//= require awesomplete.min
//= require mCustomScrollbar.min

$(document).on('click', ".response-button", function(){
  $("#responses").hide(); 
  $("#change-response").show();
})

$(document).on('click', "#change-response-button", function(){
  $("#responses").show(); 
  $("#change-response").hide();
})

$(window).on("load", function(){
  $(".custom-bar").mCustomScrollbar({
    axis: "y",
    alwaysShowScrollBar: 2,
    theme: "3d-thick",
    scrollInertia: 0,
    mouseWheelPixels: 170
  });
});

$(document).on('click', "#back", function(){ 
  $(".confirmation").hide(); 
  $("#submission").show(); 
});

$(document).on('click', "#create-account-button", function(e){
  e.preventDefault();
  form = $("#create-account-modal form");
  console.log("hi")
  $.ajax({
    type: form.attr("method"),
    url: form.attr("action"),
    data: form.serialize(),
    success: function(response){ 
      if(response.data.errors.length > 0){
        $(".modal-body.confirmation h4").text("Error");
        $("#back").removeAttr("data-dismiss");
        $("#create-modal-message").text(response.data.errors.join("\n"));
      }
      else{
        $(".modal-body.confirmation h4").text("Success!");
        $("#back").attr("data-dismiss", "modal");
        $("#create-modal-message").text("Successfully created account");
      }
      
      $("#submission").hide(); 
      $(".confirmation").show();
    },
    dataType: "json"
  });
});