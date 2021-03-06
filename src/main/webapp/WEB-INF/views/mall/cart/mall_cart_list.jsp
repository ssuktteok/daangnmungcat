<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/header.jsp" %>

<script>
$(document).ready(function(){
	
	$('#pre_order').on('click', function(){
		if($('input:checkbox[name=id]:checked').length == 0){
			alert('주문하실 상품을 선택하세요.')
		} else {
			$('#form').submit();
		}
	})
	
	$("#selectAll").on("change", function(e){
		var checked = $(this).prop("checked");
		$(".ckbox").prop("checked", checked);
	});

	$("#selectAll").trigger("click");
	
    $(".qtt div p.up").click(function(){
		var price = $(this).closest("tr").find(".price").attr("value");
		
		var quantity_span = $(this).closest("tr").find(".quantity");
		var quantity = quantity_span.val();
		
        if (quantity == 999){
            alert("최대 구매수량은 999개입니다.")
            return false;
        }

        quantity_span.val(++quantity);
        var amount = price * quantity;
        var amount_span = $(this).closest("tr").find(".amount");
        amount_span.text(amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
    });
	
	
    $(".qtt div p.down").click(function(){
		var price = $(this).closest("tr").find(".price").attr("value");
		
		var quantity_span = $(this).closest("tr").find(".quantity");
		var quantity = quantity_span.val();
		
        if (quantity == 1){
            alert("최소 구매수량은 1개입니다.")
            return false;
        }

        quantity_span.val(--quantity);
        var amount = price * quantity;
        var amount_span = $(this).closest("tr").find(".amount");
        amount_span.text(amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
    });

    
    $(".qtt div input").keyup(function(event){
        $(this).val($(this).val().replace(/[^0-9]/gi,""));
        
        if ($(this).val() < 1 || $(this).val() > 999){
            alert("수량은 1 ~ 999 사이의 값으로 입력해 주세요.");
            
            $(this).val("1");
        }

        var price_span = $(this).closest("tr").find(".price");
		var price = price_span.attr("value");
		
        var quantity_span = $(this).closest("tr").find(".quantity");
		var quantity = quantity_span.val();
		
        var amount_span = $(this).closest("tr").find(".amount");
        var amount = price * quantity;
        
        amount_span.attr("value", amount);
        amount_span.text(amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
    });
    
    
    $(".modify_quantity").click(function(){
    	
    	var cart_id = $(this).attr("cart-id");
    	
        var quantity_span = $(this).closest("tr").find(".quantity");
        var quantity_before = quantity_span.attr("quantity");
		var quantity = Number(quantity_span.val());
		
		console.log(cart_id);
		console.log(quantity);
		 
		if(quantity_before == quantity) {
			alert("수량을 변경 후 눌러주세요.");
		} else {
			$.ajax({
				url: "/mall/cart",
				type: "PUT",
				contentType:"application/json; charset=utf-8",
				dataType: "text",
				cache : false,
				data : JSON.stringify({id: cart_id, quantity: quantity}),
				success: function(data) {
					location.reload();
				},
				error: function(error){
					alert("에러 발생");
					console.log(error);
				}
			}); 
		}
    });
    
    
    $("#delete_selected_items").click(function() {
    	var checkedList = new Array();
	    $(".ckbox:checked").each(function() {
	    	checkedList.push({id: this.value});
	    });
	    
	    if(confirm("선택하신 상품을 삭제하시겠습니까?") == true) {
		    deleteCartItems(checkedList);
		}
    });
});

function check(){
	if($('input:checkbox[name=id]:checked').length < 1 ){
		alert('주문하실 상품을 선택하세요.');
	} else {
		$('#form').submit();
	}
}


function deleteItem(cart_id) {
	var items = [{id: cart_id}];
	
	if(confirm("선택하신 상품을 삭제하시겠습니까?") == true) {
		deleteCartItems(items);
	}
};

function deleteCartItems(items) {
	$.ajax({
		url: "/mall/cart",
		type: "DELETE",
		contentType:"application/json; charset=utf-8",
		dataType: "text",
		cache : false,
		data : JSON.stringify(items),
		success: function(data) {
			location.reload();
		},
		error: function(error){
			alert("에러 발생");
			console.log(error);
		}
	});
}

</script>

<div id="subContent">
	<div id="pageCont" class="s-inner">
		<h2 id="subTitle">장바구니</h2>
		<c:if test="${empty list}">
			<div class="empty_cart">
				장바구니가 비어있습니다
				<p>
					<a class="cart_btn" href="/mall/product/list/dog">멍템 쇼핑</a>		
					<a class="cart_btn" href="/mall/product/list/cat">냥템 쇼핑</a>
					<c:if test="${loginUser eq null }">
						<a class="cart_btn" href="/login" style="background-color: black;">로그인하기</a>
					</c:if>
				</p>
			</div>
		</c:if>
		<c:if test="${not empty list}">

			<form action="/mall/pre-order/list" method="post" id="form">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" >
				<table class="cart_table">
					<colgroup>
						<col width="60px">
						<col width="120px">
						<col>
						<col width="140px">
						<col width="140px">
						<col width="140px">
						<col width="180px">
					</colgroup>
					<thead>
						<tr height=60px>
							<th><input type="checkbox" id="selectAll"></th>
							<th colspan="2">상품</th>
							<th>가격</th>
							<th>적립</th>
							<th>금액</th>
							<th>배송비</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${list eq null }">
							<tr>
								<td colspan="6">장바구니가 비었습니다.</td>
							</tr>
						</c:if>
						<c:forEach var="cart" items="${list }">
							<tr>
								<td><input type="checkbox" class="ckbox" name="id" value="${cart.id }"></td>
								<td class="cart_thumb">
									<a href="/mall/product/${cart.product.id }">
										<div product-id="${cart.product.id}">
											<c:if test="${cart.product.image1 eq null}"><img src="/resources/images/no_image.jpg"></c:if>
											<c:if test="${cart.product.image1 ne null}"><img src="/resources${cart.product.image1}"></c:if>
										</div>
									</a>
								</td>
								<td>
									<a href="/mall/product/${cart.product.id }">
									${cart.product.name }
									</a>
								</td>
								<td>
									<span class="price" value="${cart.product.price}">${cart.product.price }</span>
									<div class="qtt">
										<div>
											<p class="down"><span class="text_hidden">감소</span></p>
											<input type="text" class="quantity" value="${cart.quantity }" quantity="${cart.quantity }">
											<p class="up"><span class="text_hidden">증가</span></p>
										</div>
									</div>
									<button class="cart_btn modify_quantity" cart-id="${cart.id }">변경</button>
								</td>
								<td>
									<fmt:formatNumber value="${cart.product.price * 0.01}" />점
								</td>
								<td>
									<!-- 백엔드에서 합계 구하는 로직 아직 X -->
									<%-- ${cart.amount } --%>
									<span class="amount" value="${cart.product.price * cart.quantity }">${cart.product.price * cart.quantity }</span>원
									<i class="fas fa-times delete_btn" onclick="deleteItem(${cart.id})"></i>
									<%-- <div class="totalPrice">
										<p><span id="od_price"><fmt:formatNumber value="${pdt.price}" /></span> 원</p>
										<p><input type="hidden" value="${pdt.price}" id="price" onchange="comma(${pdt.price})"></p>
									</div> --%>
								</td>
								<td>
									<c:choose>
										<c:when test="${cart.product.deliveryKind eq '조건부 무료배송' }">
											<c:if test="${deliveryFee['conditonal'] eq 0}">
												무료배송
											</c:if>
											<c:if test="${deliveryFee['conditonal'] ne 0}">
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
					<tfoot>
						<tr>
							<td colspan="7">
								<table class="cart_total_table">
									<thead>
										<tr>
											<th>총 ${total['quantity']}개의 상품금액</th>
											<th>배송비</th>
											<th>합계</th>
											<th>적립예정 마일리지</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><fmt:formatNumber value="${total['price']}" />원</td>
											<td>
												<c:choose>
													<c:when test="${deliveryFee['total'] eq 0}">
														무료배송
													</c:when>
													<c:when test="${deliveryFee['conditional'] ne 0}">
														조건부 <fmt:formatNumber value="${deliveryFee['conditional']}" /> 원
													</c:when>
													<c:when test="${deliveryFee['conditional'] ne 0 && deliveryFee['charged'] ne 0 }">
														+
													</c:when>
													<c:when test="${deliveryFee['charged'] ne 0}">
														유료배송 상품 <fmt:formatNumber value="${deliveryFee['charged']}" /> 원
													</c:when>
												</c:choose>
												<c:if test="${deliveryFee['total'] ne 0}">
													<br><fmt:formatNumber value="${deliveryFee['total']}" />원
												</c:if>
											</td>
											<td><fmt:formatNumber value="${total['cost'] }" />원</td>
											<td><fmt:formatNumber value="${total['cost'] * 0.1}" />원</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</tfoot>
				</table>
				<div class="">
					<div style="float: left;">
						<input class="cart_btn" type="button" id="delete_selected_items" value="선택상품 삭제">
					</div>
					<div style="float: right;">
						<input class="cart_btn" type="submit" id="pre_order" value="선택상품 주문">
						<input class="cart_btn" type="submit" id="pre_order" value="전체상품 주문">
					</div>
				</div>
			</form>
		</c:if>	
	</div>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>