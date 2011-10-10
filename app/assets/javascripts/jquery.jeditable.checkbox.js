/**********************************************************************
 *	Custom input types for the jquery.jeditable plugin
 * By Richard Davies <Richard__at__richarddavies.us>
 *********************************************************************/

// Create a custom input type for checkboxes
$.editable.addInputType("checkbox", {
	element : function(settings, original) {
		var input = $('<input type="checkbox">');
		$(this).append(input);

		// Update <input>'s value when clicked
		$(input).click(function() {
			var value = $(input).attr("checked") ? 'Yes' : 'No';
			$(input).val(value);
		});
		return(input);
	},
	content : function(string, settings, original) {
		var checked = string == "Yes" ? 1 : 0;
		var input = $(':input:first', this);
		$(input).attr("checked", checked);
		var value = $(input).attr("checked") ? 'Yes' : 'No';
		$(input).val(value);
	}
});