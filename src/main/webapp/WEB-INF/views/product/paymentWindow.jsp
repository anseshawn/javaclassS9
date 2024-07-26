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
		
		function wClose(){
			window.close();
		}
	</script>
</head>
<body id="top">
<p><br/></p>
<div class="container">
	<form name="myform" method="post">
		<table class="table">
			<tr>
				<th>구매자 이름</th>
				<td><input type="text" name="buyer_name" value="${vo.co_name}" class="form-control" required readonly/></td>
			</tr>
			<tr>
				<th>이메일</th>
				<td><input type="text" name="buyer_email" value="${vo.email}" class="form-control" required readonly/></td>
			</tr>
			<tr>
				<th>연락처</th>
				<td><input type="text" name="buyer_tel" value="010-2741-8937" class="form-control" required/></td>
			</tr>
			<tr>
				<th>주소</th>
				<td>
					<input type="text" name="buyer_addr" value="충북 청주시 서원구 사직대로 109 그린컴퓨터" class="form-control" required/>
				</td>
			</tr>
			<tr>
				<th>우편번호</th>
				<td><input type="text" name="buyer_postcode" value="361-831" class="form-control" required/></td>
			</tr>
			<tr>
				<td>결제 총액</td>
				<td><fmt:formatNumber value="${vo.totPrice}" pattern="#,###"/> 원</td>
			</tr>
			<tr>
				<td colspan="2" class="text-right">
					<input type="submit" value="결제하기" class="btn btn-main btn-icon-md mr-2"/>
					<input type="button" onclick="wClose()" value="취소" class="btn btn-main-3 btn-icon-md"/>
				</td>
			</tr>
		</table>
		<input type="hidden" name="amount" value="${vo.totPrice}"/>
		<input type="hidden" name="saleIdx" value="${vo.saleIdx}"/>
	</form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
</body>
</html>