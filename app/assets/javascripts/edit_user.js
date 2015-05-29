$(function(){

  var errorField = $('.input-group > .text-danger:first'); 

  if (errorField.length > 0) {
    errorField.parents('.tab-pane').each(function(index, value) {
      var id = $(value).attr('id');
      var link = $('a[href="#' + id + '"');
      link.css('background-color', '#f2dede');
      link.tab('show');
    });
  }

  var removesLeft = $('.remove_fields');
  if (removesLeft.length == 1) {
    removesLeft.hide();
  }

  $('#edit-settings')
  .on('cocoon:before-insert', function(e, insertedItem) {
    var id = Date.now();
    $('.account-tabs .dropdown').before('<li role="presentation">' +
      '<a href="#acc-' + id + '" aria-controls="Nova Conta" role="tab" data-toggle="tab">Nova conta</a></li>');
    $('.accounts-contents').append('<div role="tabpanel" class="account-pane tab-pane" id="acc-' + id + '"></div>');
    $('.account-tabs > li:eq(-2) a').tab('show');
  })
  .on('cocoon:after-insert', function(e, insertedItem) {
    $(insertedItem).find('.timepicker').timepicker({showMeridian: false, minuteStep: 1});
    $(insertedItem).find('.yes-no-checkbox-switch').bootstrapSwitch({onText: 'Sim', offText: 'Não', onColor: 'success', offColor: 'danger'});

    var removesLeft = $('.remove_fields').not(':visible');
    removesLeft.show();
  })
  .on("cocoon:after-remove", function(e, account) {
    var currentTab = $('.account-tabs li.active');
    var prevTab = currentTab.siblings().not('.dropdown').find('a');
    
    currentTab.hide();
    prevTab.tab('show');

    var removesLeft = $('.remove_fields:visible');
    if (removesLeft.length == 1) {
      removesLeft.hide();
    }

  });
});