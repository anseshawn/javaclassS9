<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>온라인 상담 - 고객서비스</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
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
            <li class="list-inline-item"><a href="${ctp}/service/serviceMain" class="text-white">온라인 상담</a></li>
            <li class="list-inline-item"><span class="text-white">/</span></li>
            <li class="list-inline-item"><a href="${ctp}/service/complaintMain" class="text-white-50">불편사항 신고</a></li>
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
					<h2 class="text-md mb-2">온라인 상담</h2>
					<div class="divider mx-auto my-4" style="width:50%;"></div>
					<p class="mb-5">견적요청, A/S신청의 경우 각 카테고리의 폼을 이용하여<br/>상세한 설명을 보내주시면 더 신속한 서비스가 제공됩니다.</p>
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
									<input name="name" id="name" type="text" class="form-control" value="${vo.name}" placeholder="이름을 적어주세요" required />
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
									<input name="phone" id="phone" type="text" class="form-control" placeholder="휴대폰 번호('-' 없이 적어주세요)"/>
								</div>
							</div>
						</div>
						<div class="form-group-2 mb-4">
							<textarea name="content" id="content" class="form-control" rows="8" placeholder="상담내용" required></textarea>
						</div>
						<div class="text-center">
							<input class="btn btn-main btn-round-full" name="submit" type="submit" value="상담 요청 보내기"></input>
						</div>
						<input type="hidden" name="part" value="SERVICE"/>
      		</form>
    		</div>
  	</div>
	</div>
</section>
<!-- 카카오맵 추가 -->
<div id="map" style="width:100%;height:500px;"></div>
<!-- 카카오맵 Javascript API -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=72ddec57bb46287e893efd27beb4a21e"></script>
<script>
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        center: new kakao.maps.LatLng(36.63508163115122, 127.459535598743), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };
	var map = new kakao.maps.Map(mapContainer, mapOption);
	
	// 마커가 표시될 위치입니다 
	var markerPosition  = new kakao.maps.LatLng(36.63508163115122, 127.459535598743); 
	
	// 마커를 생성합니다
	var marker = new kakao.maps.Marker({
	    position: markerPosition
	});
	
	// 마커가 지도 위에 표시되도록 설정합니다
	marker.setMap(map);
	
	var iwContent = '<div style="padding:5px;">그린엔지니어링<br>';
			iwContent += '<a href="https://map.kakao.com/link/map/Green eng,36.63508163115122,127.459535598743" style="color:#0E2B5E;" target="_blank">큰지도보기</a> / ';
			iwContent += '<a href="https://map.kakao.com/link/to/Green eng,36.63508163115122,127.459535598743" style="color:#0E2B5E;" target="_blank">길찾기</a></div>',
	    iwPosition = new kakao.maps.LatLng(36.63508163115122, 127.459535598743); //인포윈도우 표시 위치입니다
	
	// 인포윈도우를 생성합니다
	var infowindow = new kakao.maps.InfoWindow({
	    position : iwPosition, 
	    content : iwContent 
	});
	  
	// 마커 위에 인포윈도우를 표시합니다. 두번째 파라미터인 marker를 넣어주지 않으면 지도 위에 표시됩니다
	infowindow.open(map, marker); 
</script>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>