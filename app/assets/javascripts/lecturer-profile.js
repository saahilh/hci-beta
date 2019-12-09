$(document).ready(function(){
  $('#new-class-form input').unbind();

  $(document).on('click', '#new-class-button', function(e){
    e.preventDefault();
    form = $('#new-class-form');
    $.ajax({
      type: form.attr('method'),
      url: form.attr('action'),
      data: form.serialize(),
      success: function(response){
        if(response.data.errors.length > 0){
          $('#message-modal #confirmation h4').text('Error')
          $('#message-modal .modal-message').text(response.data.errors.join('\n'));
        }
        else{
          $('#message-modal #confirmation h4').text('Success!')

          $('#message-modal .modal-message').text('Successfully created course ' + response.data.course_name);
          $('.class-list').append(createCourseIndexItem(response.data.course_id, response.data.course_name));
          $('#new-class-form input[name="new_course"]').val('');
        }

        $('#show-modal').click();
      },
      dataType: 'json'
    });
  });

  function createCourseIndexItem(courseId, courseName){
    let button = '';
    courseSelectButton  = `<a class="btn big-btn btn-default fit course-button" data-method="get" href="/courses/${courseId}">${courseName}</a>`;
    courseDeleteButton  = `<a class="btn big-btn btn-danger delete-button fa fa-trash" rel="nofollow" data-method="delete" href="/courses/${courseId}"></a>`;
    return `<div class="list-item">${courseSelectButton}${courseDeleteButton}</div>`;
  }

  $(document).on('keydown', '#new-class-form input[name="new_course"]', function(e) {
    const keypressed = event.keyCode || event.which;
    if(keypressed == 13 && $('.modal-open').length==1){
      e.preventDefault();
    }
  });

  $(document).on('keydown', function(e) {
    const keyPressed = e.keyCode || e.which;
    if(keyPressed == 13 && $('.modal-open').length){
      $('#show-modal').click();
    }
  });
});