
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

  $('.datepicker').datepicker({language: 'pt-BR', format: 'dd/mm/yyyy', autoclose: true});
  $('.timepicker').timepicker({showMeridian: false, minuteStep: 1});
  $('.yes-no-checkbox-switch').bootstrapSwitch({onText: 'Sim', offText: 'Não', onColor: 'success', offColor: 'danger'});

  $('.time-records-container').find('.nested-fields').each(function(index){
    $(this).find('.entrance-exit').text(index % 2 == 0 ? 'Entrada ' : 'Saída ' );
    $(this).find('.number-of-type').text(Math.ceil((index + 1) / 2));
  });

  $('.time-records-container')
  .on('cocoon:before-insert', function(e, insertedItem) {
    var count = $('.nested-fields').length;
    if (count > 0) {
      $(insertedItem).find('.entrance-exit').text(count % 2 == 0 ? 'Entrada ' : 'Saída ' );
      $(insertedItem).find('.number-of-type').text(Math.ceil((count + 1) / 2));
    }
  })
  .on('cocoon:after-insert', function(e, insertedItem) {
    $(insertedItem).find('.timepicker').timepicker({showMeridian: false, minuteStep: 1});
  });

});
