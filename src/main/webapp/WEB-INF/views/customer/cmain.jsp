<%@ page language="java" contentType="text/html; charset=UTF-8"
		pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>고객전용 홈페이지</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
<link rel="stylesheet" type="text/css" href="${ctp}/resources/css/slick.css">
<script src="${ctp}/resources/js/mainSlider.js"></script>
<style>
	ul {
		list-style-type: none;
	}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
	<!-- main-visual__top -->
	<div id="content" class="main__visual-top">
		<!-- online-guide-wrap -->
		<div class="online-guide-wrap">
			<div class="mainslider">
				<div class="guide_box case1">
					<strong class="title">
						<%-- <img src="${ctp}/images/cmain/guide_box01_title.png" alt="온라인 신청"> --%>
						<h2>온라인 신청</h2>
					</strong>
					<p class="sub-title">
						<span>24시간 편리하게</span> 온라인 신청을<br> 하실 수 있습니다
					</p>
					<ul class="online-guide">
						<li class="item item_type1"><a href="/web/contents/K201000000.do"><p class="txt txt_case1">견적 문의</p></a></li>
						<li class="item item_type3">
							<a href="/web/contents/K301000000.do" class="mhide"><p class="txt txt_case3">A/S 신청</p></a>
							<!-- <a href="#none" class="mblock" onclick="alert('온라인 신청은 PC에서만 가능합니다.');"><p class="txt txt_case3">A/S신청</p></a> -->
						</li>
					</ul>
				</div>
				<div class="guide_box case2">
					<strong class="title">
						<%-- <img src="${ctp}/images/cmain/guide_box02_title.png" alt="나의 신청 현황 조회"> --%>
						<h2>나의 신청 현황 조회</h2>
					</strong>
					<p class="sub-title">A/S를 <span>신청한 내역</span>이나 <span>견적내역</span>을<br> 확인하실 수 있습니다.</p>
					<ul class="online-guide">
						<li class="item item_type1">
							<a href="/web/contents/K401000000.do"><p class="txt txt_case1">A/S진행현황</p></a>
						</li>
						<li class="item item_type2">
							<a href="/web/contents/K405000000.do"><p class="txt txt_case2">견적조회</p></a>
						</li>
					</ul>
				</div>
				<div class="guide_box case3">
					<strong class="title">
						<%-- <img src="${ctp}/images/cmain/guide_box03_title.png" alt="수수료"> --%>
						<h2>수수료</h2>
					</strong>
					<p class="sub-title">발생한 수수료를 확인하고<br> 온라인 납부를 할 수 있습니다.</p>
					<ul class="online-guide">
						<li class="item item_type1">
							<a href="/web/contents/K402000000.do"><p class="txt txt_case1 more">자세히보기<i class="icofont-simple-right ml-2  "></i></p></a>
						</li>
					</ul>
				</div>
			</div>
			<div class="slick-control type-s">
				<button type="button" class="slick-stop">정지</button>
				<button type="button" class="slick-play">재생</button>
			</div>
		</div>
	</div>
	<!-- //main-visual__top -->
<div class="main-top_content">
	<!-- main_quick_menu -->
	<div class="main_quick_menu_wrap">
		<div class="main-section quick_menu">
			<br/>
			<div class="quick_slide">
				<div class="quick_list">
					<div class="item q01">
						<a href="/web/contents/K200200000.do">
							<img class="ico_off" src="${ctp}/images/cmain/quick_ico00.png" alt="상담원안내 이미지 아이콘">
							<img class="ico_on" src="${ctp}/images/cmain/quick_ico_on00.png" alt="상담원안내 모바일 이미지 아이콘">
							<p class="txt">상담원안내</p>
						</a>
					</div>
					<div class="item">
						<a href="/web/contents/K203000000.do">
						<img class="ico_off" src="${ctp}/images/cmain/quick_ico01.png" alt="신청양식 이미지 아이콘">
						<img class="ico_on" src="${ctp}/images/cmain/quick_ico_on01.png" alt="신청양식 모바일 이미지 아이콘">
							<p class="txt">신청양식 <br class="v_mobile">내려받기</p>
						</a>
					</div>
					<div class="item">
						<a href="/web/contents/K201000000.do">
							<img class="ico_off" src="${ctp}/images/cmain/quick_ico02.png" alt="접수안내 이미지 아이콘">
							<img class="ico_on" src="${ctp}/images/cmain/quick_ico_on02.png" alt="접수안내 모바일 이미지 아이콘">
							<p class="txt">접수안내</p>
						</a>
					</div>
					<div class="item">
						<a href="/web/contents/K506000000.do">
							<img class="ico_off" src="${ctp}/images/cmain/quick_ico03.png" alt="Q&A 이미지 아이콘">
							<img class="ico_on" src="${ctp}/images/cmain/quick_ico_on03.png" alt="Q&A 모바일 이미지 아이콘">
							<p class="txt">Q&A<br class="v_mobile">(온라인상담)</p>
						</a>
					</div>
					<div class="item">
						<a href="/web/contents/K205000000.do">
							<img class="ico_off" src="${ctp}/images/cmain/quick_ico04.png" alt="견적요청 이미지 아이콘">
							<img class="ico_on" src="${ctp}/images/cmain/quick_ico_on04.png" alt="견적요청 모바일 이미지 아이콘">
							<p class="txt">제품 <br class="v_mobile">견적요청</p>
						</a>
					</div>
					<div class="item">
						<a href="/web/contents/K401000000.do">
							<img class="ico_off" src="${ctp}/images/cmain/quick_ico05.png" alt="진행현황조회 이미지 아이콘">
							<img class="ico_on" src="${ctp}/images/cmain/quick_ico_on05.png" alt="진행현황조회 모바일 이미지 아이콘">
							<p class="txt">진행현황 조회</p>
						</a>
					</div>
					<div class="item">
						<a href="/web/contents/K405000000.do">
							<img class="ico_off" src="${ctp}/images/cmain/quick_ico06.png" alt="성적서/인증서 발급 이미지 아이콘">
							<img class="ico_on" src="${ctp}/images/cmain/quick_ico_on06.png" alt="성적서/인증서 발급 모바일 이미지 아이콘">
							<p class="txt">성적서/인증서 발급</p>
						</a>
					</div>
					<div class="item">
						<a href="/web/contents/K404000000.do">
							<img class="ico_off" src="${ctp}/images/cmain/quick_ico07.png" alt="수수료 납부 이미지 아이콘">
							<img class="ico_on" src="${ctp}/images/cmain/quick_ico_on07.png" alt="수수료 납부 이미지 아이콘">
							<p class="txt">수수료납부</p>
						</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- //main_quick_menu -->
</div>
<br/>
<table class="table table-bordered">
	<tr>
		<th>제목</th>
		<th>내용</th>
	</tr>
	<tr>
		<td>뉴스제목</td>
		<td>뉴스내용</td>
	</tr>
</table>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>
