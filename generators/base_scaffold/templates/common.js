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
  $('.search-toggle').click(function(){
    $('#search').toggle();
  });
});