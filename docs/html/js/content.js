/* Scroll to top instantiation */
$(function() {
	$
			.scrollUp({
				scrollDistance : 100,
				scrollSpeed : 400,
				easingType : 'swing',
				animation : 'fade',
				animationSpeed : 200,
				scrollText : '<span class="badge">Top <span class="glyphicon glyphicon-chevron-up"></span></span>',
			});
});

/* Change the chevron for collapsable targets */
var toggleChevronFunction = function() {
	$(this).find("span").toggleClass("glyphicon-chevron-right glyphicon-chevron-down");
};
$('[data-toggle=collapse]').click(toggleChevronFunction);
$('[data-scroll^="#"]').click(
		function() {
			var id = $(this).data('scroll');
			if(! $(id).hasClass('in')) {
				$(id).collapse('show');
				$(id).siblings('[data-toggle=collapse]').each(toggleChevronFunction);
			};

			var position = 0;
			if($(id).hasClass('panel-collapse') && $(id).parent().hasClass('panel')) {
				position = $(id).parent().offset().top;
			} else {
				position = $(id).offset().top;
			}
			$('html, body').animate({scrollTop: position}, 400);
});
