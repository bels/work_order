;(function(){
	$(function(){
		
		window.print();
		
		$('#approve_chk_box').click(function(){
			$('.submit-approval.btn').prop('disabled',false);
		});
	});
})();