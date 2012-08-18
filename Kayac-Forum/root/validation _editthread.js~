/***************************/
//@Author: Adrian "yEnS" Mato Gondelle & Ivan Guardado Castro
//@website: www.yensdesign.com
//@email: yensamg@gmail.com
//@license: Feel free to use it, but keep this credits please!					
/***************************/

$(document).ready(function(){
	//global vars
	var form = $("#editform");
	var title = $("#customForm_text_name");
	var post_content = $("#post_content");
	
	//On Submitting
	form.submit(function(){
		if(validateTitle() & validatePostContent())
			return true
		else
			return false;
	});
	
	//validation functions
	function validateTitle(){
		if(title.val().length > 1){
			return true;
		}
		else {
			return false;
		}
	}
	function validatePostContent(){
		if(post_content.val().length > 1){
			return true;
		}
		else {
			return false;
		}
	}
});
