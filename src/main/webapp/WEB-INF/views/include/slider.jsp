<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
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
					<li class="item item_type1"><a href="${ctp}/product/productEstimate"><p class="txt txt_case1">견적 문의<i class="icofont-simple-right ml-2"></i></p></a></li>
					<li class="item item_type3">
						<a href="${ctp}/customer/requests/asRequest" class="mhide"><p class="txt txt_case3">A/S 신청<i class="icofont-simple-right ml-2  "></i></p></a>
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
						<a href="${ctp}/customer/requests/asProgress"><p class="txt txt_case1">A/S 진행현황<i class="icofont-simple-right ml-2  "></i></p></a>
					</li>
					<li class="item item_type2">
						<a href="{ctp}/member/estimateList"><p class="txt txt_case2">견적조회<i class="icofont-simple-right ml-2  "></i></p></a>
					</li>
				</ul>
			</div>
			<!-- 
			<div class="guide_box case3">
				<strong class="title">
					<h2>수수료</h2>
				</strong>
				<p class="sub-title">발생한 수수료를 확인하고<br> 온라인 납부를 할 수 있습니다.</p>
				<ul class="online-guide">
					<li class="item item_type1">
						<a href="#"><p class="txt txt_case1 more">자세히보기<i class="icofont-simple-right ml-2  "></i></p></a>
					</li>
				</ul>
			</div>
			-->
		</div>
	</div>
</div>
<!-- //main-visual__top -->