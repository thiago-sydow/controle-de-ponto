	//* detect touch devices
    function is_touch_device() {
	  return !!('ontouchstart' in window);
	}

	$(function() {

		//* make active on accordion change
		$('#side_accordion').on('hidden.bs.collapse shown.bs.collapse', function () {
			gebo_sidebar.make_active();
            gebo_sidebar.scrollbar();
		});
		//* resize elements on window resize
		var lastWindowHeight = $(window).height();
		var lastWindowWidth = $(window).width();
		$(window).on("debouncedresize",function() {
			if($(window).height()!=lastWindowHeight || $(window).width()!=lastWindowWidth){
				lastWindowHeight = $(window).height();
				lastWindowWidth = $(window).width();
			}
		});
		//* tooltips
		gebo_tips.init();
        if(!is_touch_device()){
		    //* popovers
            gebo_popOver.init();
        }
		//* sidebar
        gebo_sidebar.init();
		gebo_sidebar.make_active();
		//* breadcrumbs
        //* gebo_crumbs.init();
		//* pre block prettify
		//* prettyPrint();
		//* external links
		gebo_external_links.init();
		//* accordion icons
		gebo_acc_icons.init();
		//* colorbox single
		if($('.cbox_single').length) {
			gebo_colorbox_single.init();
		}
		//* main menu mouseover
		gebo_nav_mouseover.init();
		//* top submenu
		gebo_submenu.init();

		//* mobile navigation
		selectnav('mobile-nav', {
			indent: '-'
		});

		gebo_sidebar.scrollbar();
		//gebo_sidebar.update_scroll();

		//* style switcher
		//* gebo_style_sw.init();

		//* to top
		//* $().UItoTop({inDelay:200,outDelay:200,scrollSpeed: 500});

		$('body').on('touchstart.dropdown', '.dropdown-menu', function (e) { e.stopPropagation(); });

	});

    gebo_sidebar = {
        init: function() {
			var $body = $('body'),
				$sidebar_switch = $('.sidebar_switch');

			// sidebar onload state
			if($(window).width() > 979){
				if(!$body.hasClass('sidebar_hidden')) {
                    if( $.cookie('gebo_sidebar') == "hidden") {
                        $body.addClass('sidebar_hidden');
                        $sidebar_switch.toggleClass('on_switch off_switch').attr('title','Show Sidebar').attr('data-original-title', "Show Sidebar");
                    }
                } else {
                    $sidebar_switch.toggleClass('on_switch off_switch').attr('title','Show Sidebar').attr('data-original-title', "Show Sidebar");
                }
            } else {
                $body.addClass('sidebar_hidden');
                $sidebar_switch.removeClass('on_switch').addClass('off_switch');
            }

            gebo_sidebar.info_box();

			//* sidebar visibility switch
            $sidebar_switch.click(function(){
                $sidebar_switch.removeClass('on_switch off_switch');
                if( $body.hasClass('sidebar_hidden') ) {
                    $.cookie('gebo_sidebar', null);
                    $body.removeClass('sidebar_hidden');
                    $sidebar_switch.addClass('on_switch').show();
                    $sidebar_switch.attr( 'title', "Hide Sidebar").attr('data-original-title', "Hide Sidebar");
                } else {
                    $.cookie('gebo_sidebar', 'hidden');
                    $body.addClass('sidebar_hidden');
                    $sidebar_switch.addClass('off_switch');
                    $sidebar_switch.attr( 'title', "Show Sidebar" ).attr('data-original-title', "Show Sidebar");
                }
				gebo_sidebar.info_box();
				//gebo_sidebar.update_scroll();
				$(window).resize();
            });
            //* prevent accordion link click
            $('.sidebar .accordion-toggle').click(function(e){e.preventDefault()});

			$(window).on("debouncedresize", function() {
				gebo_sidebar.scrollbar();
			});

        },
        info_box: function(){
			var s_box = $('.sidebar_info');
			var s_box_height = s_box.actual('height');
			s_box.css({
				'height'        : s_box_height
			});
			$('.push').height(s_box_height);
			$('.sidebar_inner').css({
				'margin-bottom' : '-'+s_box_height+'px',
				'min-height'    : '100%'
			});
        },
		make_active: function() {
			var thisAccordion = $('#side_accordion');
			thisAccordion.find('.panel-heading').removeClass('sdb_h_active');
			var thisHeading = thisAccordion.find('.panel-body.in').prev('.panel-heading');
			if(thisHeading.length) {
				thisHeading.addClass('sdb_h_active');
			}
		},
		scrollbar: function() {
			var $sidebar_inner_scroll = $('.sidebar_inner_scroll');
			if($sidebar_inner_scroll.length) {
				$sidebar_inner_scroll.slimScroll({
					position: 'left',
					height: 'auto',
					alwaysVisible: true,
					opacity: '0.2',
					wheelStep: is_touch_device() ? 40 : 1
				});
			}
        }
    };

	//* tooltips
	gebo_tips = {
		init: function() {
			if(!is_touch_device()){
				var shared = {
					style: {
						classes: 'qtip-tipsy'
					},
					show: {
						delay: 100
					},
					hide: {
						delay: 0
					}
				};
				var $ttip_b = $('.ttip_b'),
					$ttip_t = $('.ttip_t'),
					$ttip_l = $('.ttip_l'),
					$ttip_r = $('.ttip_r');

				if($ttip_b.length) {
					$ttip_b.qtip( $.extend({}, shared, {
						position: {
							my: 'top center',
							at: 'bottom center',
							viewport: $(window)
						}
					}));
				}
				if($ttip_t.length) {
					$ttip_t.qtip( $.extend({}, shared, {
						position: {
							my: 'bottom center',
							at: 'top center',
							viewport: $(window)
						}
					}));
				}
				if($ttip_l.length) {
					$ttip_l.qtip( $.extend({}, shared, {
						position: {
							my: 'right center',
							at: 'left center',
							viewport: $(window)
						}
					}));
				}
				if($ttip_r.length) {
					$ttip_r.qtip( $.extend({}, shared, {
						position: {
							my		: 'left center',
							at		: 'right center',
							viewport: $(window)
						}
					}));
				}
				// bootstrap tooltips
				var $bs_ttip = $('.bs_ttip');
				if($bs_ttip.length) {
					$bs_ttip.tooltip();
				}
			}
		}
	};

    //* popovers
    gebo_popOver = {
        init: function() {
            $(".pop_over").popover();
        }
    };

	//* external links
	gebo_external_links = {
		init: function() {
			$("a[href^='http']").not('.thumbnail>a,.ext_disabled,.btn').each(function() {
				$(this).attr('target','_blank').addClass('external_link');
			})
		}
	};

	//* accordion icons
	gebo_acc_icons = {
		init: function() {
			var accordions = $('#accordion1,#accordion2');

			accordions.find('.accordion-group').each(function(){
				var acc_active = $(this).find('.accordion-body').filter('.in');
				acc_active.prev('.accordion-heading').find('.accordion-toggle').addClass('acc-in');
			});
			accordions.on('show', function(option) {
				$(this).find('.accordion-toggle').removeClass('acc-in');
				$(option.target).prev('.accordion-heading').find('.accordion-toggle').addClass('acc-in');
			});
			accordions.on('hide', function(option) {
				$(option.target).prev('.accordion-heading').find('.accordion-toggle').removeClass('acc-in');
			});
		}
	};

	//* main menu mouseover
	gebo_nav_mouseover = {
		init: function() {
			$('header li.dropdown').mouseenter(function() {
				if($('body').hasClass('menu_hover')) {
					$(this).addClass('navHover')
				}
			}).mouseleave(function() {
				if($('body').hasClass('menu_hover')) {
					$(this).removeClass('navHover open')
				}
			});
            $('header li.dropdown > a').click(function(){
                if($('body').hasClass('menu_hover')) {
                    window.location = $(this).attr('href');
                }
            });
		}
	};

	//* single image colorbox
	gebo_colorbox_single = {
		init: function() {
			$('.cbox_single').colorbox({
				maxWidth	: '80%',
				maxHeight	: '80%',
				opacity		: '0.2',
				fixed		: true
			});
		}
	};

	//* submenu
	gebo_submenu = {
		init: function() {
			$('.dropdown-menu li').each(function(){
				var $this = $(this);
				if($this.children('ul').length) {
					$this.addClass('sub-dropdown');
					$this.children('ul').addClass('sub-menu');
				}
			});

			$('.sub-dropdown').on('mouseenter',function(){
				$(this).addClass('active').children('ul').addClass('sub-open');
			}).on('mouseleave', function() {
				$(this).removeClass('active').children('ul').removeClass('sub-open');
			})

		}
	};

	//* style switcher
	gebo_style_sw = {
		init: function() {
			if($('.style_switcher').length) {
				var $body = $('body');

				$body.append('<a class="ssw_trigger" href="javascript:void(0)"><i class="glyphicon glyphicon-cog"></i></a>');
				var defLink = $('#link_theme').clone();

				$('input[name=ssw_sidebar]:first,input[name=ssw_layout]:first,input[name=ssw_menu]:first').attr('checked', true);

				$(".ssw_trigger").click(function(){
					$(".style_switcher").toggle("fast");
					$(this).toggleClass("active");
					return false;
				});

				// colors
				$('.style_switcher .jQclr').click(function() {
					$(this).closest('div').find('.style_item').removeClass('style_active');
					$(this).addClass('style_active');
					var style_selected = $(this).attr('title');
					$('#link_theme').attr('href','css/'+style_selected+'.css');
				});

				// backgrounds
				$('.style_switcher .jQptrn').click(function(){
					$(this).closest('div').find('.style_item').removeClass('style_active');
					$(this).addClass('style_active');
					var style_selected = $(this).attr('title');
					if($(this).hasClass('jQptrn')) { $('body').removeClass('ptrn_a ptrn_b ptrn_c ptrn_d ptrn_e').addClass(style_selected); }
				});
				//* layout
				$('input[name=ssw_layout]').click(function(){
					var layout_selected = $(this).val();
					$body.removeClass('gebo-fixed').addClass(layout_selected);
				});
				//* sidebar position
				$('input[name=ssw_sidebar]').click(function(){
					var sidebar_position = $(this).val();
					$body.removeClass('sidebar_right').addClass(sidebar_position);
					$(window).resize();
				});
				//* menu show
				$('input[name=ssw_menu]').click(function(){
					var menu_show = $(this).val();
					$body.removeClass('menu_hover').addClass(menu_show);
				});

				//* reset
				$('#resetDefault').click(function(){
					$('body').attr('class', '');
					$('.style_item').removeClass('style_active').filter(':first-child').addClass('style_active');
					$('#link_theme').replaceWith(defLink);
					$('.ssw_trigger').removeClass('active');
					$(".style_switcher").hide();
					return false;
				});

				$('#showCss').click(function(e){
					var themeLink = $('#link_theme').attr('href'),
						bodyClass = $body.attr('class'),
						contentStyle = '<div style="padding:20px;min-width:500px;background:#fff">';

					if(themeLink != 'css/blue.css') {
						contentStyle += '<div class="sepH_c"><textarea style="height:32px" class="form-control">&lt;link id="link_theme" rel="stylesheet" href="'+themeLink+'"&gt;</textarea><span class="help-block">Find stylesheet with id="link_theme" in document head and replace it with this code.</span></div>';
					}
					if(bodyClass != '') {
						contentStyle += '<textarea style="height:32px" class="form-control">&lt;body class="'+$('body').attr('class')+'"&gt;</textarea><span class="help-block">Replace body tag with this code.</span>';
					} else {
						contentStyle += '<textarea style="height:32px" class="form-control">&lt;body&gt;</textarea>';
					}
					contentStyle += '</div>';
					$.colorbox({
						opacity				: '0.2',
						fixed				: true,
						html				: contentStyle
					});
					e.preventDefault();
				})
			}
		}
	};
