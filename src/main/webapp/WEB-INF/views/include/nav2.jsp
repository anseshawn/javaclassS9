<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
	// 카카오 로그아웃
	window.Kakao.init("72ddec57bb46287e893efd27beb4a21e");
	function kakaoLogout() {
	  const accessToken = Kakao.Auth.getAccessToken();
	  if(accessToken) {
		  Kakao.Auth.logout(function() {
			  window.location.href = "https://kauth.kakao.com/oauth/logout?client_id=72ddec57bb46287e893efd27beb4a21e&logout_redirect_uri=http://localhost:9090/javaclassS9/member/memberLogout/customer";
		  });
	  }
	}
</script>
<nav class="navbar navbar-expand-lg navigation" id="navbar">
	<div class="container">
		<a class="navbar-brand mr-auto" href="${ctp}/customer/cmain"><img src="${ctp}/images/logo.png" alt="" class="img-fluid"></a> &nbsp;&nbsp;
		<a class="navbar-brand mr-auto btn btn-icon-sm btn-main" href="${ctp}/" title="메인 홈페이지 돌아가기" target="_blank">메인 홈페이지<i class="icofont-location-arrow ml-2"></i></a>

		<button class="navbar-toggler collapsed" type="button" data-toggle="collapse" data-target="#navbarmain" aria-controls="navbarmain" aria-expanded="false" aria-label="Toggle navigation">
			<span class="icofont-navigation-menu"></span>
	  </button>
  
	  <div class="collapse navbar-collapse" id="navbarmain">
		<ul class="navbar-nav ml-auto">
		  <li class="nav-item active">
			<a class="nav-link" href="${ctp}/customer/cmain">Home</a>
		  </li>
		  
		  <c:if test="${!empty sLevel}">
				<li class="nav-item dropdown">
				<a class="nav-link dropdown-toggle" href="#" id="dropdown02" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">온라인신청<i class="icofont-thin-down"></i></a>
				<ul class="dropdown-menu" aria-labelledby="dropdown02">
					<li><a class="dropdown-item" href="${ctp}/product/productEstimate">장비 견적요청</a></li>
					<!-- <li><a class="dropdown-item" href="#">교정 견적요청</a></li> -->
					<li><a class="dropdown-item" href="${ctp}/customer/requests/asRequest">A/S 신청</a></li>
				</ul>
				</li>
			</c:if>
		  	
			<li class="nav-item dropdown">
			<a class="nav-link dropdown-toggle" href="#" id="dropdown03" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">회원게시판<i class="icofont-thin-down"></i></a>
			<ul class="dropdown-menu" aria-labelledby="dropdown03">
				<li><a class="dropdown-item" href="${ctp}/customer/board/questionBoardList">Q&A</a></li>
				<li><a class="dropdown-item" href="${ctp}/customer/board/freeBoardList">자유게시판</a></li>
				<li><a class="dropdown-item" href="${ctp}/customer/board/recruitBoardList">채용공고</a></li>
			</ul>
			</li>
			<li class="nav-item"><a class="nav-link" href="${ctp}/service/serviceMain">고객서비스</a></li>
			<c:if test="${empty sLevel}">
				<li class="nav-item"><a class="nav-link" href="${ctp}/member/memberLogin/customer">로그인</a></li>
				<li class="nav-item"><a class="nav-link" href="${ctp}/member/memberJoin">회원가입</a></li>
			</c:if>
			<c:if test="${!empty sLevel}">
				<c:if test="${!empty kakaoLogin}">
					<li class="nav-item"><a class="nav-link" href="javascript:kakaoLogout()">로그아웃</a></li>
				</c:if>
				<c:if test="${empty kakaoLogin}">
					<li class="nav-item"><a class="nav-link" href="${ctp}/member/memberLogout/customer">로그아웃</a></li>
				</c:if>
				<c:if test="${sLevel > 1 && sLevel <=3}">
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" href="#" id="dropdown04" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">마이페이지<i class="icofont-thin-down"></i></a>
							<ul class="dropdown-menu" aria-labelledby="dropdown04">
								<li><a class="dropdown-item" href="${ctp}/member/myPage">내정보 관리</a></li>
								<li><a class="dropdown-item" href="${ctp}/customer/requests/asProgress">신청 현황</a></li>
								<li><a class="dropdown-item" href="${ctp}/member/pwdChange">비밀번호 변경</a></li>
							</ul>
					</li>
				</c:if>
				<c:if test="${sLevel==1}">
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" href="#" id="dropdown04" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">마이페이지<i class="icofont-thin-down"></i></a>
						<ul class="dropdown-menu" aria-labelledby="dropdown04">
							<li><a class="dropdown-item" href="${ctp}/engineer/myPageMain">내정보 관리</a></li>
							<li><a class="dropdown-item" href="${ctp}/engineer/schedule">일정관리</a></li>
							<li><a class="dropdown-item" href="${ctp}/engineer/pwdChange">비밀번호 변경</a></li>
						</ul>
					</li>
				</c:if>
				<c:if test="${sLevel==0}"><li class="nav-item"><a class="nav-link" href="${ctp}/admin/adminMain">관리자모드</a></li></c:if>
			</c:if>
		</ul>
	  </div>
	</div>
</nav>