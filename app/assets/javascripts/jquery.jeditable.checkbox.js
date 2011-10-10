/**********************************************************************
 *	Custom input types for the jquery.jeditable plugin
 * By Richard Davies <Richard__at__richarddavies.us>, 2009
 * By Peter Savichev (proton) <psavichev@gmail.com>, 2011
 *********************************************************************/

// Create a custom input type for checkboxes
$.editable.addInputType("checkbox", {
	element : function(settings, original) {
		var input = $('<input type="checkbox">');
		$(this).append(input);

		$(input).change(function() {
			var value = $(input).attr("checked") ? 1 : 0;
			$(input).val(value);
		});
		return(input);
	},
	content : function(string, settings, original) {
		var checked = (string == "true") ? 1 : 0;
		var input = $(':input:first', this);
		if(checked) $(input).attr("checked", "checked");
		else $(input).removeAttr("checked");
		$(input).val(checked);
	}
});