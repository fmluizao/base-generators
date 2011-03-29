jQuery.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript");
  }
});

$(function(){
  $('a.sort_link, .pagination a').live('click', function() {
    $('#results').load(this.href + '');
    return false;
  });

  $('#search').ajaxForm({target: '#results'});

  $('.toggle-block').click(function(){
    $(this).parents('.block').children('.sidebar-block').toggle();
  });
});
