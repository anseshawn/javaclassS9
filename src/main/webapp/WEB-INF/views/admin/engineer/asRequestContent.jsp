<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
	  .btn:disabled {
			pointer-events: none;
			background-color: #0E2B5E;
			color: #fff;
		}
		.content th {
			background-color: #2A5C96;
			color: #fff; 
		}
	</style>
	<script>
		'use strict';
		$(function() {
			if('${vo.progress}'=='COMPLETE') $("#paymentBtn").prop("disabled",true);
		});
		
		function paymentCheck(){
			let message = "";
			let icon = "";
			$.ajax({
				url: "${ctp}/admin/engineer/asPaymentCheck",
				type: "post",
				data: {
					idx : ${vo.idx} 
				},
				success: function(res) {
					if(res != "0") {
						message = "입금을 확인했습니다.";
						icon = "success";
					}
					else {
						message = "결제 확인에 실패했습니다. 다시 시도하세요.";
						icon = "warning";
					}
					Swal.fire({
						html: message,
						icon: icon,
						confirmButtonText: '확인',
						customClass: {
		        	confirmButton : 'swal2-confirm‎',
		          popup : 'custom-swal-popup',
		          htmlContainer : 'custom-swal-text'
						}
					}).then(function(){
						location.reload();
					});
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
	<div class="row">
		<div class="col-lg-12 text-center"><h2>A/S 진행현황</h2></div>
	</div>
	<div class="row">
		<div class="col-lg-12"><div class="divider2 mx-auto my-4 text-center" style="width:50%;"></div></div>
	</div>
	<div class="row mb-3">
		<table class="table content table-bordered text-center">
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
				<td>${vo.machine}</td>
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
				<td colspan="3"><c:if test="${empty vo.detailNote}">-</c:if><c:if test="${!empty vo.detailNote}">${vo.detailNote}</c:if></td>
			</tr>
			<c:if test="${vo.progress=='PAYMENT' || vo.progress=='COMPLETE'}">
				<tr>
					<th>엔지니어 코멘트</th>
					<td colspan="3">${fn:replace(vo.comment,newLine,'<br/>')}</td>
				</tr>
			</c:if>
			<tr><td colspan="4" class="m-0 p-0"></td></tr>
		</table>
	</div>
	<hr/>
	<div class="row mb-3">
		<c:if test="${vo.progress=='PAYMENT' || vo.progress=='COMPLETE'}">
			<table class="table content table-bordered text-center mb-2" id="expendableUse">
				<tr>
					<th>소모품 사용 내역</th>
					<th>수량</th>
				</tr>
				<c:forEach var="ex" items="${expendables}" varStatus="st">
					<tr>
						<td>${ex}</td>
						<c:forEach var="qu" items="${quantities[st.index]}" varStatus="st2">
							<td>${qu}</td>
						</c:forEach>
					</tr>
				</c:forEach>
				<tr>
					<th>소모품 총액</th>
					<td><fmt:formatNumber value="${chargeVO.price}" pattern="#,###"/> 원</td>
				</tr>
				<tr>
					<th>출장비</th>
					<td><fmt:formatNumber value="${chargeVO.laborCharge}" pattern="#,###"/> 원</td>
				</tr>
				<tr>
					<th>총액(V.A.T.포함)</th>
					<td><fmt:formatNumber value="${chargeVO.totPrice}" pattern="#,###"/> 원</td>
				</tr>
				<tr>
					<th>결제 완료일</th>
					<td>
						${fn:substring(chargeVO.payDate,0,19)}
						<input type="button" onclick="paymentCheck()" id="paymentBtn" value="결제확인" class="btn btn-main btn-icon-sm ml-2"/>
					</td>
				</tr>
				<tr><td colspan="4" class="m-0 p-0"></td></tr>
			</table>
		</c:if>
	</div>
	<hr/>
	<div class="text-center mt-2">
		<a href="${ctp}/admin/engineer/asRequestList?pag=${pag}&pageSize=${pageSize}" class="btn btn-main btn-icon btn-round">목록으로</a>
	</div>
</div>
<p><br/></p>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.js"></script>
<script src="${ctp}/js/bootstrap-datepicker.ko.js"></script>
</body>
</html>