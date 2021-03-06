<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/admin/include/header.jsp" %>

<script>

$(document).ready(function(){
	var length = $('#order_list tbody td').length;

	//미수금 있는 주문
	/* for(i=7; i<length; i+=18){
		if($('#order_list').find("td:eq(" + i + ")").text() != '0' ){
			for(j=(i-7); j<(i+11); j++){
				$(this).find("td:eq(" + j + ")").attr('style', 'background-color:#f0f8ff')
			}
			$(this).find("td:eq(" + i + ")").attr('style', 'background-color:#f0f8ff; color:red;');
		}
	} */
	
	//주문취소
	for(i=6; i<length; i+=18){
		if($('#order_list').find("td:eq(" + i + ")").text() != '0' ){
			for(j=(i-6); j<(i+12); j++){
				$(this).find("td:eq(" + j + ")").attr('style', 'background-color:#fff0f5')
			}
			$(this).find("td:eq(" + i + ")").attr('style', 'background-color:#fff0f5; color:red;');
		}
	}
	
	var str;
	var state;
	var start = getParameter('start');
	var end = getParameter('end');
	var stateStr = getParameter('state');
	var settleCase = getParameter('settle_case');
	var search = getParameter('search');
	var query = getParameter('query');
	var misu = getParameter('misu');
	var return_price = getParameter('return_price');
	
	
	
	$('input[name=order_state]').change(function(){
		state = $(this).val(); 
	});
	
	
	$('input[id=start_date]').change(function(){
		start = $(this).val(); 
	});
	
	$('input[id=end_date]').change(function(){
		end = $(this).val(); 
	});
	
	
	
	if(settleCase != null){
		$('input:radio[name="pay_type"][value="' + settleCase + '"]').prop('checked', true);
	}
	
	if(start != null || end != null){
		$("#start_date").attr("value", start);
		$("#end_date").attr("value", end);
	}
	
	if(stateStr != null){
		$('input:radio[name="order_state"][value="' + stateStr + '"]').prop('checked', true);
	}
	
	if(search != null || query !=null){
		$("select[name='search'").val("${search}").prop("selected", true);
		$('#query').prop('value', "${query}");  
	}
	
	if(misu == 'y'){
		$('input:checkbox[name="other"][value="미수금"]').prop('checked', true);
	}
	
	if(return_price == 'y'){
		$('input:checkbox[name="other"][value="반품품절"]').prop('checked', true);
	}
	

	
	$('#searchBtn').on('click', function(){
		
		if(query == ""){
			alert('검색어를 입력하세요.');
			return;
		}
		
		var keyword = $("select[name=search]").val();
		var query = $('#query').val();
		var start_val = $("#start_date").val();
		var end_val = $("#end_date").val();
		var state = $('input[name=order_state]:checked').val();
		var settle_case = $('input[name=pay_type]:checked').val();
		var other = $('input[name=other]:checked').val();
		
		var part_cancel;
		
		if(keyword == null){
			keyword = '';
		}
		if(state == '부분취소'){
			part_cancel = 'y';
		}else{
			part_cancel= '';
		}
		if(state == '전체'){
			state = '';
		}
		
		if(other == undefined){
			other = '';
		}
		
		var add = '/admin/order/list?search=' + keyword + '&query=' + query + '&start='+ start_val + '&end=' + end_val + '&state=' + state
		+ '&settle_case=' + settle_case + '&part_cancel=' + part_cancel;
		
		var chkArray = new Array();
		 
        $('input[name=other]:checked').each(function() {
            chkArray.push(this.value);
        });
		for(i=0; i<chkArray.length; i++){
			console.log(chkArray[i]);
			if(chkArray[i] == '미수금'){
				add += '&misu=y'
			}else if(chkArray[i] == '반품품절'){
				add += '&return_price=y'
			}
		}

		console.log(add)
		location.href= add;
	});
	
	
	
	$("select[name=search]").change(function(){
		if($(this).val() == 'mem_phone' || $(this).val() == 'address_phone1' || $(this).val() == 'address_phone2'){
			$('#query').keyup(function(){
				$(this).val( $(this).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/,"$1-$2-$3").replace("--", "-") );
			});
		}
	});
	
	$(document).on('click', '#search', function(){
		
		if(query == ""){
			alert('검색어를 입력하세요.');
			return;
		}
		
		var keyword = $("select[name=search]").val();
		var query = $('#query').val();
		var start_val = $("#start_date").val();
		var end_val = $("#end_date").val();
		var state = $('input[name=order_state]:checked').val();
		var settle_case = $('input[name=pay_type]:checked').val();
		var other = $('input[name=other]:checked').val();
		
		var part_cancel;
		
		if(keyword == null){
			keyword = '';
		}
		if(state == '부분취소'){
			part_cancel = 'y';
		}else{
			part_cancel= '';
		}
		if(state == '전체'){
			state = '';
		}
		
		if(other == undefined){
			other = '';
		}
		/*
		var add = '/admin/order/list?start='+ start_val + '&end=' + end_val + '&state=' + state
					+ '&settle_case=' + settle_case + '&part_cancel=' + part_cancel;
		*/
		var add = '/admin/order/list?search=' + keyword + '&query=' + query + '&start='+ start_val + '&end=' + end_val + '&state=' + state
		+ '&settle_case=' + settle_case + '&part_cancel=' + part_cancel;
		
		var chkArray = new Array();
		 
        $('input[name=other]:checked').each(function() {
            chkArray.push(this.value);
        });
		for(i=0; i<chkArray.length; i++){
			console.log(chkArray[i]);
			if(chkArray[i] == '미수금'){
				add += '&misu=y'
			}else if(chkArray[i] == '반품품절'){
				add += '&return_price=y'
			}
		}

		console.log(add)
		location.href= add;
		
	});
	

	var date = getDateStr(new Date());
	
	$('#today').on('click', function(){
		$("#start_date").attr("value", date);
		$("#end_date").attr("value", date);
	});
	
	$('#7days_ago').on('click', function(){
		var today = new Date();
		var date =  getDateStr(new Date());
		var dayOfMonth = today.getDate();
		today.setDate(dayOfMonth - 7);
		var todayStr =  getDateStr(today);

		$("#start_date").attr("value", todayStr);
		$("#end_date").attr("value",date);
	});
	
	$('#15days_ago').on('click', function(){
		var today = new Date();
		var dayOfMonth = today.getDate();
		today.setDate(dayOfMonth - 15);

		$("#start_date").attr("value", getDateStr(today));
		$("#end_date").attr("value", date);
	});
	
	$('#1month_ago').on('click', function(){
		var d = new Date()
		var monthOfYear = d.getMonth()
		d.setMonth(monthOfYear - 1);
		
		$("#start_date").attr("value", getDateStr(d));
		$("#end_date").attr("value",date);
	});
	
	$('#6month_ago').on('click', function(){
		var d = new Date()
		var monthOfYear = d.getMonth()
		d.setMonth(monthOfYear - 6);

		$("#start_date").attr("value",  getDateStr(d));
		$("#end_date").attr("value", date);
	});
	
	$('#1years_ago').on('click', function(){
		var d = new Date()
		var monthOfYear = d.getFullYear();
		d.setFullYear(monthOfYear - 1);

		$("#start_date").attr("value", getDateStr(d));
		$("#end_date").attr("value", date);
	});
	
	$('#all_day').on('click', function(){
		$("#start_date").attr("value", '');
		$("#end_date").attr("value", '');
	});
	
	
	
	
	
	
});

function getParameter(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function getDateStr(myDate){
	var year = myDate.getFullYear();
	var month = (myDate.getMonth() + 1);
	var day = myDate.getDate();
	
	month = (month < 10) ? "0" + String(month) : month;
	day = (day < 10) ? "0" + String(day) : day;
	
	return  year + '-' + month + '-' + day;
}

</script>


<div class="card shadow mb-4">
	<div class="card-header py-2">
		<h6 class=" font-weight-bold text-primary" style="font-size: 1.3em;">
			<div class="mt-2 float-left">주문 리스트</div>
			
		</h6>
	</div>
	<!-- card-body -->
	
	<div class="card-body" style="padding:30px;">
		<div class="col-sm-12 col-md-6 p-0">
			<div style="padding:5px;"><a href="/admin/order/list">전체 목록</a>  |  전체 주문내역  ${totalCnt}건</div>
			<div>
				<select class="custom-select custom-select-sm" name="search" style="width:100px;">
					<option value="id" selected>주문번호</option>
					<option value="mem_id">회원 ID</option>
					<option value="mem_name">주문자</option>
					<option value="mem_phone">주문자휴대폰</option>
					<option value="address_name">받는분</option>
					<option value="address_phone1">받는분일반전화</option>
					<option value="address_phone2">받는분휴대폰</option>
				</select>
				<label>
					<input type="text" class="form-control form-control-sm" id="query">
				</label>
				<input type="button" class="btn btn-primary btn-sm" value="검색" id="searchBtn"></input>
			</div>
		</div>
		<div class="admin_od_menu">
			<div class="admin_od_sub" style="border-top:1px solid #ccc">
				<span style="font-weight:bold; margin-right:20px;">주문상태 </span> 
				<input type="radio" name="order_state" value="전체" checked> 전체 
				<input type="radio" name="order_state" value="대기"> 대기 
				<input type="radio" name="order_state" value="결제"> 결제
				<input type="radio" name="order_state" value="배송"> 배송
				<input type="radio" name="order_state" value="완료"> 완료 
				<input type="radio" name="order_state" value="전체취소"> 전체취소
				<input type="radio" name="order_state" value="부분취소"> 부분취소
			</div>
			<div class="admin_od_sub">
				<span style="font-weight:bold; margin-right:20px;"> 결제수단 </span> 
				<input type="radio" name="pay_type" value="전체" checked> 전체 
				<input type="radio" name="pay_type" value="무통장"> 무통장
				<input type="radio" name="pay_type" value="카카오페이"> KAKAOPAY
			</div>
			
			<div class="admin_od_sub">
				<span style="font-weight:bold; margin-right:20px;"> 기타선택 </span> 
				<input type="checkbox" name="other" value="미수금"> 미수금
				<input type="checkbox" name="other" value="반품품절"> 반품,품절
			</div>
			
			<div class="admin_od_sub" style="border:none;">
				<div style="width:30%;">
					<span style="font-weight:bold; margin-right:20px; float:left;"> 주문일자 </span> 
					<input type="date" id="start_date" class="form-control" style="width:150px;float:left;">
					 <span style="float:left;">&nbsp ~ &nbsp</span>
					 <input type="date" id="end_date" class="form-control input-sm" style="width:150px;float:left;">
				 </div>
					&nbsp&nbsp
					<input type="button" value="전체" id="all_day" class="btn btn-outline-secondary btn-sm">
					<input type="button" value="오늘" id="today" class="btn btn-outline-secondary btn-sm">
					<input type="button" value="7일" id="7days_ago" class="btn btn-outline-secondary btn-sm">
					<input type="button" value="15일" id="15days_ago" class="btn btn-outline-secondary btn-sm">
					<input type="button" value="1개월" id="1month_ago" class="btn btn-outline-secondary btn-sm">
					<input type="button" value="6개월" id="6month_ago" class="btn btn-outline-secondary btn-sm">
					<input type="button" value="1년" id="1years_ago" class="btn btn-outline-secondary btn-sm">
					<input type="button" value="조회" id="search" class="btn btn-primary btn-sm">
				
			</div>
			
		</div>
		<table class="adm_table_style1" style="padding:20px; text-align:center" id="order_list">
			<!-- <colgroup>
				<col width="3%">
				<col width="15%">
				<col width="7%">
				<col width="7%">
				<col width="10%">
				<col width="10%">
				<col width="7%">
				<col width="7%">
				<col width="7%">
				<col width="7%">
				<col width="12%">
				<col width="5%">
			</colgroup> -->
			<thead>
				<tr>
					<th rowspan="3" width="3%">번호</th>
					<th colspan="2" width="15%">주문 번호</th>
					<th width="7%">주문자</th>
					<th width="10%">주문자전화</th>
					<th width="7%">받는 분</th>
					<th rowspan="3" width="7%">결제합계<br>배송비포함</th>
					<th rowspan="3" width="7%">주문취소</th>
					<th rowspan="3" width="7%">미수금</th>
					<th rowspan="3" width="7%">사용한<br>마일리지</th>
					<th rowspan="3" width="10%">주문일</th>
					<th rowspan="3"  width="5%">관리</th>
				</tr>
				<tr>
					<th rowspan="2" width="7%">상태</th>
					<th rowspan="2" width="7%">결제 수단</th>
					<th rowspan="2" width="7%">아이디</th>
					<th width="10%">상품 수</th>
					<th width="7%">누적주문수</th>
				</tr>
				<tr>
					<th width="10%">운송장번호</th>
					<th width="10%">배송 일시</th>
				</tr>
				
			</thead>
			<tbody>
				<c:if test="${empty list}">
					<tr>
						<td colspan="12" style="padding:200px;" class="tc">자료가 없습니다.</td>
					</tr>
				</c:if>
				
				<c:forEach var="order" items="${list}" varStatus="status">
				<c:if test="${not empty list}">
				<tr>

					<td rowspan="3">${pageMaker.totalCount - ((pageMaker.cri.page -1) * pageMaker.cri.perPageNum + status.index)}</td>
					<td  colspan="2">${order.id }</td>
					<td>${order.member.name}</td>
					<td>${order.member.phone}</td>
					<td>${order.addName}</td>
					<td rowspan="3"><fmt:formatNumber value="${order.finalPrice }"/></td>
					<td rowspan="3"><fmt:formatNumber value="${order.returnPrice}"/></td>
					<td rowspan="3"><fmt:formatNumber value="${order.misu}"/></td>
					<td rowspan="3"><fmt:formatNumber value="${order.usedMileage}"/></td>
					<td rowspan="3">
						<fmt:parseDate value="${order.regDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parseDate" type="both" />
	            		<fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${parseDate}"/>
					</td>
					<td rowspan="3">
						<input type="button" value="보기" class="btn" style="background-color:#738dc5; color:#fff" onclick="location.href='/admin/order?id=${order.id}'">
					</td>
				</tr>
				<tr>
					<td rowspan="2">${order.state}</td>
					<td rowspan="2">${order.settleCase}</td>
					<td rowspan="2" >${order.member.id}</td>
					<td>${order.details.size()}</td>
					<td>${order.ordercnt}건</td>
				</tr>
				<tr>
					<td>
						<c:if test="${order.trackingNumber != null}"> ${order.trackingNumber} </c:if>
						<c:if test="${order.trackingNumber == null}"> - </c:if>	
					</td>
					<td>
					<c:if test="${order.shippingDate != null}"> 
						<fmt:parseDate value="${order.shippingDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parseDate" type="both" />
	            		<fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${parseDate}"/>
					</c:if>
					<c:if test="${order.shippingDate == null}"> - </c:if>	
						
					</td>
				</tr>
				</c:if>		
				</c:forEach>
				
			</tbody>
		
		</table>
		
		<div class="board_page">
				
		
		    <c:if test="${pageMaker.prev}">
		    	<p><a href="<%=request.getContextPath()%>/admin/order/list${pageMaker.makeQuery(pageMaker.startPage - 1)}&search=${search}&query=${query}&start=${start}&end=${end}&state=${state}&settle_case=${settleCase}&part_cancel=${partCancel}&misu=${misu}&return_price=${returnPrice}">이전</a></p>
		    </c:if> 
			<ul>
			
			  <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="idx">
			  	<li><a href="<%=request.getContextPath()%>/admin/order/list${pageMaker.makeQuery(idx)}&search=${search}&query=${query}&start=${start}&end=${end}&state=${state}&settle_case=${settleCase}&part_cancel=${partCancel}&misu=${misu}&return_price=${returnPrice}">${idx}</a></li>
			  </c:forEach>
			</ul>
			
			  <c:if test="${pageMaker.next && pageMaker.endPage > 0}">
			  	
			    <p><a href="<%=request.getContextPath()%>/admin/order/list${pageMaker.makeQuery(pageMaker.endPage + 1)}&search=${search}&query=${query}&start=${start}&end=${end}&state=${state}&settle_case=${settleCase}&part_cancel=${partCancel}&misu=${misu}&return_price=${returnPrice}">다음</a></p>
			  </c:if>
			
		</div>
	</div>
<%@ include file="/WEB-INF/views/admin/include/footer.jsp" %>
