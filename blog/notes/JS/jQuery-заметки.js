//Убрать из GET запроса пустые параметры
$(document).ready(function() {
	$("#userForm").submit(function() {
		if($("#phoneNum").val()=="") {
				$("#phoneNum").remove();
		}
	});
 });
//Этот способ лучше 
$('#search-form').submit(function(){
            var serializedData = $(this).serializeArray();
            var query_str = '';
            $.each(serializedData, function(i,data){
                if($.trim(data['value'])){
                    query_str += (query_str == '') ? '?' + data['name'] + '=' + data['value'] : '&' + data['name'] + '=' + data['value'];
                }
            });
            if (jQuery.isEmptyObject(query_str)) {
                return false;
            } else {
                //console.log(query_str);
                window.location.href = '/post/index' + query_str;
                return false;
            }
        }); 

//slides
$('.slides_pagination li a').click(function(){
    var href = $(this).attr('href');
    var src = $('img', $(this)).attr('src');
    var container = $('.slides_container a');
    container.attr('href', href);
    container.find('img').attr('src', src);
    return false;
});