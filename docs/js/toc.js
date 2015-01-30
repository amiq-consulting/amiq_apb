$('[data-toggle=collapse]').click(
		function() {
			$(this).find("span").toggleClass(
					"glyphicon-chevron-right glyphicon-chevron-down");
		});

$('.select2').select2({
	placeholder : ''
});

$('button[data-select2-open]').click(function() {
	$('#' + $(this).data('select2-open')).select2('open');
});

$("#toc-search").on("change", function(e) {
	parent.content.location.href = e.val;
});
