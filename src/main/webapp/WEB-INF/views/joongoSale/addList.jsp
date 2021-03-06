<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ include file="/WEB-INF/views/include/header.jsp" %>

<style>
td, th {
	word-break: keep-all;
}

table {
 border-collapse: separate;
  border-spacing: 0 10px;
  height: auto;
}

textarea {
	width: 100%;
	height: 200px;
}

#preview1 > a > img {
	width: 160px;
	height: 160px;
}

#thumFileArea > img {
	width: 160px;
	height: 160px;
}


</style>
<script type="text/javascript">
$(function(){
	var contextPath = "<%=request.getContextPath()%>";
		var dong = document.getElementById("dongName").value
		var nae = document.getElementById("naeName").value
        //	$('#dongne1').val(dong).prop("selected",true);
       // 	$('#dongne2').val(nae).prop("selected",true);
       
       
	$.get(contextPath+"/dongne1", function(json){
		console.log(json)
		var datalength = json.length; 
		if(datalength >= 1){
			var sCont = "";
			for(i=0; i<datalength; i++){
				sCont += '<option value="' + json[i].id + '">' + json[i].name + '</option>';
			}
			$("select[name='dongne1.id']").append(sCont);
		}
	});
	
		
 		$('#dongne1').val(dong).attr("selected","selected");
		setTimeout(function(){
		      if (dong != ""){
		         $.get(contextPath+"/dongne2/"+ dong, function(json){
		            var datalength = json.length; 
		            var sCont = "";
		            for(i=0; i<datalength; i++){
		               if (json[i].name == $('#dong2Name').val()){
		                  sCont += '<option value="' + json[i].id + '" selected>';
		                  $('#dongne1').val(dong).attr("selected","selected");
		               } else {
		                  sCont += '<option value="' + json[i].id + '">';
		               }
		               sCont += json[i].name;
		               sCont += '</option>';
		            }
		            $("select[name='dongne2.id']").append(sCont);
		            $("select[name='dongne2.id']").val(nae).attr("selected", "selected");
		         });
		      }
		   }, 50); 

	$("select[name='dongne1.id']").change(function(){
		$("select[name='dongne2.id']").find('option').remove();
			var dong1 = $("select[name='dongne1.id']").val();
		$.get(contextPath+"/dongne2/"+dong1, function(json){
			var datalength = json.length; 
			var sCont = "";
			for(i=0; i<datalength; i++){
				sCont += '<option value="' + json[i].id + '">' + json[i].name + '</option>';
			}
			$("select[name='dongne2.id']").append(sCont);	
		});
	});
	
	/* 
		//라디오 버튼으로 카테고리 
		$("input:radio[name=category]").change(function(){
			if($("input:radio[name=category]:checked").val() == '1'){
				//alert("강아지 선택");
				$('#catCate').attr('value','n');
			}else if($("input:radio[name=category]:checked").val() == '2'){
				//alert("고양이 선택");
				$('#catCate').attr('value','y');
				$('#dogCate').attr('value','n');
			}else{
				//alert("모두 선택");
			}
	}); */
	
	
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
	         url:contextPath+"/gpsToAddress",
	         cache:false,
	         dataType: "json",
	         data:JSON.stringify(test),
	         beforeSend : function(xhr){   /*데이터를 전송하기 전에 헤더에 csrf값을 설정한다*/
	            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	         },
	           success:function(data){
	            console.log(data);
	            if(confirm("검색된 주소로 검색하시겠습니다? - "+ data.address1+" "+ data.address2) == true){
	            	var buttonDong = $('#dongne1 option:contains('+ data.address1 +')').val();
				       $('#dongne1').val(buttonDong).attr("selected","selected");
						setTimeout(function(){
				         $.get(contextPath+"/dongne2/"+ buttonDong, function(json){
				            var datalength = json.length; 
				            var sCont = "";
				            for(i=0; i<datalength; i++){
				               if (json[i].name == data.address2){
				                  sCont += '<option value="' + json[i].id + '" selected>';
				                  $('#dongne1').val(buttonDong).attr("selected","selected");
				               } else {
				                  sCont += '<option value="' + json[i].id + '">';
				               }
				               sCont += json[i].name;
				               sCont += '</option>';
				            }
				            $("select[name='dongne2.id']").append(sCont);
				            var buttonNae =  $('#dongne2 option:contains('+ data.address2 +')').val();
				            $("select[name='dongne2.id']").val(buttonNae).attr("selected", "selected");
				         });
				   }, 50); 
	            }
	             else{
	                 return ;
	             }
	           }, 
	           error: function(){
	            alert("에러");
	         }
	      })
	      console.log(contextPath+"/gpsToAddress")
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
	
	 
	 $('#checkFree').change(function(e){
		 console.log(this);
		 console.log(e);
	        if(this.checked){
	            $('#priceDiv').fadeOut('fast');
	        	$('#price').prop('value', 0);
	        }else{
	            $('#priceDiv').fadeIn('fast');
	        }
	    });
	 
	 $('#insertList').on("click", function(e){
		
		var price = $('#price').val();	
		 var num = /^[0-9]*$/;
		 
		 if($('#title').val() == ""){
			 alert('제목을 입력해주세요.');
			 return false; 
		 }else if($('#content').val() == ""){
			 alert('내용을 입력해주세요.');
			 return false; 
		 }else if(num.test(price) == false){
			 alert('가격은 숫자만 입력 가능합니다.');
			 return false; 
		 }else if($('#price').val() == ""){
			 alert('가격을 입력해주세요.');
			 return false; 
		 }else if($('#dongne1').val() == "0"){
			alert('지역을 선택하세요.');
			return false; 
		}else if($('#dongne2').val() == "0"){
			alert('동네를 선택하세요.');
			return false; 
		}else if($('#thumImgInput').val() == ""){
			alert("대표사진 업로드는 필수입니다.");
			return false;
		}
		 
	 });
	 
		$('#imgInput').on("change", handleImgs);	

});

function handleImgs(e) {
	var files = e.target.files;
	var filesArr = Array.prototype.slice.call(files);
	var sel_files = [];
	
	filesArr.forEach(function(f) {
		if(!f.type.match("image.*")){
			alert("확장자는 이미지 확장자만 가능합니다.");
			return;
		}
		sel_files.push(f);
		var reader = new FileReader();
		reader.onload = function(e){
			var img_html = "<a href='#this' name='delete' class='btn'> <img src=\"" + e.target.result + "\" /></a>";
			$('#preview1').append(img_html);
			
			$("a[name='delete']").on("click",function(e){
				$(this).remove();
			})
		}
		reader.readAsDataURL(f);
	});
	
}


function handleThumImgs(){
	var file = document.getElementById("thumImgInput").files[0]
	if(file){
		console.log(document.getElementById("thumImgInput").files[0])
		 var reader = new FileReader(); //파일을 읽기 위한 FileReader객체 생성
	    reader.onload = function (e) {
	    //파일 읽어들이기를 성공했을때 호출되는 이벤트 핸들러
	        $('#productImg1').attr('src', e.target.result);
	        //이미지 Tag의 SRC속성에 읽어들인 File내용을 지정
	        //(아래 코드에서 읽어들인 dataURL형식)
	    }                   
	    reader.readAsDataURL(document.getElementById("thumImgInput").files[0]);
	    //File내용을 읽어 dataURL형식의 문자열로 저장
		}	
}


</script>
<div id="subContent">
	<h2 id="subTitle">글쓰기</h2> 	
	<div id="pageCont" class="s-inner">
		<article>
<form id="boardForm" name="boardForm" action="<%=request.getContextPath() %>/joongoSale/insert" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		<table style="width: 800px; table-layout: fixed;">
			<tr>
				<td width="300px;">아이디</td>
				<td width="500px;">
					<input type="text" id="memId" value="${loginUser.getId()}" readonly="readonly" style="border: none;">
					<input type="text" id="dongName" style="display: none;" value="${loginUser.getDongne1().getId()}">
					<input type="text" id="naeName" style="display: none;" value="${loginUser.getDongne2().getId()}">
					<input type="text" id="dong2Name" style="display: none;" value="${loginUser.getDongne2().getName()}">
				</td>
					
			</tr>
			<tr>
				<td>동네</td>
				<td>
					<div id="add_location" class="s-inner">
						<select name="dongne1.id" id="dongne1">
							<option value="0">지역을 선택하세요</option>
						</select> 
						<select name="dongne2.id" id="dongne2">
							<option value="0">동네를 선택하세요</option>
						</select>
						<div class="list_location">
							<button class="my_location">내 위치</button>
						<div>
						</div>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>대표 사진<br>*대표사진은 1장만 추가 가능</td>
				<td>
					<div id="thumFileArea">
						<input type="file" name="thum" id="thumImgInput" accept="image/*" onchange="handleThumImgs()"/>
						<img id="productImg1">
						<div id="preview"></div>
					</div>
				</td>
			</tr>
			<tr>
				<td>사진<br>*사진 클릭시 업로드 취소 가능</td>
				<td>
					<div id="fileArea">
						<input multiple="multiple" type="file" name="file" id="imgInput" accept="image/*"/>
						<img id="productImg1">
						<div id="preview1"></div>
					</div>
				</td>
			</tr>
			<tr>
			<tr>	
				<td>카테고리</td>
				<td>
				<!-- 	<select name="dogCate" id="dogCate" >
						<option value="">카테고리를 선택하세요.</option>
						<option value="y">강아지 카테고리</option>
						<option value="n">고양이 카테고리 </option>
						<option value="y"> 모두 포함 </option>
					</select> -->
					<input type="radio" name="category" id="category" value="1" checked="checked">강아지 카테고리
					<input type="radio" name="category" id="category" value="2" style="margin-left: 15px;">고양이 카테고리
					<input type="radio" name="category" id="category" value="3" style="margin-left: 15px;">모두 포함
					<!-- <input type="hidden" name="catCate" value="y" id="catCate">
					<input type="hidden" name="dogCate" value="y" id="dogCate"> -->
				</td>
			</tr>
			<tr>
				<td>제목(상품명)</td>
				<td><input type="text" name="title" id="title" style="width: 100%"></td>
			</tr>
			<tr>
				<td>가격</td>
				<td>
					<div id="priceDiv"><input type="text" name="price" id="price"></div>
					<input type="checkbox" id="checkFree" value="0">무료나눔하기
				</td>
			<tr>
			<tr>
				<td>내용</td>
				<td><textarea class="content" name="content" id="content"></textarea>
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
					<input type="submit" id="insertList" value="글 등록하기">
				</td>
			</tr>
		</table>
		</form>
		</article>
	
	</div>
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>