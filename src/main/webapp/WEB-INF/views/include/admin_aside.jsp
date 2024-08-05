<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<style>

	ul, li {
		margin: 0;
		padding: 0;
		list-style: none;
	}
  .ani-navbar ul ul {
	  display: none;
	  position: absolute;
	  top: 30%;
	  left: 100%;
	  background-color: rgba(0, 43, 94, 0.7); /* 70% 투명화 */
	  /* background-color: rgba(42, 92, 150, 0.7); 네비색이랑 같이 */
	  color: white;
	  width: 200px;
	  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	  z-index: 10;
  }
	.ani-navbar > ul > li {
		position: relative;
	}
  .ani-navbar > ul > li:hover > ul {
    display: block;
  }
	
	.ani-navbar {
		position: fixed;
		top: 0;
		left: 0;
		width: 200px;
		height: 100%;
		padding: 25px;
		background-color: #2A5C96;
		color: white;
		z-index: 5;
		text-align: center;
		transform: translateX(-150px);
		transition: all 1s;
	}
	
	.ani-navbar:hover {
		transform: translateX(0px);
		transition: all 0.5s;
	}
	
	.ani-navbar-menu {
		display: flex;
		align-items: center;
		padding: 15px;
		position: relative;
	}
	
	.ani-navbar-menu a {
		margin: 0;
		margin-left: 10px;
		color: white;
	}
	.ani-navbar-menu p {
		margin: 0;
		margin-left: 10px;
	}
	
	.ani-navbar i {
		transition: all 0.5s;
		transform: translateX(125px);
	}
	
	.ani-navbar:hover i {
		transform: translateX(0px);
	}
	
	.dropdown-content a {
		display: block;
		padding: 10px;
		color: white;
		text-decoration: none;
	}

	.dropdown-content a:hover {
		 background-color: rgba(255, 255, 255, 0.3); /* 70% 투명화된 흰색 배경 */
	}
	
	.dropdown-btn:hover + .dropdown-content {
	    display: block;
	}
	.ani-navbar:hover .dropdown-content {
	    display: none;
	}
	.ani-navbar:hover .dropdown:hover .dropdown-content {
	    display: block;
	}
	
	.divider2 {
	  width: 100%;
	}
</style>
<nav class="ani-navbar">
	<ul>
	  <li class="dropdown">
			<div class="ani-navbar-menu ani-navbar-menu__icon">
			  <i class="fa-solid fa-house"></i>
				<a href="${ctp}/admin/adminMain">Home</a>
			</div>
		</li>
		<li class="dropdown">
			<div class="ani-navbar-menu ani-navbar-menu__icon">
			 	<i class="fa-solid fa-headphones"></i><a href="#">문의 내역</a>
				<ul class="dropdown-content">
			  	<li><div class="divider2"></div></li>
				  <li><a href="${ctp}/admin/consulting/consultingList">문의 내역</a></li>
				  <li><a href="${ctp}/admin/consulting/realTimeChat">1:1문의</a></li>
			  </ul>
			</div>
		</li>
		<li class="dropdown">
		<div class="ani-navbar-menu ani-navbar-menu__icon">
		  <i class="fa-solid fa-list"></i><a href="#">공지사항</a>
		  <ul class="dropdown-content">
		  	<li><div class="divider2"></div></li>
			  <li><a href="${ctp}/admin/notice/noticeInput">공지사항 등록하기</a></li>
			  <li><a href="${ctp}/admin/notice/noticeList">목록보기</a></li>
			  <li><a href="${ctp}/admin/notice/faqList">FAQ 관리</a></li>
		  </ul>
		</div>
		</li>
		<li class="dropdown">
		<div class="ani-navbar-menu ani-navbar-menu__icon">
		  <i class="fa-solid fa-flag"></i><a href="#">신고 내역</a>
		  <ul class="dropdown-content">
		  	<li><div class="divider2"></div></li>
			  <li><a href="${ctp}/admin/report/reportBoardList">신고 게시글</a></li>
			  <li><a href="${ctp}/admin/report/reportMemberList">회원 리포트</a></li>
		  </ul>
		</div>
		</li>
		<li class="dropdown">
			<div class="ani-navbar-menu ani-navbar-menu__icon">
			  <i class="fa-solid fa-users"></i><a href="#">회원 관리</a>
			  <ul class="dropdown-content">
			  	<li><div class="divider2"></div></li>
				  <li><a href="${ctp}/admin/member/memberList">회원 리스트</a></li>
				  <li><a href="${ctp}/admin/emailInput/all">메일 전송</a></li>
				  <li><a href="${ctp}/admin/member/chating">유저채팅방</a></li>
			  </ul>
			</div>
		</li>
		<li class="dropdown">
			<div class="ani-navbar-menu ani-navbar-menu__icon">
			  <i class="fa-solid fa-user-plus"></i><a href="javascript:void(0)">사원 관리</a>
			  <ul class="dropdown-content">
			  	<li><div class="divider2"></div></li>
				  <li><a href="${ctp}/admin/engineer/engineerInput">엔지니어 등록</a></li>
				  <li><a href="${ctp}/admin/engineer/engineerList">엔지니어 현황</a></li>
				  <li><a href="${ctp}/admin/engineer/schedule">일정관리</a></li>
				  <li><a href="${ctp}/admin/engineer/asRequestList">A/S 현황</a></li>
			  </ul>
			</div>
		</li>
		<li class="dropdown">
			<div class="ani-navbar-menu ani-navbar-menu__icon">
			 <i class="fa-solid fa-cash-register"></i><a href="javascript:void(0)">제품 관리</a>
			  <ul class="dropdown-content">
			  	<li><div class="divider2"></div></li>
				  <li><a href="${ctp}/admin/product/productInput">기기 등록</a></li>
				  <li><a href="${ctp}/admin/product/productList">장비 리스트</a></li>
				  <li><a href="${ctp}/admin/product/expendableInput">소모품 등록</a></li>
				  <li><a href="${ctp}/admin/product/productEstimate">견적요청 현황</a></li>
			  </ul>
			</div>
		</li>
		<li class="dropdown">
			<div class="ani-navbar-menu ani-navbar-menu__icon">
			  <i class="fa-solid fa-chart-pie"></i>
			  <a href="${ctp}/admin/siteChart">사이트 통계</a>
			</div>
		</li>
		<li class="dropdown">
			<div class="ani-navbar-menu ani-navbar-menu__icon">
			 <i class="fa-solid fa-gear"></i><a href="javascript:void(0)">계정설정</a>
			  <ul class="dropdown-content">
			  	<li><div class="divider2"></div></li>
				  <li><a href="${ctp}/admin/setting/changeAdminPwd">비밀번호 변경</a></li>
				  <li><a href="${ctp}/admin/setting/messageList">받은 메세지</a></li>
				  <li><a href="${ctp}/admin/setting/fileDelete">파일관리</a></li>
			  </ul>
			</div>
		</li>
		<li class="dropdown">
			<div class="ani-navbar-menu ani-navbar-menu__icon">
			 <i class="fa-solid fa-circle-exclamation"></i><a href="javascript:void(0)">에러페이지</a>
			  <ul class="dropdown-content">
			  	<li><div class="divider2"></div></li>
				  <li><a href="${ctp}/admin/errorPage/error404">404에러페이지</a></li>
				  <li><a href="${ctp}/admin/errorPage/error500">500에러페이지</a></li>
				  <li><a href="${ctp}/admin/errorPage/errorNumberFormat">NumberFormat</a></li>
				  <li><a href="${ctp}/admin/errorPage/errorNullPointer">NullPointer</a></li>
			  </ul>
			</div>
		</li>
	</ul>
</nav>