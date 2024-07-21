<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자 - A/S 현황 조회</title>
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
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
		
		function searchValue() {
			if($("#part").val()=='progress') {
				$("#progressSelect").show();
				$("#searchString").hide();
			}
			else {
				$("#progressSelect").hide();
				$("#searchString").show();				
			}
		}
		
		function asRequestSearch() {
			let part = $("part").val();
			let searchString = $("searchString").val();
			if($("#part").val() != 'progress' && searchString.trim()=="") {
				alert("검색어를 입력하세요.");
				return false;
			}
			location.href="${ctp}/admin/engineer/asRequestList?part="+part+"&searchString="+searchString;
		}
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
	<div class="row">
		<div class="col-lg-12 text-center"><h2>전체 A/S 진행현황 (총 ${fn:length(vos)} 건)</h2></div>
	</div>
	<div class="row">
		<div class="col-lg-12"><div class="divider2 mx-auto my-4 text-center" style="width:50%;"></div></div>
	</div>
	<div class="row mb-2">
		<div class="col-md-3">
			<div class="input-group">
				<select name="part" id="part" class="custom-select" onchange="searchValue()" style="height:36px;">
					<option value="">분류</option>
					<option value="engineerName" ${pageVO.part=='e.name'? 'selected' : ''}>담당자</option>
					<option value="asName" ${pageVO.part=='r.asName'? 'selected' : ''}>신청자명(회사명)</option>
					<option value="progress" ${pageVO.part=='progress'? 'selected' : ''}>진행상황</option>
				</select>
				<select name="progressSelect" id="progressSelect" class="custom-select" style="display:none;">
					<option>진행상황별 보기</option>
					<option value="">전체</option>
					<option value="REGIST" ${pageVO.searchString=='REGIST' ? 'selected' : ''}>신청</option>
					<option value="ACCEPT" ${pageVO.searchString=='ACCEPT' ? 'selected' : ''}>접수완료</option>
					<option value="PROGRESS" ${pageVO.searchString=='PROGRESS' ? 'selected' : ''}>진행중</option>
					<option value="PAYMENT" ${pageVO.searchString=='PAYMENT' ? 'selected' : ''}>입금대기</option>
					<option value="COMPLETE" ${pageVO.searchString=='COMPLETE' ? 'selected' : ''}>진행완료</option>
				</select>
				<input type="text" name="searchString" id="searchString" class="form-control" style="height:36px;"/>
				<div class="input-group-append">
					<a href="javascript:asRequestSearch()" class="btn btn-main btn-icon-md btn-round" style="padding:0.3rem 0.5rem;">검색<i class="fa-solid fa-magnifying-glass ml-1"></i></a>
				</div>
			</div>
		</div>
		<div class="col-md-3">
			<input type="button" onclick="location.href='${ctp}/admin/engineer/asRequestList';" value="전체보기" class="btn btn-main-2 btn-icon-md btn-round-full" style="padding:0.3rem 0.5rem;"/>
		</div>
		<div class="col-md-4 offset-md-2 text-right">
			<form name="dateForm" method="post">
				<div class="col ml-auto">
					<div class="row narrow-row align-items-center">
						<div class="input-group">
								<input type="text" id="datePicker1" name="startSearchDate" class="datePicker form-control">
							<div class="col-auto d-flex align-itmes-center px-0">~</div>
								<input type="text" id="datePicker2" name="endSearchDate" class="datePicker form-control" value="<%=java.time.LocalDate.now() %>">
							<div class="input-group-append">
								<input type="submit" value="검색" class="btn btn-main btn-icon-md btn-round"/>
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<div class="row mb-3">
		<table class="table table-hover text-center">
			<tr style="background:#003675; color:#fff;">
				<th>신청번호</th>
				<th>기기명</th>
				<th>신청자명</th>
				<th>담당자</th>
				<th>신청일 / 완료일</th>
				<th>진행현황</th>
				<th>자세히보기</th>
			</tr>
			<c:forEach var="vo" items="${vos}">
				<tr>
					<td>${vo.idx}</td>
					<td>${vo.machine}</td>
					<td>${vo.asName}</td>
					<td>${vo.engineerName}</td>
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
					<td><a href="${ctp}/admin/engineer/asRequestContent?idx=${vo.idx}&search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}" class="btn btn-main btn-icon-sm btn-round">GO<i class="fa-solid fa-chevron-right ml-2"></i></a></td>
				</tr>
			</c:forEach>
		</table>
	</div>
	<!-- 블록페이지 시작 -->	
  <div class="row mt-5">
    <div class="col-lg-9">
      <nav class="pagination py-2 d-inline-block">
        <div class="nav-links">
          <c:if test="${pageVO.pag > 1}"><a class="page-numbers" href="asRequestList?pag=1&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-left"></i></a></c:if>
          <c:if test="${pageVO.curBlock > 0}"><a class="page-numbers" href="asRequestList?pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-left"></i></a></c:if>
					<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
						<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><span aria-current="page" class="page-numbers current">${i}</span></c:if>
						<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><a class="page-numbers" href="asRequestList?pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></c:if>
					</c:forEach>
					<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><a class="page-numbers" href="asRequestList?pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-right"></i></a></c:if>
					<c:if test="${pageVO.pag < pageVO.totPage}"><a class="page-numbers" href="asRequestList?pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-right"></i></a></c:if>
      	</div>
    	</nav>
		</div>
	</div>
	<!-- 블록페이지 끝 -->
	
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.js"></script>
<script src="${ctp}/js/bootstrap-datepicker.ko.js"></script>
</body>
</html>