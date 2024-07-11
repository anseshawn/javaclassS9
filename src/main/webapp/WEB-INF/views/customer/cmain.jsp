<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	.quick_list .item {
    flex: 0 0 auto; /* 기본 크기로 설정 */
    margin: 10px;   /* 아이템 간격 */
	}
</style>
<script>
	$(document).ready(function () {
    function convertTime() {
      var now = new Date();
      var month = now.getMonth() + 1;
      var date = now.getDate();
      return month + '월' + date + '일';
    }
    var currentTime = convertTime();
    $('.nowtime').append(currentTime);
	 	$('.date').html(currentTime);
    
    navigator.geolocation.getCurrentPosition(accessToGeo)
    
    newsCrawling();
  });

	function accessToGeo (position) {
    const positionObj = {
      latitude: position.coords.latitude,
      longitude: position.coords.longitude
    }
    let str = "";
    if(position.coords.latitude != ""){
    	str = 'https://api.openweathermap.org/data/2.5/weather?lat='+position.coords.latitude+'&lon='+position.coords.longitude+'&appid=237a07d045793d996f10943b24e831a2&units=metric';
    }
    else {
    	str = 'https://api.openweathermap.org/data/2.5/weather?q=Seoul,kr&appid=237a07d045793d996f10943b24e831a2&units=metric';
    }
    
    $.getJSON(str,
	    function (WeatherResult) {
	      $('.nowtemp').html("현재기온 : " + WeatherResult.main.temp + " ℃");
	      $('.lowtemp').html("최저기온 : " + WeatherResult.main.temp_min + " ℃");
	      $('.hightemp').html("최고기온 : " + WeatherResult.main.temp_max + " ℃");
	
	      var weathericonUrl =
	        '<img src= "http://openweathermap.org/img/wn/'
	        + WeatherResult.weather[0].icon +
	        '.png" alt="' + WeatherResult.weather[0].description + '"/>';
	      $('.icon').html(weathericonUrl);
	    
	    }
    );
	}
	
	function newsCrawling() {
		let search = "https://news.naver.com/breakingnews/section/105/228";
		$.ajax({
			url: "${ctp}/customer/cmain",
			type: "post",
			data: {search:search},
			success: function(vos) {
				if(vos != "") {
					let str = '<table class="table table-borderless">';
					for(let i=0; i<7; i++) {
						str += '<tr>';
						str += '<td>'+vos[i].item1+'</td>';
						str += '</tr>';
						/*
						str += '<tr>';
						str += '<td>'+vos[i].item2+'</td>';
						str += '<td>'+vos[i].item3+'</td>';
						str += '</tr>';
						*/
					}
					$("#demo").html(str);
				}
			},
			error: function() {
				alert("전송오류");
			}
		});
	}

</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/slider.jsp" />
<div class="main-top_content">
	<!-- main_quick_menu -->
	<div class="main_quick_menu_wrap">
		<div class="main-section quick_menu">
			<br/>
			<div class="quick_slide align-items-center">
				<div class="quick_list" style="text-align: center;">
					<div class="item" style="align-items: center; justify-content: center;">
						<a href="#">
							<img class="ico_off" src="${ctp}/images/cmain/quick_ico00.png" alt="상담원안내 이미지 아이콘">
							<img class="ico_on" src="${ctp}/images/cmain/quick_ico_on00.png" alt="상담원안내 모바일 이미지 아이콘">
							<p class="txt">상담원안내</p>
						</a>
					</div>
					<!-- 
					<div class="item">
						<a href="/web/contents/K203000000.do">
						<img class="ico_off" src="${ctp}/images/cmain/quick_ico01.png" alt="신청양식 이미지 아이콘">
						<img class="ico_on" src="${ctp}/images/cmain/quick_ico_on01.png" alt="신청양식 모바일 이미지 아이콘">
							<p class="txt">신청양식 <br class="v_mobile">내려받기</p>
						</a>
					</div>
					 -->
					<div class="item" style="align-items: center; justify-content: center;">
						<a href="${ctp}/customer/requests/asRequest">
							<img class="ico_off" src="${ctp}/images/cmain/quick_ico02.png" alt="접수안내 이미지 아이콘">
							<img class="ico_on" src="${ctp}/images/cmain/quick_ico_on02.png" alt="접수안내 모바일 이미지 아이콘">
							<p class="txt">A/S신청</p>
						</a>
					</div>
					<div class="item" style="align-items: center; justify-content: center;">
						<a href="${ctp}/customer/requests/asProgress">
							<img class="ico_off" src="${ctp}/images/cmain/quick_ico05.png" alt="진행현황조회 이미지 아이콘">
							<img class="ico_on" src="${ctp}/images/cmain/quick_ico_on05.png" alt="진행현황조회 모바일 이미지 아이콘">
							<p class="txt">진행현황 조회</p>
						</a>
					</div>
					<div class="item" style="display: inline-flex; align-items: center; justify-content: center;">
						<a href="#">
							<img class="ico_off" src="${ctp}/images/cmain/quick_ico03.png" alt="Q&A 이미지 아이콘">
							<img class="ico_on" src="${ctp}/images/cmain/quick_ico_on03.png" alt="Q&A 모바일 이미지 아이콘">
							<p class="txt">Q&A<br class="v_mobile">(온라인상담)</p>
						</a>
					</div>
					<div class="item" style="align-items: center; justify-content: center;">
						<a href="${ctp}/product/productSale">
							<img class="ico_off" src="${ctp}/images/cmain/quick_ico04.png" alt="견적요청 이미지 아이콘">
							<img class="ico_on" src="${ctp}/images/cmain/quick_ico_on04.png" alt="견적요청 모바일 이미지 아이콘">
							<p class="txt">제품 <br class="v_mobile">견적요청</p>
						</a>
					</div>
					<div class="item" style="align-items: center; justify-content: center;">
						<a href="#">
							<img class="ico_off" src="${ctp}/images/cmain/quick_ico06.png" alt="성적서/인증서 발급 이미지 아이콘">
							<img class="ico_on" src="${ctp}/images/cmain/quick_ico_on06.png" alt="성적서/인증서 발급 모바일 이미지 아이콘">
							<p class="txt">성적서/인증서 발급</p>
						</a>
					</div>
					<div class="item" style="align-items: center; justify-content: center;">
						<a href="#">
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
<div class="container">
	<div class="row">
		<div class="col-lg-9">
			<h4>과학 뉴스 소식</h4>
			<div id="demo"></div>
		</div>
		<div class="col-lg-3">
			<div class="card m-2 dispForm" style="background-color:#CDD7E4; text-align:center;">
				<div class="card-body">
					<h4 class="card-title">현재 날씨</h4>
					<div class="icon"></div>
					<p class="card-text date"></p>
					<p class="card-text nowtemp"></p>
					<p class="card-text lowtemp"></p>
					<p class="card-text hightemp"></p>
				</div>
			</div>
		</div>
	</div>
</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>
