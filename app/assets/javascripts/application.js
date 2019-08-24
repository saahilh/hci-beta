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
//= require Chart.bundle
//= require chartkick
//= require bootstrap.min
//= require awesomplete.min
//= require mCustomScrollbar.min

// $(window).on('load', function(){
//   $('.custom-bar').mCustomScrollbar({
//     axis: 'y',
//     alwaysShowScrollBar: 2,
//     theme: '3d-thick',
//     scrollInertia: 0,
//     mouseWheelPixels: 170
//   });
// });

$(document).on('click', '#back', function(){ 
  $('.confirmation').hide(); 
  $('#submission').show(); 
});

$(document).on('click', '#create-account-button', function(e){
  e.preventDefault();
  form = $('#create-account-modal form');
  $.ajax({
    type: form.attr('method'),
    url: form.attr('action'),
    data: form.serialize(),
    success: function(response){ 
      if(response.data.errors.length > 0){
        $('.modal-body.confirmation h4').text('Error');
        $('#back').removeAttr('data-dismiss');
        $('#create-modal-message').text(response.data.errors.join('\n'));
      }
      else{
        $('.modal-body.confirmation h4').text('Success!');
        $('#back').attr('data-dismiss', 'modal');
        $('#create-modal-message').text('Successfully created account');
      }
      
      $('#submission').hide(); 
      $('.confirmation').show();
    },
    dataType: 'json'
  });
});

$(document).on('click', '#join-class, #lecturer-login', function(e){
  e.preventDefault();
  const form = $(this).closest('form');
  if(!form.find('input').val()==''){
    $.ajax({
      type: form.attr('method'),
      url: form.attr('action'),
      data: form.serialize(),
      success: function(response){
        if(response.data.msg){
          $('.modal-body.confirmation h4').text('Error')
          $('#modal-message').text(response.data.msg);
          $('#show-modal').click();
        }
        else{
          window.location.href = response.data.redirect;
        }
      },
      dataType: 'json'
    });
  }
});