var scrollAnimate = function() {
	var elems;
	var windowHeight;
	function init() {
		elems = document.querySelectorAll('.hidden, .slide-in-element');
		windowHeight = window.innerHeight;
		addEventHandlers();
		checkPosition();
	}
	function addEventHandlers() {
		window.addEventListener('scroll', checkPosition);
		window.addEventListener('resize', init);
	}
	function checkPosition() {
		for (var i = 0; i < elems.length; i++) {
			var positionFromTop = elems[i].getBoundingClientRect().top;
			if (positionFromTop - windowHeight <= 0) {
				elems[i].className = elems[i].className.replace('hidden', 'fade-in-element');
				elems[i].className = elems[i].className.replace('slide-in-element', 'slide-in-execute');
			}
		}
	}
	return {
		init: init
	};
};
