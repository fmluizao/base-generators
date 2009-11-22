jQuery.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript");
  }
});

$(function(){
  $('.order_by a, .pagination a').livequery('click', function() {
    $('#results').load(this.href + '');
    return false;
  });

  $('#search').livequery(function(){
    $(this).ajaxForm({target: '#results'});
  });
  $('.toggle-block').click(function(){
    $(this).parents('.block').children('.sidebar-block').toggle();
  });
});|