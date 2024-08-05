<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>500</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
	<h3>500페이지 미리보기</h3>
	<div class="text-center">
		<img src="${ctp}/images/500.jpg" width="70%"/>
		<div class="mt-4 mb-4">
			<h3>요청하신 내용을 처리할 수 없습니다.</h3>
			<div>이용에 불편을 드려 죄송합니다. 빠른 시일 내에 복구 되도록 하겠습니다.</div>
			<div>
				<a href="${ctp}/" class="btn btn-main-2 btn-round-full mt-2 mb-2">돌아가기</a>
			</div>
		</div>
	</div>
</div>
<p><br/></p>
</body>
</html>