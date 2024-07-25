<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>결제하기</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<style>
		img {
	    max-width: 100%;
	    height: auto;
		}
	</style>
	<script>
		'use strict';
		
		function makePayment() {
			let message = "";
			let icon = "";
			$.ajax({
				url: "${ctp}/customer/requests/makePayment",
				type: "post",
				data: {
					asIdx : ${chargeVO.asIdx} 
				},
				success: function(res) {
					if(res != "0") {
						message = "결제가 완료되었습니다.";
						icon = "success";
					}
					else {
						message = "결제에 실패했습니다. 다시 시도해주세요.";
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
						opener.location.reload();
						window.close();
					});
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
		
		function wClose(){
			window.close();
		}
	</script>
</head>
<body id="top">
<p><br/></p>
<div class="container">
	<table class="table text-center">
		<tr>
			<td>결제 방식</td>
			<td>
				<div class="form-check form-check-inline">
					<input class="form-check-input" type="radio" name="payment" id="payment1" checked>
				  <label class="form-check-label" for="payment1">
				    계좌이체
				  </label>
				</div>
				<div class="form-check form-check-inline">
					<input class="form-check-input" type="radio" name="payment" id="payment2">
				  <label class="form-check-label" for="payment2">
				    카드
				  </label>
			  </div>
			</td>
		</tr>
		<tr>
			<td>결제 총액</td>
			<td><fmt:formatNumber value="${chargeVO.totPrice}" pattern="#,###"/> 원</td>
		</tr>
		<tr>
			<td colspan="2">
				<input type="button" onclick="makePayment()" value="결제하기" class="btn btn-main btn-icon-md"/>
				<input type="button" onclick="wClose()" value="취소" class="btn btn-main-3 btn-icon-md"/>
			</td>
		</tr>
	</table>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
</body>
</html>