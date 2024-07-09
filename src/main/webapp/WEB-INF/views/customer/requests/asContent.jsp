<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>접수현황 확인</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<link rel="stylesheet" href="${ctp}/css/bootstrap-datepicker.css">
	<style>
		th {
			background-color: #CDD7E4; 
		}
	</style>
	<script>
		'use strict';
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<div class="container">
	<section class="page-title bg-3">
	  <div class="overlay"></div>
	  <div class="container">
	    <div class="row">
	      <div class="col-md-12">
	        <div class="block text-center">
	          <h1 class="text-capitalize mb-5 text-lg">나의 접수현황</h1>
	        </div>
	      </div>
	    </div>
	  </div>
	</section>

	<section class="section blog-wrap">
		<div class="container">
			<table class="table table-bordered text-center">
				<tr>
					<th>접수번호</th>
					<td>${vo.idx}</td>
					<th>담당자</th>
					<td>${vo.engineerName}</td>
				</tr>
				<tr>
					<th>신청일</th>
					<c:set var="requestDate" value="${fn:substring(vo.requestDate,0,10)}"/>
					<td>${requestDate}</td>
					<th>기기명</th>
					<td>${vo.instrument}</td>
				</tr>
				<c:if test="${vo.progress!='REGIST'}"> <!-- 접수 완료되어 asDate를 엔지니어가 수정하면 보이게 -->
					<c:set var="asDate" value="${fn:substring(vo.asDate,0,10)}"/>
					<tr>
						<th>출장 진행일</th>
						<td colspan="3">${asDate}</td>
					</tr>
				</c:if>
				<tr>
					<th>진행 상황</th>
					<td colspan="3">
						${progress}
						<c:if test="${progress=='신청완료'}"><font size="2"><br/>엔지니어가 신청을 확인하여 날짜를 확정하면 접수완료 상태로 변경됩니다.</font></c:if>
					</td>
				</tr>
				<tr>
					<th>증상</th>
					<td colspan="3">${vo.detailNote}</td>
				</tr>
				<c:if test="${vo.progress=='PAYMENT' || vo.progress=='COMPLETE'}">
					<tr>
						<th>엔지니어 코멘트</th>
						<td colspan="3">${vo.comment}</td>
					</tr>
				</c:if>
				<tr><td colspan="4" class="m-0 p-0"></td></tr>
			</table>
			<div class="text-right mt-2">
				<a href="${ctp}/customer/requests/asProgress?pag=${pag}&pageSize=${pageSize}" class="btn btn-main-3 btn-icon btn-round">목록으로</a>
			</div>
		</div>
	</section>
</div>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.js"></script>
<script src="${ctp}/js/bootstrap-datepicker.ko.js"></script>
</body>
</html>