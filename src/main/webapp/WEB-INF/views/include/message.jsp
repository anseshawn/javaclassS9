<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>message</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<script>
		'use strict';
		
		let msg = '${msg}';
		let url = '${ctp}/${url}';
		
		/*
		$(function(){
			Swal.fire({
				html: msg,
				confirmButtonText: '확인',
				customClass: {
	    	confirmButton : 'swal2-confirm‎',
	      popup : 'custom-swal-popup',
	      htmlContainer : 'custom-swal-text'
				}
			});
		});
		*/
		alert(msg);
		location.href = url;
	</script>
</head>
<body>
<p><br/></p>
<div class="container">
	
</div>
<p><br/></p>
</body>
</html>