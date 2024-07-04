<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
  <script>
  	'use strict';
  	function mypage(part){
  		// 선택값에 따라서 display:none 을 보였다 안보였다하는..?
  		$(".context").hide();
  		$("#context"+part).show();
  	}
 	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<p><br/></p>
<div class="container">
<div class="row">
	<div class="col-lg-3">
		<div class="sidebar-wrap pl-lg-4 mt-5 mt-lg-0">
			<div class="sidebar-widget search mb-3 ">
					<h2 class="text-center">My Page</h2>
					<div class="divider" style="width:100%;"></div>
					<div class="text-right">아이디: ${sMid}</div>
					<br/>
				<div class="row">
					<div class="col">
						<div class="title text-center">내 정보 관리</div>
					</div>
				</div>
				<div class="divider2 mx-auto my-2"></div>
				<div class="row">
					<div class="col"><a href="javascript:mypage(1)"> 정보 수정</a></div>
				</div>
				<div class="row">
					<div class="col"><a href="#">문의내역</a></div>
				</div>
				<div class="row mt-3">
					<div class="col">
						<div class="title text-center">내 활동내역</div>
					</div>
				</div>
				<div class="divider2 mx-auto my-2"></div>
				<div class="row">
					<div class="col"><a href="javascript:mypage(2)">게시글 확인</a></div>
				</div>
				<div class="row">
					<div class="col"><a href="#">받은 메세지</a></div>
				</div>
			</div>
			</div>
	</div>
	<div class="col-lg-9">
		<div class="context" id="context1" style="display:none;">
			<jsp:include page='/WEB-INF/views/member/memberUpdate.jsp' />
		</div>
		<div class="context" id="context2" style="display:none;">
			<%-- <jsp:include page='/mypage/checkBoard.jsp' /> --%>
		</div>
	</div>
</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>