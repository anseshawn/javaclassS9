<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<title>Home</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
	<script>
		'use strict';
		window.onload = function(){
			if("${sLogin}" != "") {
				alert("현재 임시 비밀번호로 로그인 중입니다.\n비밀번호를 새로 변경해주세요.");
			}
			if("${todayNoPopup}" == "" || "${todayNoPopup}" != "${sMid}"){
				console.log("팝업오픈");
				let url = "${ctp}/company/popupNotice";
				let widthSize= 500;
				let heightSize = 600;
				let leftCenter = Math.ceil((window.screen.width - widthSize)/2);
				let topCenter = Math.ceil((window.screen.height - heightSize)/2);
				window.open(
					url, // url
					'공지사항', // title
					'width='+widthSize+', height='+heightSize+', top='+topCenter+', left='+leftCenter // 설정
				);
			}
		}
		
		function sendContent() {
			let name = myform.name.value;
			let email = myform.email.value;
			
			if(name.trim()=="" || email.trim()=="") {
				alert("이름과 이메일은 필수 입력입니다.");
				return false;
			}
			myform.submit();
		}
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />

<!-- Slider Start -->
<section class="banner">
	<div class="container">
		<div class="row">
			<div class="col-lg-6 col-md-12 col-xl-7">
				<div class="block">
					<div class="divider mb-3"></div>
					<span class="text-uppercase text-sm letter-spacing ">실험실에 대한 모든 것</span>
					<h1 class="mb-3 mt-3">Your most trusted partner</h1>
					
					<p class="mb-4 pr-5">우리 엔지니어링은 실험실 전반에 대한 기기와 소모품을 다루고 있습니다. 항상 고객과의 소통을 추구하여 세계로 나아가는 그린 엔지니어링이 되겠습니다.</p>
					<div class="btn-container ">
						<a href="${ctp}/product/productEstimate" target="_blank" class="btn btn-main-2 btn-icon btn-round-full">견적문의 <i class="icofont-simple-right ml-2  "></i></a>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
<section class="features">
	<div class="container">
		<div class="row">
			<div class="col-lg-12">
				<div class="feature-block d-lg-flex">
					<div class="feature-item mb-5 mb-lg-0">
						<div class="feature-icon mb-4">
							<i class="icofont-laboratory"></i>
						</div>
						<span>실험실 기초장비</span>
						<h4 class="mb-3">중고기기 확인하기</h4>
						<p class="mb-4">분석에 도움이 되어드리겠습니다. 실험에 필요한 장비들을 합리적인 가격에 제공합니다.</p>
						<a href="${ctp}/product/productSale" class="btn btn-main btn-round-full">장비리스트 보기</a>
					</div>
				
					<div class="feature-item mb-5 mb-lg-0">
						<div class="feature-icon mb-4">
							<i class="icofont-google-talk"></i>
						</div>
						<span>실험에 필요한 정보</span>
						<h4 class="mb-3">다른 연구원과 소통하기</h4>
						<p class="mb-4">실험에 어려움이 있습니까? 다른 연구원들에게 도움을 요청해보세요.</p>
						<a href="${ctp}/customer/board/questionBoardList" class="btn btn-main btn-round-full">Q&A 게시판</a>
					</div>
				
					<div class="feature-item mb-5 mb-lg-0">
						<div class="feature-icon mb-4">
							<i class="icofont-support"></i>
						</div>
						<span>온라인 상담</span>
						<h4 class="mb-3">support@email.com</h4>
						<p class="mb-4">제품 관련 문의, A/S 신청, 사이트 이용 중 발생하는 불편사항이 있다면 문의를 남겨주세요.</p>
						<a href="${ctp}/service/serviceMain" class="btn btn-main btn-round-full">상담내용 보내기</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
 
<section class="section service gray-bg">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-lg-7 text-center">
				<div class="section-title">
					<h2>Green Engineering</h2>
					<div class="divider mx-auto my-4"></div>
					<p>그린 엔지니어링은 바이오 제약, 임상 연구, 에너지 및 화학, 환경, 식품, 재료 테스트 및 연구, 병리학 등 다양한 분야의
					실험실을 지원하고 있습니다.</p>
				</div>
			</div>
		</div>

		<div class="row">
			<div class="col-lg-4 col-md-6 col-sm-6">
				<div class="service-item mb-4">
					<div class="icon d-flex align-items-center">
						<i class="icofont-laboratory text-lg"></i>
						<h4 class="mt-3 mb-3">화학</h4>
					</div>

					<div class="content">
						<p class="mb-4">Saepe nulla praesentium eaque omnis perferendis a doloremque.</p>
					</div>
				</div>
			</div>

			<div class="col-lg-4 col-md-6 col-sm-6">
				<div class="service-item mb-4">
					<div class="icon d-flex align-items-center">
						<i class="icofont-fast-food text-lg"></i>
						<h4 class="mt-3 mb-3">식품 및 음료</h4>
					</div>
					<div class="content">
						<p class="mb-4">Saepe nulla praesentium eaque omnis perferendis a doloremque.</p>
					</div>
				</div>
			</div>
			
			<div class="col-lg-4 col-md-6 col-sm-6">
				<div class="service-item mb-4">
					<div class="icon d-flex align-items-center">
						<i class="icofont-medicine text-lg"></i>
						<h4 class="mt-3 mb-3">임상연구</h4>
					</div>
					<div class="content">
						<p class="mb-4">Saepe nulla praesentium eaque omnis perferendis a doloremque.</p>
					</div>
				</div>
			</div>


			<div class="col-lg-4 col-md-6 col-sm-6">
				<div class="service-item mb-4">
					<div class="icon d-flex align-items-center">
						<i class="fa-solid fa-recycle text-lg"></i>
						<h4 class="mt-3 mb-3">재료 테스트</h4>
					</div>

					<div class="content">
						<p class="mb-4">Saepe nulla praesentium eaque omnis perferendis a doloremque.</p>
					</div>
				</div>
			</div>

			<div class="col-lg-4 col-md-6 col-sm-6">
				<div class="service-item mb-4">
					<div class="icon d-flex align-items-center">
						<i class="fa-solid fa-seedling text-lg"></i>
						<h4 class="mt-3 mb-3">환경</h4>
					</div>
					<div class="content">
						<p class="mb-4">Saepe nulla praesentium eaque omnis perferendis a doloremque.</p>
					</div>
				</div>
			</div>
			
			<div class="col-lg-4 col-md-6 col-sm-6">
				<div class="service-item mb-4">
					<div class="icon d-flex align-items-center">
						<i class="icofont-dna-alt-1 text-lg"></i>
						<h4 class="mt-3 mb-3">바이오 / 제약</h4>
					</div>
					<div class="content">
						<p class="mb-4">Saepe nulla praesentium eaque omnis perferendis a doloremque.</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
<section class="section appoinment">
	<div class="container">
		<div class="row align-items-center">
			<div class="col-lg-6 ">
				<div class="appoinment-content">
					<img src="${ctp}/images/bg/lab3.jpg" alt="" class="img-fluid">
					<div class="emergency">
						<h2 class="text-lg"><i class="icofont-phone-circle text-lg"></i>043	123 4567</h2>
					</div>
				</div>
			</div>
			<div class="col-lg-6 col-md-10 ">
				<div class="appoinment-wrap mt-5 mt-lg-0">
					<h2 class="mb-2 title-color">문의 메일 보내기</h2>
					<p class="mb-4">문의 사항이 있다면 메일을 보내주세요. 혹은 하단에서 뉴스레터 구독이 가능합니다.</p>
				    <form name="myform" class="appoinment-form" method="post" action="${ctp}/service/serviceMain">
	            <div class="row">
	             	<div class="col-lg-12">
	              	<div class="form-group">
	                	<select class="form-control" name="title" id="title">
	                    <option>상담 카테고리</option>
	                    <option>제품 문의</option>
	                    <option>견적 문의</option>
	                    <option>A/S 신청</option>
	                    <option>회원계정</option>
	                    <option>기타</option>
	                  </select>
	                </div>
	              </div>
								<div class="col-lg-6">
									<div class="form-group">
										<input name="name" id="name" type="text" class="form-control" placeholder="이름을 입력하세요" required />
									</div>
								</div>
	
								<div class="col-lg-6">
									<div class="form-group">
										<input name="email" id="email" type="text" class="form-control" placeholder="이메일을 입력하세요" required />
									</div>
								</div>
							</div>
							<div class="form-group-2 mb-4">
								<textarea name="content" id="content" class="form-control" rows="6" placeholder="상세 내용"></textarea>
							</div>
			
			    	<a href="javascript:sendContent()" class="btn btn-main btn-round-full" >문의하기 <i class="icofont-simple-right ml-2  "></i></a>
			  		<input type="hidden" name="part" value="SERVICE"/>
			  	</form>
				</div>
			</div>
		</div>
	</div>
</section>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>
