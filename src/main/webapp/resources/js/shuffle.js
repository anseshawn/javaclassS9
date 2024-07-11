;(function ($) {

	'use strict';
	
 	// Shuffle js filter and masonry
  var Shuffle = window.Shuffle;
  var jQuery = window.jQuery;

  var myShuffle = new Shuffle(document.querySelector('.shuffle-wrapper'), {
      itemSelector: '.shuffle-item',
      buffer: 1
  });

  jQuery('input[name="shuffle-filter"]').on('change', function (evt) {
      var input = evt.currentTarget;
      if (input.checked) {
          myShuffle.filter(input.value);
      }
  });
 /*
	// Shuffle js filter and masonry
	import Shuffle from 'shufflejs'; // Shuffle을 import로 가져옴
	import $ from 'jquery'; // jQuery import
	
	$(document).ready(function() {
	  var $shuffleWrapper = $('.shuffle-wrapper');
	  var $shuffleItems = $shuffleWrapper.find('.shuffle-item');
	
	  // 페이지에 .shuffle-wrapper 요소가 있는지 확인
	  if ($shuffleWrapper.length > 0) {
	    var myShuffle = new Shuffle($shuffleWrapper[0], {
	      itemSelector: '.shuffle-item',
	      buffer: 1
	    });
	
	    $('input[name="shuffle-filter"]').on('change', function(evt) {
	      var input = evt.currentTarget;
	      if (input.checked) {
	        myShuffle.filter(input.value);
	      }
	    });
	  }
	});
 */

})(jQuery);
