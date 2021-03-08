<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://sargue.net/jsptags/time" prefix="javatime" %>
<%@ include file="/WEB-INF/views/admin/include/header.jsp" %>
<script>
	$(document).ready(function() {
		document.title += ' - 공지사항 등록';
	});
	
	$(function() {
		/* 기간 설정 관련 */
		$("#startDate").datepicker({
			format: "yyyy-mm-dd",
			endDate: '0d',
			language: "ko",
			todayBtn: "linked",
			clearBtn: true,
			autoClose: true,
		}).on("changeDate", function(selected) {
			var startDate = new Date(selected.date.valueOf());
			$("#endDate").datepicker("setStartDate", startDate);
		}).on("clearDate", function(selected) {
			$("#endDate").datepicker("setStartDate", null);
		});

		$("#endDate").datepicker({
			format: "yyyy-mm-dd",
			endDate: '0d',
			language: "ko",
			todayBtn: "linked",
			clearBtn: true,
			autoClose: true
		}).on("changeDate", function(selected) {
			var endDate = new Date(selected.date.valueOf());
			$("#startDate").datepicker("setEndDate", endDate);
		}).on("clearDate", function(selected) {
			$("#startDate").datepicker("setEndDate", null);
		});
		
		$("#endDate").datepicker("update", dateToString(new Date()));
		
		$("select[name=noticeYn]").change(function(){
			document.searchForm.submit();
		});
		
		$(".dateBtn").not("#aMonthBtn").click(function() {
			setDateValue($(this).val() - 1);
		});
		
		$("#allBtn").click(function() {
			$("#startDate").datepicker('setDate', null);
			$("#endDate").datepicker('setDate', null);
		});
		
		$("#aMonthBtn").click(function() {
			var today = new Date();
			var wantDate = new Date();
			wantDate.setMonth(wantDate.getMonth() - 1);
			wantDate.setDate(wantDate.getDate() + 1);
			
			$("#endDate").datepicker("update", dateToString(today));
			$("#startDate").datepicker("update", dateToString(wantDate));
		});
		
		$("select[name=perPageNum]").change(function(){
			document.searchForm.submit();
		});
		
		$("#searchBtn").click(function(e) {
			if($("select[name=searchType]").val() == undefined || $("input[name=keyword]").val() == "") {
				e.preventDefault();
			}
		});
		
	})
	
	function setFilteringPaging() {
		
		var thisUrlStr = window.location.href;
		var thisUrl = new URL(thisUrlStr);

		console.log("setFilteringPaging!");
		console.log(thisUrlStr);
		
		var perPageNum = thisUrl.searchParams.get("perPageNum");
	}
</script>
<div class="card shadow mb-4" style="width: 800px;">
	<div class="card-header py-2">
		<h6 class=" font-weight-bold text-primary" style="font-size: 1.3em;">
			<div class="mt-2 float-left">
             	공지사항 등록
            </div>
			<div class="float-right">
				<button class="btn btn-sm btn-secondary" name="clearBtn" onclick="setClear()">초기화</button>
				<a href="/admin/notice/list" class="btn btn-sm btn-primary" id="toList"><span class="text">목록</span></a>
			</div>
		</h6>
		<!-- <h6 class="m-1 font-weight-bold text-primary" style="line-height: 16px; font-size: 1.3em">
		
			예약 내역
			<a href="#" id="deleteSelected"class="btn btn-danger btn-sm" style="float: right;"><span class="text">삭제</span></a>
			<a href="#" id="addNew" class="btn btn-success btn-sm" style="float: right;  margin-right: 10px;"><span class="text">등록</span></a>
			<a href="#" id="selectAll" class="btn btn-secondary btn-sm" style="float: right;  margin-right: 10px;"><span class="text">전체선택</span></a>
			<a href="#" id="deselect" class="btn btn-outline-secondary btn-sm" style="float: right;  margin-right: 10px;"><span class="text">선택해제</span></a>
		</h6> -->
	</div>
	<!-- card-body -->
	<div class="card-body p-5">
		<form autocomplete="off" action="/admin/notice/write" method="post">
			<input type="hidden" name="guestId" value="">
			<input type="hidden" name="bookNo" value="">
			<div class="form-group row">
				<label for="inputEmail3" class="col-3 col-form-label font-weight-bold">제목</label>
				<div class="col-9">
					<input type="text" class="form-control" id="guestInput" name="title"><br>
					<div class="ml-4">
						<input type="checkbox" class="form-check-input" value="y" name="noticeYn"><label class="form-check-label" for="noticeYn">중요공지(상단 노출 여부)</label>
					</div>
				</div>
			</div>
			<div class="spacing"></div>
			<div class="form-group row">
				<label for="inputEmail3" class="col-3 col-form-label font-weight-bold">내용</label>
				<div class="col-9">
					<textarea class="form-control" name="contents"></textarea>
				</div>
			</div>
			
			<div class="form-group row">
				<label for="inputEmail3" class="col-3 col-form-label font-weight-bold">첨부파일</label>
				<div class="col-9 input-group mb-3">
					<input type="file" class="form-control" id="inputFile" name="noticeFile">
				</div>
			</div>
			
			<div class="form-group row">
				<div class="col-sm" style="text-align: right;">
					<button type="button" class="btn btn-secondary" name="clearBtn" onclick="setClear()">초기화</button>
					<input type="submit" class="btn btn-primary" id="regBtn" value="등록">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				</div>
			</div>
		</form>
	</div>
	<!-- cardBody-->
	<div class="card-footer">
		<div class="dataTables_info" id="dataTable_info" role="status" aria-live="polite">
			<c:choose>
				<c:when test="${empty list }">
					전체 0개		
				</c:when>
				<c:otherwise>
					전체 ${pageMaker.totalCount }개 중 ${pageMaker.cri.pageStart + 1} - ${pageMaker.cri.page >= pageMaker.lastPage ? pageMaker.cri.pageStart + pageMaker.totalCount%pageMaker.cri.perPageNum : pageMaker.cri.pageStart + pageMaker.cri.perPageNum}
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</div>

<%@ include file="/WEB-INF/views/admin/include/footer.jsp" %>