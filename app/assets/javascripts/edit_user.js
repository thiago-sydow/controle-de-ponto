$(function(){
  $('#edit-settings')
  .on('cocoon:before-insert', function(e, insertedItem) {
    var id = 0;
    $('.account-tabs .dropdown').before('<li role="presentation">' +
      '<a href="#acc-' + id + '" aria-controls="Nova Conta" role="tab" data-toggle="tab">Nova conta</a></li>');
    $('.accounts-contents').append('<div role="tabpanel" class="account-pane tab-pane" id="acc-' + id + '"></div>');
    $('.account-tabs li:eq(2) a').tab('show');
  })
  .on('cocoon:after-insert', function(e, insertedItem) {
    $(insertedItem).find('.timepicker').timepicker({showMeridian: false, minuteStep: 1});
    $(insertedItem).find('.yes-no-checkbox-switch').bootstrapSwitch({onText: 'Sim', offText: 'Não', onColor: 'success', offColor: 'danger'});
  })
  .on('cocoon:after-remove', function(e, insertedItem) {
    
  });
});