<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>마이페이지 - 접수현황 조회</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<link rel="stylesheet" href="${ctp}/css/bootstrap-datepicker.css">
	<style>
	  .narrow-row .col {
	    padding-left: 2px;
	    padding-right: 2px;
	  }
	</style>
	<script>
		'use strict';
		$(function() {	
			$('.datePicker').datepicker({
			    format: "yyyy-mm-dd",	//데이터 포맷 형식(yyyy : 년 mm : 월 dd : 일 )
			    startDate: '-12m',	//달력에서 선택 할 수 있는 가장 빠른 날짜. 이전으로는 선택 불가능 ( d : 일 m : 달 y : 년 w : 주)
			    endDate: '-0d',	//달력에서 선택 할 수 있는 가장 느린 날짜. 이후로 선택 불가 ( d : 일 m : 달 y : 년 w : 주)
			    autoclose : true,
			    disableTouchKeyboard : false,
			    immediateUpdates: true, 
			    multidate : false, 
			    multidateSeparator :"~",
			    templates : {
			        leftArrow: '&laquo;',
			        rightArrow: '&raquo;'
			    }, 
			    showWeekDays : true,
			    todayHighlight : true , 
			    toggleActive : true,
			    weekStart : 0 , 
			    language : "ko"
			});
			// datepicker1에 한달 전 날짜 부여
      let now = new Date();
      let year = now.getFullYear();
      let month = now.getMonth();
      if(month.toString().length==1) month = "0"+month;
      let date = now.getDate();
      if(date.toString().length==1) date = "0"+date;
      let monthBefore = year+"-"+month+"-"+date;
      document.getElementById("datePicker1").value = monthBefore;
      
		});
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<div class="container">
	<div class="row">
		<div class="col-lg-3">
			<div class="bodyLeft">
				<jsp:include page="/WEB-INF/views/include/engineer_aside.jsp" />
			</div>
		</div>
		<div class="col-lg-9">
			<section class="section blog-wrap">
				<form name="dateForm" method="post">
					<div class="row mb-3">
						<div class="col-2">
							<a href="${ctp}/engineer/asRequestList" class="btn btn-main-3 btn-icon-md btn-round">전체보기</a>
						</div>
						<div class="col ml-auto">
							<div class="row narrow-row align-items-center">
								<div class="col-2 offset-6">
									<input type="text" id="datePicker1" name="startSearchDate" class="datePicker form-control">
								</div>
								<div class="col-auto d-flex align-itmes-center px-0">~</div>
								<div class="col-2">
									<input type="text" id="datePicker2" name="endSearchDate" class="datePicker form-control" value="<%=java.time.LocalDate.now() %>">
								</div>
								<div class="col-1">
									<input type="submit" value="검색" class="btn btn-main btn-icon-md btn-round"/>
								</div>
							</div>
						</div>
					</div>
				</form>
				<div class="row mb-3">
					<table class="table table-hover text-center">
						<tr style="background:#003675; color:#fff;">
							<th>신청번호</th>
							<th>기기명</th>
							<th>신청자명</th>
							<th>신청일 / 완료일</th>
							<th>진행현황</th>
							<th>자세히보기</th>
						</tr>
						<c:forEach var="vo" items="${vos}">
							<tr>
								<td>${vo.idx}</td>
								<td>${vo.machine}</td>
								<td>${vo.asName}</td>
								<td>
									<c:if test="${empty vo.endDate}">
										<c:set var="requestDate" value="${fn:substring(vo.requestDate, 0, 10)}"/>
										${requestDate}
									</c:if>
									<c:if test="${!empty vo.endDate}">
										<c:set var="endDate" value="${fn:substring(vo.endDate, 0, 10)}"/>
										<font color="#717171">${endDate}</font>
									</c:if>
								</td>
								<td>
									<c:if test="${vo.progress == 'REGIST'}">신청완료</c:if>
									<c:if test="${vo.progress == 'ACCEPT'}">접수완료</c:if>
									<c:if test="${vo.progress == 'PROGRESS'}">진행중</c:if>
									<c:if test="${vo.progress == 'PAYMENT'}"><font color="#E71825">입금대기</font></c:if>
									<c:if test="${vo.progress == 'COMPLETE'}">진행완료</c:if>
								</td>
								<td><a href="${ctp}/engineer/asRequestContent?idx=${vo.idx}&search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}" class="btn btn-main btn-icon-sm btn-round">GO<i class="fa-solid fa-chevron-right ml-2"></i></a></td>
							</tr>
						</c:forEach>
					</table>
				</div>
				<!-- 블록페이지 시작 -->	
				<div class="text-center">
					<ul class="pagination justify-content-center" style="margin:20px 0">
						<c:if test="${pageVO.pag > 1}"><li class="page-item"><a class="page-link" href="asRequestContent?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=1&pageSize=${pageVO.pageSize}">처음</a></li></c:if>
						<c:if test="${pageVO.curBlock > 0}"><li class="page-item"><a class="page-link" href="asRequestContent?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">이전블록</a></li></c:if>
						<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
							<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><li class="page-item active"><a class="page-link" href="asRequestContent?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
							<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><li class="page-item"><a class="page-link" href="asRequestContent?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
						</c:forEach>
						<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><li class="page-item"><a class="page-link" href="asRequestContent?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">다음블록</a></li></c:if>
						<c:if test="${pageVO.pag < pageVO.totPage}"><li class="page-item"><a class="page-link" href="asRequestContent?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}">끝</a></li></c:if>
					</ul>
				</div>
				<!-- 블록페이지 끝 -->
			</section>
		</div>
	</div>
</div>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.js"></script>
<script src="${ctp}/js/bootstrap-datepicker.ko.js"></script>
</body>
</html>