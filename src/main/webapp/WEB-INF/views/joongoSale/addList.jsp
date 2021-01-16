<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ include file="/resources/include/header.jsp" %>

<style>
</style>
<script type="text/javascript">
var dongne1Id;
var dongne1Name = "${dongne1Name}"
$(function(){
	
	var contextPath = "<%=request.getContextPath()%>";

		$.get(contextPath+"/dongne1", function(json){
		var datalength = json.length; 
		if(datalength >= 1){
			var sCont = "";
			for(i=0; i<datalength; i++){
				if (json[i].name == dongne1Name){
					sCont += '<option value="' + json[i].id + '" selected>';
					dongne1Id = json[i].id;
					console.log("test2 : "+ dongne1Id)
				} else {
					sCont += '<option value="' + json[i].id + '">';
				}
				sCont += json[i].name;
				sCont += '</option>';
			}
			$("select[name=dongne1]").append(sCont);
		}
	});
	
	setTimeout(function(){
		console.log("test : "+ dongne1Id)
		if (dongne1Name != ""){
			$.get(contextPath+"/dongne2/"+ dongne1Id, function(json){
				var datalength = json.length; 
				var sCont = "<option>동네를 선택하세요</option>";
				for(i=0; i<datalength; i++){
					if (json[i].name == "${dongne2Name}"){
						sCont += '<option value="' + json[i].id + '" selected>';
					} else {
						sCont += '<option value="' + json[i].id + '">';
					}
					sCont += json[i].name;
					sCont += '</option>';
				}
				$("select[name=dongne2]").append(sCont);	
			});
		}
	}, 50)
	
	$("select[name=dongne1]").change(function(){
		if ($("select[name=dongne1]").val() == "시 선택"){
			window.location = "<c:url value='/joongoSale/addList' />";
		} else {
			var dong1 = $("select[name=dongne1] option:checked").text();
			window.location = "<c:url value='/joongoSale/addList/"+ dong1 +"' />";
		}
	});
	
	$("select[name=dongne2]").change(function(){
		if ($("select[name=dongne2]").val() == "동네를 선택하세요"){
			window.location = "<c:url value='/joongoSale/addList/"+ dongne1Name +"' />";
		} else {
			var dong1 = $("select[name=dongne1] option:checked").text();
			var dong2 = $("select[name=dongne2] option:checked").text();
			 window.location = "<c:url value='/joongoSale/addList/"+ dong1 +"/"+ dong2 +"' />";
		}
	});
	
	
	$(".my_location").on("click", function(){
		navigator.geolocation.getCurrentPosition(success, fail)
	    
	    return false;
	})
	
	function success(position) { //성공시
	    var lat=position.coords["latitude"];
	    var lon=position.coords["longitude"];
	    console.log("1 : "+ lat)
	    console.log("1 : "+ lon)
	    
		var test = {lat:lat, lon:lon}
		console.log(test);
	    $.ajax({
			type:"post",
			contentType:"application/json; charset=utf-8",
			url:contextPath+"/gpsToAddress2",
			cache:false,
			dataType: "json",
			data:JSON.stringify(test),
			beforeSend : function(xhr){   /*데이터를 전송하기 전에 헤더에 csrf값을 설정한다*/
				xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
			},
	        success:function(data){
				console.log(data.address);
				if(confirm("검색된 주소로 검색하시겠습니다? - "+ data.address1+" "+ data.address2) == true){
					window.location=contextPath+"/joongoSale/addList/"+ data.address1 +"/"+ data.address2;
				}
			    else{
			        return ;
			    }
	        }, 
	        error: function(){
				alert("에러");
			}
		})
		console.log(contextPath+"/gpsToAddress2")
	}
	
	 function fail(err){
	    switch (err.code){
	        case err.PERMISSION_DENIED:
	        	alert("사용자 거부");
	        break;
	 
	        case err.PERMISSION_UNAVAILABLE:
	        	alert("지리정보를 얻을 수 없음");
	        break;
	 
	        case err.TIMEOUT:
	        	alert("시간초과");
	        break;
	 
	        case err.UNKNOWN_ERROR:
	        	alert("알 수 없는 오류 발생");
	        break;
	    }
	 }
	 
	 
	 $("input:radio[name=dogCate]").change(function(){
		 //라디오버튼 강아지 눌렀을때 
		 
	 });

	 
	 $('#insertList').on("click", function(json){
		var price = $('#price').val();
		 var num = /^[0-9]*$/;
		 
		 if($('#title').val() == ""){
			 alert('제목을 입력해주세요.');
			 return; 
		 }else if($('#content').val() == ""){
			 alert('내용을 입력해주세요.');
			 return;
		 }else if(num.test(price) == false){
			 alert('가격은 숫자만 입력 가능합니다.');
			 return;
		 }else if($(':input[name=dogCate]:radio:checked').length < 1){
			 alert('강아지카테고리 여부를 선택해주세요.');
			 return;
		 }else if($(':input[name=catCate]:radio:checked').length < 1){
			 alert('고양이카테고리 여부를 선택해주세요.');
			 return;
		 } 

		//파일 선택 여부 - 유효성 검사(DOM에있는 파일이 비어있는게 있는지 확인)
			var inputs = fileArea.getElementsByTagName('input');
			for(var i=0;i<input.lenght; i++){
				if(inputs[i].value == ""){
					alert('파일을 선택하세요!');
					inputs[i].focust();
					return;
				}
			}
		 
		 var newlist = {
			member : {
				id : $('#memId').val()
			},
			dogCate : $(':input[name=dogCate]:radio:checked').val(),
			catCate : $(':input[name=catCate]:radio:checked').val(),
			title : $('#title').val(),
			content : $('#content').val(),
			price : $('#price').val(),			
		 	dongne1: {
		 		dong1Id : $('#dongne1').val()
		 	},
		 	dongne2: {
		 		dong2Id : $('#dongne2').val()
		 	}
		 };
		 	alert(JSON.stringify(newlist));
		 	
		 	
		 	
			$.ajax({
				url: contextPath + "/insert",
				type: "POST",
				contentType:"application/json; charset=UTF-8",
				dataType: "json",
				cache : false,
				data : JSON.stringify(newlist),
				beforeSend : function(xhr)
	            {   /*데이터를 전송하기 전에 헤더에 csrf값을 설정한다*/
	                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	            },
				success: function() {
					alert('완료되었습니다.');
					window.location.replace(contextPath+"/joongo_list");
				},
				error: function(request,status,error){
					alert("동네를 먼저선택해주세요!");
					alert('에러!!!!' + request.status+request.responseText+error);
				}
			});
			console.log(contextPath+"/insert");	
	 
	});
	 
		//자바스크립트에서 DOM을 가져오기(문서객체모델 가져오기) -> 한번 다 읽고나서 
		var form = document.forms[0]; //젤 첫번째 form을 dom으로 받겠다.
		
		var addFileBtn = document.getElementById("addFileBtn");
		var delFileBtn = document.getElementById("delFileBtn");
		var fileArea = document.getElementById("fileArea");
		var cnt = 1;
		
		
		//업로드input 미리만들지 않고 필요한 만큼 증가
		$("#addFileBtn").on("click", function() {
			if (cnt < 10) {
				cnt++;
				var element = document.createElement("input");
				element.type = "file";
				element.name = "upfile" + cnt;
				element.id = "upfile" + cnt;
				var element2 = document.createElement("img");
				element2.id = "productImg"+cnt;
				var element3 = document.createElement('div');
				element3.setAttribute("id", "preview"+cnt);

				fileArea.appendChild(element);
				fileArea.appendChild(element2);
				fileArea.appendChild(element3);
				fileArea.appendChild(document.createElement("br"));
				
			} else {
				alert("파일은 10개까지 추가 가능합니다.");
			}
 
		});
		
		$("#delFileBtn").on("click", function() {
			if (cnt > 1) {
				cnt--;
				var inputs = fileArea.getElementsByTagName('input');
				var imgs = fileArea.getElementsByTagName('img');
				var divs = fileArea.getElementsByTagName('div');
				var brArr = fileArea.getElementsByTagName('br');
				fileArea.removeChild(brArr[brArr.length-1]);
				fileArea.removeChild(imgs[imgs.length-1]);
				fileArea.removeChild(divs[divs.length-1]);
				fileArea.removeChild(inputs[inputs.length-1]);
			} else {
				alert("상품 사진 최소 1개는 업로드 필요합니다.");
			}

		});

		
});


 function imageChange(){
	 var inputs = fileArea.getElementsByTagName('input');
	 for(num=1; num< inputs.length-1 ; num++){
	 
	var file = document.getElementById("upfile"+num).files[0];
	 	console.log(file);
	 }
	
	/* if (file) {
	//console.log(document.getElementById("uploadFile").files[0])
	 var reader = new FileReader(); //파일을 읽기 위한 FileReader객체 생성
    reader.onload = function (e) {
    //파일 읽어들이기를 성공했을때 호출되는 이벤트 핸들러
        $('#productImg').attr('src', e.target.result);
        //이미지 Tag의 SRC속성에 읽어들인 File내용을 지정
        //(아래 코드에서 읽어들인 dataURL형식)
    }                   
    reader.readAsDataURL(document.getElementById("uploadFile").files[0]);
    //File내용을 읽어 dataURL형식의 문자열로 저장 */
    
	}
	



</script>
<article>
<form action="/insert" method="POST">
<div>
<table border="1">
	<colgroup>
		<col width="20%">
		<col width="80%">
	</colgroup>
	<tr>
		<td>아이디</td>
		<td><input type="text" id="memId" value="${loginUser.getId()}" readonly="readonly"></td>
	</tr>
	<tr>
		<td>동네</td>
		<td>
			<div id="add_location" class="s-inner">
				<div class="list_top">
					<button class="my_location">내 위치</button>
				<div>
				<select name="dongne1" id="dongne1">
					<option>시 선택</option>
				</select> 
				<select name="dongne2" id="dongne2">
				</select>
				</div>
				</div>
			</div>
			
		</td>
	</tr>
	
	<tr>
		<td>사진 추가 / 제거 <br>
			<input type="button" value="파일추가" id="addFileBtn">
			<input type="button" value="파일제거" id="delFileBtn">
		</td>
		<td>
			<div id="fileArea">
				<input type="file" id="upfile1" name="upfile1" onchange="imageChange()">
				<img id="productImg1">
				<div id="preview1"></div>
			</div>
		</td>
	</tr>
	<tr>
	<tr>	
		<td>강아지 카테고리 인가요 ? </td>
		<td>
			<input type="radio" name="dogCate" id="dogCateY" value="y">네! 맞아요!
			<input type="radio" name="dogCate" id="dogCateN" value="n">아니에요!
		</td>
	</tr>
	<tr>	
		<td>고양이 카테고리 인가요 ? </td>
		<td>
			<input type="radio" name="catCate" id="catCateY" value="y">네! 맞아요!
			<input type="radio" name="catCate" id="catCateN" value="n">아니에요!
		</td>
	</tr>
	<tr>
		<td>제목(상품명)</td>
		<td><input type="text" name="title" id="title"></td>
	</tr>
	<tr>
		<td>가격</td>
		<td><input type="text" name="price" id="price"></td>
	<tr>
	<tr>
		<td>내용</td>
		<td><textarea class="content" name="content" id="content"></textarea>>
	</tr>
	
<!-- 	<tr>
		<td></td>
		<td>
			<select>
				<option>판매상태</option>
				<option>판매중</option>		
			</select>
			
		</td>
	</tr>
 -->	
 	<tr>
	<td colspan="2">
			<input type="button" id="insertList" value="글 등록하기">
		</td>
	</tr>
</table>
</div>
</form>
</article>
<jsp:include page="/resources/include/footer.jsp"/>