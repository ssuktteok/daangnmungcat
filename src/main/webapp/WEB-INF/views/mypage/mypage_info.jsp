<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<style>
.wrapper {margin:0 auto; padding:70px; text-align:center; margin-bottom:150px;}

</style>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
$(document).ready(function(){
	var contextPath = "<%=request.getContextPath()%>";
	var number;
	var email_status;
	var member_email;
	var dongne1Id;
	var dongne2Id;
	
	
	
	$('#pwd_table').hide();
	
	$.get(contextPath+"/dongne1", function(json){
		var datalength = json.length; 
		if(datalength >= 1){
			var sCont = "";
			for(i=0; i<datalength; i++){
				sCont += '<option value="' + json[i].id + '">' + json[i].name + '</option>';
			}
			$("select[name=dongne1]").append(sCont);
		}
	});
	
	console.log('인증상태:' + $('#certi').val());

 	$.get(contextPath +"/member/pic", function(json){
		$('#myPic').prop('src', contextPath +  "/resources/" + json.path);
	});
	
	$.get(contextPath +"/member/info", function(member){
		$('#profile_text').text(member.member.profileText);
		$('#profile_nick').text(member.member.nickname);
		
		$('#id').attr('value', member.member.id);
		$('#name').attr('value', member.member.name);
		$('#nickname').attr('value', member.member.nickname);
		$('#email').attr('value', member.member.email);
		$('#phone').attr('value', member.member.phone);
		$('#birth').attr('value', member.member.birthday);
		$('#zipcode').attr('value', member.member.zipcode);
		$('#addr1').attr('value', member.member.address1);
		$('#addr2').attr('value', member.member.address2);

		pwd = member.member.pwd
		number = member.member.phone;
		member_email = member.member.email;
		dongne1Id = member.member.dongne1.id;
		dongne2Id = member.member.dongne2.id;

		$('select[name=dongne1]').val(member.member.dongne1.id).attr("selected", "selected");
		var dongne1Name = member.member.dongne2.name;
		
		setTimeout(function(){
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
		            $('select[name=dongne2]').val(member.member.dongne2.id).attr("selected", "selected");
		         });
		      }
		   }, 50);
		
		
		
	});
	
	
	$("select[name=dongne1]").change(function(){
		$("select[name=dongne2]").find('option').remove();
		var dong1 = $("select[name=dongne1]").val();
		$.get(contextPath+"/dongne2/"+dong1, function(json){
			var datalength = json.length; 
			var sCont = "";
			for(i=0; i<datalength; i++){
				sCont += '<option value="' + json[i].id + '">' + json[i].name + '</option>';
			}
			$("select[name=dongne2]").append(sCont);	
		});
	});
	
	//프로필이미지 수정
	$('#img_upload').on("click", function(){
        
        if(!$("input[name='uploadFile']").val()){
        	alert('선택된 파일이 없습니다.');
        	
        }else{
        	
        	var formData = new FormData();
            var file = $("input[name='uploadFile']")[0].files;
            
            console.log('file >> ' + file);       
            for(var pair of formData.entries()) {
                  console.log(pair[0]+ ', '+ pair[1]); 
            }
            
            for(var i=0; i<file.length; i++){
               console.log(file[i]);
               formData.append('uploadFile', file[i]);
            }
            
            
        	if (confirm("프로필 사진을 변경하시겠습니까?") == true){
            	$.ajax({
            		url: contextPath + "/profile/post",
            		type: "post",
            		enctype: 'multipart/form-data',
            		data: formData,
            		processData: false,
            		contentType: false, //multipart-form-data로 전송
            		cache: false,
            		success: function(res) {
            			if(res == 1){
            				alert('프로필 사진이 변경되었습니다.')
            			}
            		},
            		error: function(request,status,error){
            			alert('에러' + request.status+request.responseText+error);
            		}
            	});
            }	
        }
    	
    });
	
	//프로필 사진 삭제 -> default로
	$('#img_delete').on("click", function(){
		if (confirm("프로필 사진을 삭제하시겠습니까?") == true){
			$.get(contextPath +"/profile/get", function(res){
				if(res == 1){
					location.reload(true);
				}
			});
		}else{ 
		    return;
		}
	});
	
	//프로필소개 업데이트
	$('#p_text_update').on("click", function(){
		var text = $('#p_text').val();
		console.log(text);
		if (confirm("프로필 소개를 변경하시겠습니까?") == true){
			$.ajax({
				url: contextPath + "/profile-text/post",
				type: "POST",
				contentType:"application/json; charset=utf-8",
				dataType: "json",
				cache : false,
				data : JSON.stringify(text),
				success: function(res) {
					if(res == 1){
						alert('프로필 소개가 변경되었습니다');
						location.reload(true);
					}
				},
				error: function(request,status,error){
					alert('에러' + request.status+request.responseText+error);
				}
			});
		}else{
			return;
		}
	});
	
	
	
	//정보수정
	$('#update_info').on("click", function(){
		var email = $('#email').val();
		var emailReg = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
		
		if($('#name').val() == ""){
			alert('이름을 입력하세요.');
			return;
		}else if($('#nickname').val() == ""){
			alert('닉네임을 입력하세요.');
			return;
		}else if($('#email').val() == ""){
			alert('이메일을 입력하세요.');
			return;
		}else if(emailReg.test(email) == false){
			alert('이메일 형식이 맞지 않습니다.');
			return;
		}else if(email_status == 0){
			alert('이미 사용중인 이메일입니다');
			return;
		}else if($('#certi').val() == 0){
			alert('본인인증을 완료해주세요.');
			return;
		}else if($('#dongne1').val() == "0"){
			alert('지역을 선택하세요.');
			return;
		}else if($('#dongne2').val() == "0"){
			alert('동네를 선택하세요.');
			return;
		}
		
		var member = {
				id: $('#id').val(),
				name:$('#name').val(),
				nickname:$('#nickname').val(),
				email:$('#email').val(),
				phone:$('#phone').val(),
				birthday: $('#birth').val(),
				dongne1:{id: $("select[name=dongne1]").val()},
				dongne2:{id: $("select[name=dongne2]").val()},
				zipcode: $('#zipcode').val(),
				address1: $('#addr1').val(),
				address2: $('#addr2').val()
		}
		
		
		$.ajax({
			url: contextPath + "/member/info/post",
			type: "POST",
			contentType:"application/json; charset=utf-8",
			dataType: "json",
			cache : false,
			data : JSON.stringify(member),
			success: function() {
				alert('회원정보가 변경되었습니다.');
				location.reload();
			},
			error: function(request,status,error){
				alert('에러' + request.status+request.responseText+error);
			}
		});
	});
	
	$('#email').keyup(function(){
		var contextPath = "<%=request.getContextPath()%>";
		var save;
		var email = $('#email').val();
		var reg = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
		
		if(reg.test(email) == false){
			$('font[name=email_check]').text('');
		   	$('font[name=email_check]').html("이메일 형식에 맞게 작성해주세요.");
		   	$('input[name=email]').attr("style","border:1px solid red");
		}else {

			$.ajax({
				url: contextPath + "/email/post",
				type: "POST",
				contentType:"application/json; charset=utf-8",
				dataType: "json",
				cache : false,
				data : JSON.stringify(email),
				success: function(res) {
					if(res == 0){
						$('font[name=email_check]').text('사용가능한 이메일입니다.').attr("style","color:black");
						$('input[name=email]').prop("status", "1");
					}else{
						$('font[name=email_check]').text('이미 사용중인 이메일입니다.').attr("style","color:red");
						$('input[name=email]').attr("style","border:1px solid red");
						
						$('input[name=email]').prop("status", "0");
					}
				},
				error: function(request,status,error){
					alert('에러' + request.status+request.responseText+error);
				}
			});
			console.log(email_status);
			
			$('font[name=email_check]').text('');
			$('input[name=email]').attr("style","border:1px solid black");
		}
	});
	
	
	$("#phone").on("propertychange change keyup paste input", function(){
		$(this).val( $(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/,"$1-$2-$3").replace("--", "-") );
		if(number != $('#phone').val()){
			$('#phone_check').prop('type', 'button');
			$('#phone_check').attr('value', '휴대폰인증');
			$("#certi").attr("value", "0");
			console.log('인증버튼떴을때:'+$("#certi").val())
		}else {
			$('#phone_check').prop('type', 'hidden');
		}
	});
	
	$('#phone_check').on("click", function(){
		var number = $('#phone').val();
        var certiNum = $('#certiNum').val();
        console.log('체크클릭했을때 인증상태:'+$("#certi").val())
        
         var regPhone = /(01[0|1|6|9|7])[-](\d{3}|\d{4})[-](\d{4}$)/g;

		if(!regPhone.test(number)){
			alert('휴대폰 번호를 올바르게 입력하세요.')
			$('#phone').focus();
		}else {
	        $.get(contextPath + "/phone/post/" + number, function(res){
	    			alert("인증번호가 발송되었습니다.");
	    			
	    			$("#certiNum").attr("type", "text");
	    			$("#certiSubmit").attr("type", "button");
	    	        
	    	        $.ajax({
	    	        	type:'get',
	    	        	url: contextPath + "/send-sms/" + number ,
	    	       		success: function(json){
	    	       			console.log(json);
	    	       			$('#certiSubmit').click(function(){
	    	       				if(json == $('#certiNum').val()){
	    	       					$("#certiNum").attr("type", "hidden");
	    	       	    			$("#certiSubmit").attr("type", "hidden");
	    	       					$("#certi").attr("value", "1");
											
	    	       					var phone = $('#phone').val();
	    	       					
	    	       					$.ajax({
	    	       						url: contextPath + "/phone/post",
	    	       						type: "POST",
	    	       						contentType:"application/json; charset=utf-8",
	    	       						dataType: "json",
	    	       						cache : false,
	    	       						data : JSON.stringify(phone),
	    	       						success: function() {
	    	       							alert('폰번호가 변경되었습니다.');
	    	       							$('#phone_check').attr('type', 'hidden');
	    	       							console.log('인증하고난후:'+$("#certi").val())
	    	       							
	    	       						},
	    	       						error: function(request,status,error){
	    	       							alert('에러' + request.status+request.responseText+error);
	    	       						}
	    	       					});
	    	       					
	    	       	        	}else {
	    	       	        		alert('인증번호가 맞지 않습니다.');
	    	       	        	}
	    	       			})
	    	       		},
	    	       		error: function(){
	    	       			console.log('에러');
	    	       		}
	    	        })
	    		
	        });
		}
        
	})
	
	
});




function imageChange(){
	var file = document.getElementById("uploadFile").files[0]
	if (file) {
	//console.log(document.getElementById("uploadFile").files[0])
	 var reader = new FileReader(); //파일을 읽기 위한 FileReader객체 생성
    reader.onload = function (e) {
    //파일 읽어들이기를 성공했을때 호출되는 이벤트 핸들러
        $('#myPic').attr('src', e.target.result);
        //이미지 Tag의 SRC속성에 읽어들인 File내용을 지정
        //(아래 코드에서 읽어들인 dataURL형식)
    }                   
    reader.readAsDataURL(document.getElementById("uploadFile").files[0]);
    //File내용을 읽어 dataURL형식의 문자열로 저장
	}	
}

//주소 api
function execPostCode(){
	daum.postcode.load(function(){
        new daum.Postcode({
            oncomplete: function(data) {
				//변수값 없을때는 ''
				var addr = '';
				$('#zipcode').attr('value', data.zonecode);
				$('#addr1').attr('value', data.address);
            	}
            }).open();
    });
}
</script>
<div class="wrapper">

	<h2 id="subTitle">회원정보 변경</h2>

<!--	
<div class="mypage_info_div">
		<table class="mypage_profile">
			<tr style="padding:30px;">
				<td>
				<label for="uploadFile">
				<img id="myPic">
				<i class="fas fa-camera" style="cursor:pointer; margin:-25px; margin-top:55px; color:#849199; font-size:17px; background-color:#fff; padding:5px; border-radius:50px; border:1px solid #ccc"></i>
				</label>
				<span id="profile_nick"></span></td>
				<td><span id="profile_text"></span></td>
			</tr>
			<tr>
				<td>프로필 사진 변경</td>
				<td>
					<input type="file" id="uploadFile" name="uploadFile" onchange="imageChange()" style="display:none;">
					<input type="button" id="img_upload" value="변경">
					<input type="button" id="img_delete" value="삭제">
				</td>
			</tr>
			<tr>
				<td>프로필 소개 변경</td>
				<td><input type="text" id="p_text">
				<input type="button" id="p_text_update" value="변경"></td>
			</tr>
		</table>
</div>
-->

<div class="mypage_info_div">

	<table class="mypage_info_table">
			<tr>
				<td>아이디</td>
				<td><input type="text" id="id" readonly="readonly"></td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td><input type="button" value="비밀번호 변경" class="pre_order_btn2" onclick="location.href='/mypage/mypage_pwd'" style="width:100px; text-align:center"></td>
					
			</tr>
			<tr>
				<td><span class="asterisk">* </span>이름</td>
				<td><input type="text" id="name"></td>
			</tr>
			<tr>
				<td><span class="asterisk">* </span>닉네임</td>
				<td><input type="text" id="nickname"></td>
			</tr>
			<tr>
				<td><span class="asterisk">* </span>이메일</td>
				<td><input type="text" id="email" name="email">
				<font size="2" color="black" name="email_check" id="email_check"></font>
				</td>
			</tr>	
			<tr>
				<td><span class="asterisk">* </span>전화번호</td>
				<td><input type="text" id="phone"><input type="hidden" id="phone_check" class="pre_order_btn3" style="width:100px; text-align:center">
				<input type="hidden" id="certi" name="certi" value="1">
				<input type="hidden" name="certiNum" id="certiNum">
				<input type="hidden" id="certiSubmit" value="확인">
			</tr>
			<tr>
				<td><span class="asterisk">* </span>동네 설정</td>
				<td><select name="dongne1" id="dongne1" class="sign_select">
						<option value="0">지역을 선택하세요</option>
					</select> 
					<select name="dongne2" id="dongne2" class="sign_select"></select>
				</td>
			</tr>
			
		</table>
	</div>
	
	<span class="mypage_sub_title">부가정보</span> 
	<div class="mypage_info_div">
		<table class="mypage_info_table">
			<tr>
				<td>생년월일</td>
				<td><input type="date" id="birth"></td>
			</tr>	
			<tr>
				<td>주소</td>
				<td style="margin:5px;">
					<input type="text" id="zipcode" style="width:80px;"><input type="button" value="우편번호검색" onclick="execPostCode()" class="pre_order_btn3" style="width:100px; text-align:center"><br>
					<input type="text" id="addr1" style="margin-top:5px; width:300px"> <br>
					<input type="text" id="addr2" style="margin-top:5px; width:300px">
				</td>
			</tr>
		</table>
	</div>
	
	<div class="confirm_btns">
		<input type="button" value="정보 변경" id="update_info" class="go_list" style="width:200px; padding:10px; border-radius:20px">
	</div>
</div>


<%@ include file="/WEB-INF/views/include/footer.jsp" %>