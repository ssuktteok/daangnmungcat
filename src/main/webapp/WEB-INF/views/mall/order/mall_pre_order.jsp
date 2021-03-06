<%@page import="daangnmungcat.dto.AuthInfo"%>
<%@page import="daangnmungcat.service.MileageService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style>
.wrapper {margin:0 auto; padding:80px; margin-bottom:50px;}
.wrapper input{font-family:'S-CoreDream'; margin:2px 2px;}
.wrapper select{font-family:'S-CoreDream'}
</style>
<script>
$(document).ready(function(){
	
	var price = $('#final_price').text();
	$('input[name=final]').prop('value', uncomma(price));
	
	$('#order_btn').on('click', function(){
		$('#form').submit();
	});
	
	$('#account_order_btn').on('click', function(){
		console.log('무통장')
		$("#form").attr("action", "/accountPay");
		$('#form').submit();
	})
	
	$('input[name=chk]:eq(0)').on('change', function(){
		if($('input[name=chk]:eq(0)').is(':checked')){
			$('#zipcode').attr('value', "${member.zipcode}");
			$('#address1').attr('value', "${member.address1}");
			$('#address2').attr('value', "${member.address2}");
			$('#order_name').attr('value', "${member.name}");
			$('#phone1').attr('value', "");
			$('#phone2').attr('value', "${member.phone}");
			$('#memo').attr('value', "");
		}else{
			$('#zipcode').attr('value', "");
			$('#address1').attr('value', "");
			$('#address2').attr('value', "");
			$('#order_name').attr('value', "");
			$('#phone1').attr('value', "");
			$('#phone2').attr('value', "");
			$('#memo').attr('value', "");
		}
	});
	
	$('input[name=chk]:eq(1)').on('click',function(){
		$('#zipcode').attr('value', "");
		$('#address1').attr('value', "");
		$('#address2').attr('value', "");
		$('#order_name').attr('value', "");
		$('#phone1').attr('value', "");
		$('#phone2').attr('value', "");
		$('#memo').attr('value', "");
	});
	
	$('#myAddress').on('click', function(){
		window.open("/mall/order/mall_my_address", "", "width=650, height=520, left=100, top=50 ,location=no, directoryies=no, resizable=no, scrollbars=yes");
	});
	
	$('#mile_chk').on('change', function(){
		
		if($('#mile_chk').is(':checked')){
			$('#use_mileage').prop('value', ${member.mileage});	
			var use = $('#use_mileage').val();
			$('#final_price').text(comma(${final_price} - use));
			$('input[name=final]').prop('value', uncomma(${final_price} - use));
		}else {
			$('#use_mileage').prop('value', "0");
			$('#final_price').text(comma(${final_price}));
			$('input[name=final]').prop('value', uncomma(${final_price}));
			
		}
	});
	
	$('#use_mileage').keyup(function() {
		var use = $('#use_mileage').val();
		
		if(${member.mileage} < use){
			alert('보유 마일리지가 부족합니다.');
			$('#use_mileage').prop('value', "");
			$('#final_price').text(comma(${final_price}));
			$('input[name=final]').prop('value', uncomma(${final_price}));
		}else {
			$('#final_price').text(comma(${final_price} - use));
			$('input[name=final]').prop('value', uncomma(${final_price} - use));
		}
	})
	
	
	$('#account_tr').hide();
	var type;
	$("input[name=pay_type]:radio").change(function () {
		 type = this.value;
		if(type == '무통장'){
			$('#account_tr').show();
		}else {
			$('#account_tr').hide();
		}
	});
	
	$('#pay').on('click', function(){
		
		if($('#orderer_name').val() == ""){
			alert("주문자 성함을 입력해주세요.");
			return;
		}else if($('#orderer_phone').val() == ""){
			alert("주문자 연락처를 입력해주세요.");
			return;
		}else if($('#orderer_email').val() == ""){
			alert("주문자 이메일을 입력해주세요.");
			return;
		}else if($('#order_name').val() == ""){
			alert("받으실 분 성함을 입력해주세요.");
			return;
		}else if($('#zipcode').val() == ""){
			alert("우편번호를 입력해주세요.");
			return;
		}else if($('#address1').val() == ""){
			alert("주소를 입력해주세요.");
			return;
		}else if($('#address2').val() == ""){
			alert("상세주소를 입력해주세요.");
			return;
		}else if($('#phone2').val() == ""){
			alert("받으실 분 연락처를 입력해주세요.");
			return;
		}else if($('#use_mileage').val() != "" && $('#use_mileage').val() < 1000){
			alert('마일리지는 1000원 이상 사용 가능합니다.')
			return;	
		}else {
			if(!$("[name=pay_type]:radio").is(":checked")){
				alert('결제 방식을 선택해주세요.');
			}else{
				if(type == '카카오페이'){
					$('#form').submit();
				}else {
					$("#form").attr("action", "/accountPay");
					$('#form').submit();
				}	
			}
			
		}	
	});

	
	$('#orderer_phone').keyup(function(){
		$(this).val( $(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/,"$1-$2-$3").replace("--", "-") );
	});
	
	$('#phone1').keyup(function(){
		$(this).val( $(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/,"$1-$2-$3").replace("--", "-") );
	});
	
	$('#phone2').keyup(function(){
		$(this).val( $(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/,"$1-$2-$3").replace("--", "-") );
	});
	
});

function check(a){
	var obj = document.getElementsByName("chk");

    for(var i=0; i<obj.length; i++){
        if(obj[i] != a){
            obj[i].checked = false;
        }
    }
    
}

function execPostCode(){
	daum.postcode.load(function(){
      new daum.Postcode({
          oncomplete: function(data) {
				//변수값 없을때는 ''
				var addr = '';
				$('#zipcode').attr('value', data.zonecode);
				$('#address1').attr('value', data.address);
          	}
          }).open();
  });
}

function comma(num) {
    str = String(num);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');

}

function uncomma(num) {
    str = String(num);
    return str.replace(/[^\d]+/g, '');
}

function inputNumberFormat(obj) {
   obj.value = comma(uncomma(obj.value));
}

</script>
<div class="wrapper">

<h2 style="text-align:center; margin-bottom:80px;">주문서 작성 / 결제 </h2>
<form method="post" id="form" action="/kakao-pay" enctype="multipart/form-data" accept-charset="utf-8">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" >
	<!-- 넘어가는 data -->
	<input type="hidden" name="first_pdt" value="${cart.get(0).product.name}"> <!-- 첫번째 -->
	<input type="hidden" name="pdt_qtt" value="${size}"> <!-- 주문개수 -->
	<input type="hidden" name="final"> <!-- 최종가격  -->
	<input type="hidden" name="mem_id" value="${member.id}"> 
	<input type="hidden" name="total_qtt" value="${total_qtt}"> <!-- 총 수량 -->
	<input type="hidden" name="plus_mile" value="${mileage}"> <!-- 적립예정 -->
	<input type="hidden" name="total" value="${total}"> <!-- 총 -->
	<input type="hidden" name="deli" value="${totalDeliveryFee}"> <!-- 배송비 -->
	
	<div class="pre_order_cart_div">
		<table id="order_list_table">
			<colgroup>
				<col width="200px">
				<col width="50px">
				<col width="50px">
				<col width="50px">
				<col width="50px">
				<col width="100px">
			</colgroup>
			<thead>
				<tr>
					<th>상품/옵션 정보</th>
					<th>수량</th>
					<th>상품금액</th>
					<th>적립금액</th>
					<th>합계금액</th>
					<th>배송비</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="cart" items="${cart}" varStatus="status">
				<tr>
					<td class="tl">
						<div class="order_img_wrapper">
							<c:if test="${cart.product.image1 eq null}"><a href="/mall/product/${cart.product.id}"><img src="/resources/images/no_image.jpg" class="order_list_img"></a></c:if>
							<c:if test="${cart.product.image1 ne null}"><a href="/mall/product/${cart.product.id}"><img src="/resources${cart.product.image1}" class="order_list_img"></a></c:if>
							<span style="margin-left:30px; line-height:100px; overflow:hidden">
								<input type="hidden" id="pdt_id" name="pdt_id" value="${cart.product.id}">
								<a href="/mall/product/${cart.product.id}">${cart.product.name}</a>
							</span>
						</div>
					</td>

					<td>${cart.quantity }</td>
					<td><span class="price" value="${cart.product.price }"><fmt:formatNumber value="${cart.product.price}"/></span></td>
					<td><fmt:formatNumber value="${cart.product.price * 0.01}" /></td>
					<td><fmt:formatNumber value="${cart.product.price * cart.quantity}"/></td>
					<td>
						<c:choose>
							<c:when test="${cart.product.deliveryKind eq '조건부 무료배송' }">
								<c:if test="${conditionalDeliveryFee eq 0}">
										무료배송
								</c:if>
								<c:if test="${conditionalDeliveryFee ne 0}">
									<fmt:formatNumber value="${cart.product.deliveryPrice}"/>원
								</c:if>
									<br>(<fmt:formatNumber value="${cart.product.deliveryCondition}"/>원 이상 구매 시 무료)
							</c:when>
							<c:when test="${cart.product.deliveryKind eq '유료배송' }">
									개당 ${cart.product.deliveryPrice}원
							</c:when>
							<c:otherwise>
									${cart.product.deliveryKind}
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</c:forEach>
				</tbody>
		</table>
	
		
		<div class="pre_order_go_cart_btn">
			<input type="button" value="장바구니로 가기" onclick="location.href='/mall/cart/list'" class="go_list" style="font-size:13px">
		</div>
	</div>	
	
	<div class="pre_order_box">
		<div class="box1">
			총 <span style="font-weight:bold">${size}</span>개의 상품금액 <br>
			<span style="font-weight:bold"><fmt:formatNumber value="${total}" /></span>원
		</div>
		<div class="box_img"><img src="/resources/images/order_plus.png"></div>
		<div class="box2">
			배송비<br> 
			<span style="font-weight:bold"><fmt:formatNumber value="${totalDeliveryFee}" /></span>
		</div>
		<div class="box_img"><img src="/resources/images/order_total.png"></div>
		<div class="box3">
			합계 <br>
			<span style="font-weight:bold"><fmt:formatNumber value="${total + totalDeliveryFee }" /></span>원<br>
			<span style="font-size:12px">적립예정 마일리지 : <fmt:formatNumber value="${mileage}" />원</span>
		</div>
		
	</div>
	
<div class="order_detail_info_div">
		<span class="tableTitle">주문자 정보</span>
		<table class="order_detail_table">
			<tr>
				<td><span class="asterisk">* </span>주문하시는 분</td> 
				<td><input type="text" value="${member.name}" id="orderer_name"></td> 
			</tr>
			<tr>
				<td>주소</td> 
				<td>
					<c:if test="${member.address1 eq null}"></c:if>
					<c:if test="${member.address1 ne null}">
						<span>(${member.zipcode}) ${member.address1} ${member.address2}</span>
					</c:if>
				</td> 
			</tr>
			<tr>
				<td><span class="asterisk">* </span>연락처</td> 
				<td><input type="text" value="${member.phone}" id="orderer_phone"></td> 
			</tr>
			<tr>
				<td><span class="asterisk">* </span>이메일</td> 
				<td><input type="text" value="${member.email}" id="orderer_email"></td> 
			</tr>
		</table>
	
		<span class="tableTitle">배송 정보</span>
			<table class="order_detail_table">
				<tr>
					<td>배송지 확인</td> 
					<td>
						<input type="checkbox" name="chk" onclick="check(this)" value="mem"> 주문자 정보와 동일
						<input type="checkbox" name="chk" onclick="check(this)" value="write"> 직접 입력   
						<input type="button" value="배송지관리" id="myAddress" class="pre_order_btn2">
					</td> 
				</tr>
				<tr>
					<td> <span class="asterisk">* </span> 받으실 분</td> 
					<td><input type="text" id="order_name" name="add_name"></td> 
				</tr>
				<tr>
					<td><span class="asterisk">* </span>받으실 곳</td> 
					<td>
						<input type="text" id="zipcode" name="zipcode">
						<input type="button" value="우편번호 검색" onclick="execPostCode()" class="pre_order_btn3">
						<br>
						<input type="text" id="address1" name="address1" style="width:280px">
						<input type="text" id="address2" name="address2">
					</td> 
				</tr>
				<tr>
					<td>받는 분 일반 전화</td> 
					<td><input type="text" id="phone1" name="phone1"></td> 
				</tr>
				<tr>
					<td><span class="asterisk">* </span>받는 분 휴대폰</td> 
					<td><input type="text" id="phone2" name="phone2"></td> 
				</tr>
				<tr>
					<td>남기실 말씀</td> 
					<td><input type="text" id="memo" name="order_memo" style="width:280px"></td> 
				</tr>
			</table>

	
	
		<span class="tableTitle">결제 정보</span>
		<table class="order_detail_table">
			<tr>
				<td>합계금액</td>
				<td><span id="total_price"><fmt:formatNumber value="${total}" /></span></td>
			</tr>
			<tr>
				<td>배송비</td>
				<td><span id="shipping_price"><fmt:formatNumber value="${totalDeliveryFee}"/></span></td>
			</tr>
			<tr>
				<td>적립액</td>
				<td><span id="mileage_info"><fmt:formatNumber value="${mileage}"/></span></td>
			</tr>
			<tr>
				<td>마일리지 사용</td>
				<td><input type="text" id="use_mileage" name="use_mileage">
				<input type="checkbox" id="mile_chk">전액 사용하기 
										(보유 마일리지:<fmt:formatNumber value="${memberMileage}"/>원)
				<input type="hidden" value="${memberMileage}" id="mem_mile"></td>
			</tr>
			<tr>
				<td>최종 결제 금액</td>
				<td><span id="final_price" style="font-weight:bold"><fmt:formatNumber value="${final_price}"/></span>
					
				</td>
			</tr>
			<tr>
				<td>결제 수단 선택</td>
				<td>
					<input type="radio" name="pay_type" value="무통장"> 무통장입금
					<input type="radio" name="pay_type" value="카카오페이"> 카카오페이 <br>
					<div id="account_tr" style="padding:10px">
						입금자명  <input type="text" value="${member.name }" readonly><br>
						입금은행  
						<select>
							<option>국민 123-123121-1234 (주)당근멍캣</option>
						</select>
					</div>
				</td>
				
			</tr>
		</table>
</div>	

	<div class="pre_order_btns">
		<input type="button" value="결제하기" id="pay" class="go_list" style="width:150px; height:50px; border-radius:70px; font-weight:500;">
	</div>
	</form>

</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>