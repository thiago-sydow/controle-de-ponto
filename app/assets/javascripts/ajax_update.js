var updateTime = function() {
  $.get('/day_records/async_worked_time')
  .done(function(response){
    $('.info-worked-time').text(response.time);
    var chart = $('.easy-pie-chart.percentage');
    chart.data('easyPieChart').update(response.percentage);
    chart.find('.percent').text(response.percentage);
    
    // Random between 1 and 3 minutes
    var milliseconds = Math.floor(Math.random() * (180 - 60)) + 60;
    setTimeout(updateTime, milliseconds * 1000);
  });
};


$(function(){
  updateTime();
});
