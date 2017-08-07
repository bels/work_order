;(function(){

	$(function(){
		$('.add-customer.btn').click(function(){
			$('.customer-form').removeClass('hidden');
		});
		
		$('.create-customer.btn').click(function(e){
			var $form = $(this).closest('form');
			e.preventDefault();
			var data = $form.serialize();
			console.log($form.attr('method'));
			$.ajax({
				method: $form.attr('method'),
				url: $form.attr('action'),
				data: $form.serialize()
			}).done(function(data){
				$('#customer').append('<option value="' + data.id + '" selected="selected">' + data.name + '</option');
				$('#customerModal').modal('hide');
			});
		});
	});
	
})();