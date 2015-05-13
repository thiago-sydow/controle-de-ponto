var updateTime = function() {
  $.get('/day_records/async_worked_time')
  .done(function(response){
    $('.info-worked-time').text(response.time);
    var chart = $('.easy-pie-chart.percentage');
    chart.data('easyPieChart').update(response.percentage);
    chart.find('.percent').text(response.percentage);
    setTimeout(updateTime, 60000);
  });
};


$(function(){
  updateTime();
});
