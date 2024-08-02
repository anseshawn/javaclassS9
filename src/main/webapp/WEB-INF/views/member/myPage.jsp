<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>내 정보 관리</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <style>
  	.title {
  		font-size: 1.6rem;
  		font-family: "Do Hyeon";
  		font-weight: 700;
  		color: black;
  	}
  	.col {
  		text-align: center;
  		font-size: 1.2rem;
  		margin-bottom: 0.5rem;
  		margin-top: 0.5rem;
  	}
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<p><br/></p>
<div class="container">
	<div class="row">
		<div class="col-lg-3">
			<div class="bodyLeft">
				<jsp:include page="/WEB-INF/views/include/aside.jsp" />
			</div>
		</div>
		<div class="col-lg-9">
			<div class="bodyRight">
				<p><br/></p>
				<div class="row justify-content-center mb-5">
					<div class="col-10 text-right">
						<div class="text right">최근 방문일 : ${fn:substring(vo.lastDate,0,19)}</div>
					</div>
				</div>
				<div class="row justify-content-center mb-2">
					<div class="col-10 text-left">
						<h3>알림</h3>
					</div>
				</div>
				<div class="row justify-content-center mb-5">
					<div class="col-10" style="border:1px solid #eee; color:black; padding:10px;">
						<div style="margin:10px;">
							새로운 메세지가 총 <a href="${ctp}/member/messageList"><span style="color:#E71825;font-weight:bold;">${messageCount}</span></a> 건 있습니다.<br/>
						</div>
						<div style="margin:10px;">
							견적 요청에 대한 응답이 <a href="${ctp}/member/estimateList"><span style="color:#E71825;font-weight:bold;">${estimateCount}</span></a> 건 있습니다.
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>