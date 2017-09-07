;(function(){

	$(function(){
		
		$('.table').DataTable();
		
		$('#new-phone').click(function(){
			$('.phone-container').append($('#phone-number-template').html());
		});
		
	});
	
})();