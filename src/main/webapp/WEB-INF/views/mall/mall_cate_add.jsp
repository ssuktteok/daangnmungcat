<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="/resources/include/header.jsp" %>

<script>
$(function(){
	var contextPath = "<%=request.getContextPath()%>";
	
	$("#cate_write_btn").click(function(){
		if ($("input[name='name']").val() == ""){
			alert("분류명을 입력해주세요.")
			$("input[name='name']").focus();
			return false;
		}
		
		var cateData = {
			cateName : $("select[name='cate_name']").val(),
			name : $("input[name='name']").val()
		}
		
		$.ajax({
			url:contextPath+"/mall/cate/write",
			type:"post",
			contentType:"application/json; charset=utf-8",
			cache:false,
			dataType: "json",
			data:JSON.stringify(cateData),
			beforeSend : function(xhr){   /*데이터를 전송하기 전에 헤더에 csrf값을 설정한다*/
				xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			},
			success:function(){
				alert("추가됐습니다.")
				window.history.back();
	        }, 
	        error: function(request,status,error){
	        	alert('에러' + request.status+request.responseText+error);
			}
		})
	})
})
</script>


<div id="subContent">
	<h2 id="subTitle">쇼핑몰 카테고리 추가</h2>
	<div id="pageCont" class="s-inner">
		<div class="mall_cate_write">
			<select name="cate_name">
				<option value="멍">멍</option>
				<option value="냥">냥</option>
			</select>
			<input type="text" name="name">
			<input type="submit" id="cate_write_btn" value="확인">
		</div>
	</div>
</div>

<jsp:include page="/resources/include/footer.jsp"/>