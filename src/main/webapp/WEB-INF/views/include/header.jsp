<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://sargue.net/jsptags/time" prefix="javatime" %>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal" var="loginUser"/>
</sec:authorize>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<!-- spring security 쓰면 post 전송할때 403에러 떠서 추가함 -->
	<meta name="_csrf" content="${_csrf.token}">
	<!-- 이미지 캐싱 x -->
	<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Expires" content="0" />
	
	<title>당근멍캣</title>
	<link rel="stylesheet" href="<c:url value="/resources/css/common.css"/>">
	<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/chat_room.css" />
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
	
	<script src="<c:url value="/resources/js/jquery-1.12.4.min.js" />" type="text/javascript" ></script>
	<script src="<c:url value="/resources/js/jquery.form.min.js" />" type="text/javascript" ></script>
	<script src="https://unpkg.com/dayjs@1.8.21/dayjs.min.js" type="text/javascript" ></script>
	<script src="<c:url value="/resources/js/common.js" />" type="text/javascript" ></script>
	<script src="<c:url value="/resources/js/swiper.min.js" />" type="text/javascript" ></script>
	<!-- datepicker -->
	<link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" />  
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>  
	<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
	
	<script>
	//${loginUser}
	//${loginUser.id}
	$.ajaxSetup({
	    error: function(jqXHR, exception) {
	        if (jqXHR.status === 0) {
	            alert('Not connect.\n Verify Network.');
	        } 
	        else if (jqXHR.status == 400) {
	            alert('Server understood the request, but request content was invalid. [400]');
	        } 
	        else if (jqXHR.status == 401) {
	            alert("로그인 후 이용해주세요. [401]");
	        } 
	        else if (jqXHR.status == 403) {
	            alert('Forbidden resource can not be accessed. [403]');
	        } 
	        else if (jqXHR.status == 404) {
	            alert('Requested page not found. [404]');
	        } 
	        else if (jqXHR.status == 500) {
	            alert('Internal server error. [500]');
	        } 
	        else if (jqXHR.status == 503) {
	            alert('Service unavailable. [503]');
	        } 
	        else if (exception === 'parsererror') {
	            alert('Requested JSON parse failed. [Failed]');
	        } 
	        else if (exception === 'timeout') {
	            alert('Time out error. [Timeout]');
	        } 
	        else if (exception === 'abort') {
	            alert('Ajax request aborted. [Aborted]');
	        } 
	        else {
	            alert('Uncaught Error.n' + jqXHR.responseText);
	        }
	        console.log(exception);
	    }
	});
	
	
	var csrfToken = $("meta[name='_csrf']").attr("content");
	console.log(csrfToken);
	$.ajaxPrefilter(function(options, originalOptions, jqXHR){
	    if (options['type'].toLowerCase() === "post" || "put" || "delete") {
	        jqXHR.setRequestHeader('X-CSRF-TOKEN', csrfToken);
	    }
	});
	
	
	$(document).ready(function(){
		
		var contextPath = "<%=request.getContextPath()%>";
		
		$.get(contextPath +"/dog_cate", function(json){
			var datalength = json.length;
			if(datalength >= 1){
				var sCont = "";
				for(i=0; i<datalength; i++){
					sCont += "<li><a href='"+ contextPath + "/mall/product/list/dog/" + json[i].id + "'>" + json[i].name + "</a>";
				}
				$('#dog_cate').append(sCont);
			}
		});
		
		$.get(contextPath +"/cat_cate", function(json){
			var datalength = json.length;
			if(datalength >= 1){
				var sCont = "";
				for(i=0; i<datalength; i++){
					sCont += "<li><a href='" + contextPath + "/mall/product/list/cat/" + json[i].id + "'>" +  json[i].name + "</a>";
				}
				$('#cat_cate').append(sCont);
			}
		})
		
		/* 글쓴 시간 비교시간 변경 */
		var regdate = document.getElementsByClassName("regdate");
		$.each(regdate, function(idx, item) {
			var writeNow = dayjs(item.getAttribute("regdate")).toDate();
		 	item.innerHTML = timeBefore(writeNow);
		});
	});
	</script>
</head>
<body>
<div id="wrap">
<header id="header">
	<div class="s-inner">
		<h1 id="logo"><a href="<c:url value="/" />">당근멍캣</a></h1>

		<div class="h_search">
			<form action="/search" method="get">
				<select name="type">
					<option value="중고">중고</option>
					<option value="몰">몰</option>
				</select>
				<input type="text" class="text" name="search">
				<input type="submit" class="btn">
			</form>
		</div>
		
		<div class="h_util_wrap">
			<sec:authorize access="isAnonymous()">
			<ul class="h_util">
				<li><a href="<c:url value="/login" />">로그인</a></li>
				<li><a href="<c:url value="/sign/contract" />">회원가입</a></li>
				<li><a href="<c:url value="/mypage/mypage_main" />">마이페이지</a></li>
			</ul>
			</sec:authorize>
			
			<sec:authorize access="isAuthenticated()">
				<ul class="h_util">
				<li><a href="/profile/${loginUser.id }">${loginUser.nickname}님 안녕하세요.</a></li>
				<li><a href="<c:url value="/mypage/mypage_main" />">마이페이지</a></li>
				<li><a href="<c:url value="/logout" />">로그아웃</a></li>
				</ul>
			</sec:authorize>
			<ul class="h_util2">
				<li><a href="<c:url value="/mypage/joongo/list?memId=${loginUser.id}" />"><img src="/resources/images/ico_salesarticle.png"><span>판매글</span></a></li>
				<li><a href="<c:url value="/chat" />"><img src="/resources/images/ico_chatting.png"><span>채팅</span></a></li>
				<li><a href="<c:url value="/mall/cart/list" />"><img src="/resources/images/ico_cart.png"><span>장바구니</span></a></li>
				<li><a href="/mypage/mypage_order_list"><img src="/resources/images/ico_buy.png"><span>구매내역</span></a></li>
			</ul>
		</div>

		<div class="h_search_btn"><span class="text_hidden">검색</span></div>
		<div id="menuToggle">
			<span class="t"></span>
			<span class="m"></span>
			<span class="b"></span>
		</div>
	</div>
	<nav id="gnb">
		<div>
			<sec:authorize access="isAnonymous()">
			<ul>
				<li><a href="<c:url value="/login" />">로그인</a></li>
				<li><a href="<c:url value="/contract" />">회원가입</a></li>
				<li><a href="/mypage/mypage_main">마이페이지</a></li>
			</ul>
			</sec:authorize>
			<sec:authorize access="isAuthenticated()">
			<ul>
				<li><a href="#">${loginUser.id}님</a></li>
				<li><a href="<c:url value="/mypage/mypage_main" />">마이페이지</a></li>
				<li><a href="<c:url value="/logout" />">로그아웃</a></li>
			</ul>
			</sec:authorize>
		</div>
		<ul>
			<li><a href="<c:url value="/joongo_list" />">중고</a>
				<ul>
					<li><a href="<c:url value="/joongo_list/all/1"/>">멍</a></li>
					<li><a href="<c:url value="/joongo_list/all/2"/>">냥</a></li>
				</ul>
			</li>
			<li class="depth2"><a href="<c:url value="/mall/product/list/dog" />">멍</a>
				<ul id="dog_cate">
				</ul>
			</li>
			<li class="depth2"><a href="<c:url value="/mall/product/list/cat" />">냥</a>
				<ul id="cat_cate">
				</ul>
			</li>
			<li><a href="#">커뮤니티</a></li>
			<li><a href="<c:url value="/notice" />">공지사항</a></li>
		</ul>
		<div>
			<ul>
				<li><a href="#">판매글</a></li>
				<li><a href="/chat">채팅</a></li>
				<li><a href="/mall/cart/list">장바구니</a></li>
				<li><a href="/mypage/order_list">주문내역</a></li>
			</ul>
		</div>
	</nav>
</header>