<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/views/include/header.jsp" %>

<script type="text/javascript">
var dongne1Id;
var dongne1Name = "${dongne1Name}"
var pageNum = "${pageMaker.cri.page}"
$(function(){
   var contextPath = "<%=request.getContextPath()%>";
});
</script>

<div id="subContent">
	<h2 id="subTitle">찜한 중고 상품 목록</h2>
	<div id="pageCont" class="s-inner">
		<div class="list_top">
		</div>
		<div>
			<ul class="product_list s-inner">
				<c:forEach items="${list}" var="sale">
				<li><a href="<%=request.getContextPath()%>/joongoSale/detailList?id=${sale.id}">
					<div class="img">
						<c:if test="${empty sale.thumImg}">
							<img src="<%=request.getContextPath()%>/resources/images/no_image.jpg">
						</c:if>
						<c:if test="${not empty sale.thumImg}">
							<img src="<%=request.getContextPath() %>/resources/${sale.thumImg}">
						</c:if>
					</div>
					<div class="txt">
						<p class="location">${sale.dongne1.name} ${sale.dongne2.name} · <span class="regdate" regdate="${sale.regdate}"><javatime:format value="${sale.regdate }"  pattern="yyyy-MM-dd HH:mm:ss"/></span></p>
						<p class="subject">${sale.title}</p>
						<p class="price">
							<span class="${sale.saleState.code }">${sale.saleState.label}</span>
							<span>
								<c:if test="${sale.price eq 0 }" >무료 나눔</c:if>
								<c:if test="${sale.price ne 0 }"> ${sale.price }원</c:if>
							</span>
						</p>
						<ul>
							<li class="heart">${sale.heartCount}</li>
							<li class="chat">${sale.chatCount}</li>
						</ul>
					</div>
					<c:if test="${sale.saleState.code eq 'SOLD_OUT' and sale.buyMember.id eq loginUser.id and reviewed ne true}">
						<div class="review send">
							거래후기 보내기
						</div>
					</c:if>
				</a></li>
				</c:forEach>
				<c:if test="${empty list}">
					<li class="no_date">찜한 중고 상품이  없습니다.</li>
				</c:if>
			</ul>
		</div>
		
		<div class="board_page">
			<c:if test="${pageMaker.prev}">
		    	<p><a href="<%=request.getContextPath()%>/mypage/joongo/heart/list/${pageMaker.makeQuery(pageMaker.startPage - 1)}">이전</a></p>
		    </c:if> 
			<ul>
				<c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="idx">
			    	<li><a href="<%=request.getContextPath()%>/mypage/joongo/heart/list/${pageMaker.makeQuery(idx)}">${idx}</a></li>
				</c:forEach>
			</ul>
			
			<c:if test="${pageMaker.next && pageMaker.endPage > 0}">
	    		<p><a href="<%=request.getContextPath()%>/mypage/joongo/heart/list/${pageMaker.makeQuery(pageMaker.endPage + 1)}">다음</a></p>
			</c:if> 
		</div>
	</div>
</div>


<%@ include file="/WEB-INF/views/include/footer.jsp" %>