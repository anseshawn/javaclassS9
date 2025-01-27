<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>About Us</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
	<script>
		/*
		$(function(){
	    var videoId = "BRDApYgvDqQ";
	    var apiKey = 'AIzaSyAOR5j-ogxANaP1B0kPeK8U2UlfsJvt3i0'; // 여기에 발급받은 API 키를 입력하세요
	    var url = "https://www.googleapis.com/youtube/v3/videos?id="+videoId+"&key="+apiKey+"&part=snippet";
			
	    fetch(url)
        .then(response => response.json())
        .then(data => {
            if (data.items && data.items.length > 0) {
                var video = data.items[0];
                var title = video.snippet.title;
                var videoUrl = "https://www.youtube.com/embed/"+videoId;
                document.getElementById('videoContainer').innerHTML = '<h4>'+title+'</h4><iframe width="560" height="315" src="'+videoUrl+'" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>';
            } else {
                document.getElementById('videoContainer').innerHTML = 'Video not found.';
            }
        })
        .catch(error => console.error('Error fetching video:', error));
		});
		*/
	</script>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<p><br/></p>
<div class="container">
<section class="page-title bg-2">
  <div class="overlay"></div>
  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <div class="block text-center">
          <span class="text-white">기업소개</span>
          <h1 class="text-capitalize mb-5 text-lg">About Us</h1>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="section about-page">
	<div class="container">
		<div class="row">
			<div class="col-lg-4">
				<h2 class="title-color">최고의 품질<br/>경쟁력 있는 가격<br/>신속한 납기</h2>
			</div>
			<div class="col-lg-8">
				<p>당사는 20년 이상의 축적된 기술력을 바탕으로 다양한 분야에서 일하시는 고객 여러분의 특성에 맞는 설계 및 디자인을 통해
        최적화된 제품을 생산 공급하고 있습니다. 앞으로도 그린 엔지니어링의 모든 임직원들은 다가올 미래시대가 요구하는
        진보된 분석시스템의 개발과 보급에 지속적으로 매진할 것을 약속드립니다.</p>
				<img src="${ctp}/images/logo/about.png" alt="" class="img-fluid">
			</div>
		</div>
	</div>
</section>
<section class="section testimonial">
	<div class="container">
		<div class="row">
			<div class="col-lg-6 offset-lg-6">
				<div class="section-title">
					<h2 class="mb-4">분석시스템의 개발과 보급을 위해</h2>
					<div class="divider  my-4"></div>
				</div>
			</div>
		</div>
		<div class="row align-items-center">
			<div class="col-lg-6 testimonial-wrap offset-lg-6">
  			<!-- <div id="videoContainer"></div> -->
  			<iframe id="ytplayer" type="text/html" width="100%" height="315" src="https://www.youtube.com/embed/?autoplay=1&loop=1&playlist=AbYiNR9Qgm8,lgWjziyinKs,BRDApYgvDqQ" frameborder="0" allowfullscreen></iframe>
			</div>
		</div>
	</div>
</section>	
</div>
<p><br/></p>
<%-- <jsp:include page="/WEB-INF/views/include/scripts.jsp" /> --%>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>