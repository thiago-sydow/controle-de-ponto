var updateTime = function() {
  $.get('/day_records/async_worked_time')
  .done(function(response){
    $('.info-worked-time').text(response.time);
    var chart = $('.easy-pie-chart.percentage');
    chart.data('easyPieChart').update(response.percentage);
    chart.find('.percent').text(response.percentage);
    setTimeout(updateTime, 20000);
  });
};

var updateTimeLabels = function() {
  $('.time-records-container').find('.nested-fields').each(function(index){
    $(this).find('.entrance-exit').text(index % 2 === 0 ? 'Entrada ' : 'Saída ' );
    $(this).find('.number-of-type').text(Math.ceil((index + 1) / 2));
  });
};

$(function(){

  $.fn.twitter_bootstrap_confirmbox.defaults = {
      fade: false,
      title: null, // if title equals null window.top.location.origin is used
      cancel: "Cancelar",
      cancel_class: "btn btn-default",
      proceed: "Excluir",
      proceed_class: "btn btn-danger"
  };

  $.fn.datepicker.defaults.format = "dd/mm/yyyy";
  $.fn.datepicker.defaults.language = 'pt-BR';

  $('[data-toggle=popover]').popover();

  $('.datepicker').datepicker({language: 'pt-BR', format: 'dd/mm/yyyy', autoclose: true});
  $('.timepicker').timepicker({showMeridian: false, minuteStep: 1});
  $('.yes-no-checkbox-switch').bootstrapSwitch({onText: 'Sim', offText: 'Não', onColor: 'success', offColor: 'danger'});

  $('.time-records-container')
  .on('cocoon:before-insert', function(e, insertedItem) {
    var count = $('.nested-fields').length;
    if (count > 0) {
      $(insertedItem).find('.entrance-exit').text(count % 2 === 0 ? 'Entrada ' : 'Saída ' );
      $(insertedItem).find('.number-of-type').text(Math.ceil((count + 1) / 2));
    }
  })
  .on('cocoon:after-insert', function(e, insertedItem) {
    $(insertedItem).find('.timepicker').timepicker({showMeridian: false, minuteStep: 1});
  })
  .on('cocoon:after-remove', function(e, insertedItem) {
    updateTimeLabels();
  });

  $('.easy-pie-chart.percentage').each(function(){
		var $box = $(this).closest('.infobox');
		var barColor = $(this).data('color') || $box.css('color');
		var trackColor = '#E2E2E2';
		var size = parseInt($(this).data('size')) || 50;
		$(this).easyPieChart({
			barColor: barColor,
			trackColor: trackColor,
			scaleColor: false,
			lineCap: 'butt',
			lineWidth: parseInt(size/10),
			animate: /msie\s*(8|7|6)/.test(navigator.userAgent.toLowerCase()) ? false : 1000,
			size: size
		});
	});

  updateTimeLabels();
  updateTime();
});
