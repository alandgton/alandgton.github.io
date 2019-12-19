$(function(){
	"use strict";
	
	var sect = $( window.location.hash ),
		portfolio = $('.portfolio-items');
	
	if(sect.length == 1){
		$('.section.active').removeClass('active');
		sect.addClass('active');
		if( sect.hasClass('border-d') ){
			$('body').addClass('border-dark');
		}
	}
	
	/*=========================================================================
		Magnific Popup (Project Popup initialization)
	=========================================================================*/
	$('.view-project').magnificPopup({
		type: 'inline',
		fixedContentPos: false,
		fixedBgPos: true,
		overflowY: 'auto',
		closeBtnInside: true,
		preloader: false,
		midClick: true,
		removalDelay: 300,
		mainClass: 'my-mfp-zoom-in'
	});
	
	$(window).on('load', function(){
		$('body').addClass('loaded');
		
		/*=========================================================================
			Portfolio Grid
		=========================================================================*/
		portfolio.shuffle();
		$('.portfolio-filters > li > a').on('click', function (e) {
			e.preventDefault();
			var groupName = $(this).attr('data-group');
			$('.portfolio-filters > li > a').removeClass('active');
			$(this).addClass('active');
			portfolio.shuffle('shuffle', groupName );
		});
		
	});
	
	/*=========================================================================
		Navigation Functions
	=========================================================================*/
	$('.section-toggle').on('click', function(){
		var $this = $(this),
			sect = $( '#' + $this.data('section') ),
			current_sect = $('.section.active');
		if(sect.length == 1){
			if( sect.hasClass('active') == false && $('body').hasClass('section-switching') == false ){
				$('body').addClass('section-switching');
				if( sect.index() < current_sect.index() ){
					$('body').addClass('up');
				}else{
					$('body').addClass('down');
				}
				setTimeout(function(){
					$('body').removeClass('section-switching up down');			
				}, 1000);
				setTimeout(function(){
					current_sect.removeClass('active');
					sect.addClass('active');
				}, 500);
				if( sect.hasClass('border-d') ){
					$('body').addClass('border-dark');
				}else{
					$('body').removeClass('border-dark');
				}
			}
		}
	});
	
	
	/*=========================================================================
		Party Time
	=========================================================================*/
	$('.party-btn').on('click', function() {
		if ($('.section-main').hasClass('party-class')) {
			$('.section-main').removeClass('party-class');
		} else {
			$('.section-main').addClass('party-class');
		}
	});
	
	/*=========================================================================
		Accordion
	=========================================================================*/
	$(document).ready(function() {
	  $(".set > a").on("click", function() {
	    if ($(this).hasClass("active")) {
	      $(this).removeClass("active");
	      $(this)
	        .siblings(".accordion-content")
	        .slideUp(200);
	      $(".set > a i")
	        .removeClass("")
	        .addClass("");
	    } else {
	      $(".set > a i")
	        .removeClass("")
	        .addClass("");
	      $(this)
	        .find("i")
	        .removeClass("")
	        .addClass("");
	      $(".set > a").removeClass("active");
	      $(this).addClass("active");
	      $(".content").slideUp(200);
	      $(this)
	        .siblings(".accordion-content")
	        .slideDown(200);
	    }
	  });
	});

});
