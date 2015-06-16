//= require jquery
//= require bootstrap-sprockets
//= require wow.min
//= require jquery.singlePageNav.min

// preloader
$(window).load(function(){
  $('.preloader').fadeOut(1000); // set duration in brackets
});

$(function() {
  new WOW().init();
  $('.templatemo-nav').singlePageNav({
  	offset: 70,
    filter: ':not(.external)',
    updateHash: true
  });

});
