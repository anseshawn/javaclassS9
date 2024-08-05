<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>NullPointer</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<p><br/></p>
<div class="container">
	<div class="text-center">
		<img src="${ctp}/images/nullPointer.jpg" width="70%"/>
		<div class="mt-4 mb-4">
			<h3>잘못된 접근입니다.</h3>
			<div>현재 시스템 정비 중입니다. 이용에 불편을 드려서 죄송합니다.</div>
			<div>
				<a href="${ctp}/" class="btn btn-main-2 btn-round-full mt-2 mb-2">돌아가기</a>
			</div>
		</div>
	</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>