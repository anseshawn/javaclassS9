<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>불편사항 - 고객서비스</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container">
<section class="page-title bg-1">
  <div class="overlay"></div>
  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <div class="block text-center">
          <span class="text-white">Contact Us</span>
          <h1 class="text-capitalize mb-2 text-lg">고객서비스</h1>

          <ul class="list-inline breadcumb-nav" style="font-size: 16px;">
            <li class="list-inline-item"><a href="${ctp}/service/serviceMain" class="text-white-50">온라인 상담</a></li>
            <li class="list-inline-item"><span class="text-white">/</span></li>
            <li class="list-inline-item"><a href="${ctp}/service/complaintMain" class="text-white">불편사항 신고</a></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</section>
<!-- contact form start -->

<section class="section contact-info pb-0">
    <div class="container">
         <div class="row">
            <div class="col-lg-4 col-sm-6 col-md-6">
                <div class="contact-block mb-4 mb-lg-0">
                    <i class="icofont-live-support"></i>
                    <h5>문의 전화</h5>
                     043-123-4567
                </div>
            </div>
            <div class="col-lg-4 col-sm-6 col-md-6">
                <div class="contact-block mb-4 mb-lg-0">
                    <i class="icofont-support-faq"></i>
                    <h5>문의 메일</h5>
                     support@email.com
                </div>
            </div>
            <div class="col-lg-4 col-sm-6 col-md-6">
                <div class="contact-block mb-4 mb-lg-0">
                    <i class="icofont-location-pin"></i>
                    <h5>오시는길</h5>
                     청주시 서원구 사직대로 109, 4층
                </div>
            </div>
        </div>
    </div>
</section>

<section class="contact-form-wrap section">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-lg-6">
				<div class="section-title text-center">
					<h2 class="text-md mb-2">불편사항</h2>
					<div class="divider mx-auto my-4" style="width:50%;"></div>
					<p class="mb-5">사이트 이용시 불편한 점이 있으셨습니까?<br/>항상 발전하는 그린 엔지니어링이 되겠습니다.</p>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12 col-md-12 col-sm-12">
				<form name="myform" id="contact-form" class="contact__form " method="post">
					<!-- form message -->

						<div class="row">
							<div class="col-lg-6">
								<div class="form-group">
									<input name="name" id="name" type="text" class="form-control" value="${vo.name}" placeholder="이름을 적어주세요" required/>
								</div>
							</div>
							<div class="col-lg-6">
								<div class="form-group">
									<input name="email" id="email" type="email" class="form-control" value="${vo.email}" placeholder="메일 주소를 입력해주세요" required/>
								</div>
							</div>
							<div class="col-lg-6">
								<div class="form-group">
									<select class="form-control" name="title" id="title">
                    <option>불편사항 카테고리</option>
                    <option>홈페이지 이용</option>
                    <option>고객서비스</option>
                    <option>엔지니어 신고</option>
                    <option>회원계정</option>
                    <option>기타</option>
	                </select>
								</div>
							</div>
							<div class="col-lg-6">
								<div class="form-group">
									<input name="phone" id="phone" type="text" class="form-control" placeholder="휴대폰 번호('-' 없이 적어주세요)">
								</div>
							</div>
						</div>
						<div class="form-group-2 mb-4">
							<textarea name="content" id="content" class="form-control" rows="8" placeholder="불편사항" required></textarea>
						</div>
						<div class="text-center">
							<input class="btn btn-main btn-round-full" name="submit" type="submit" value="신고하기"></input>
						</div>
						<input type="hidden" name="part" value="COMPLAINT"/>
      		</form>
    		</div>
  	</div>
	</div>
</section>

<!-- <div class="google-map "><div id="map"></div></div> -->
</div>
<p><br/></p>
<%-- <jsp:include page="/WEB-INF/views/include/scripts.jsp" /> --%>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>