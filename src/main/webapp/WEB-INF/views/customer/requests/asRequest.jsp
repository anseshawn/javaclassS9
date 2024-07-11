<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>A/S 요청</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Shuffle/5.2.3/shuffle.min.js"></script>
	<script src="${ctp}/js/shuffle.js"></script>
	<script>
		var element = document.querySelector('.shuffle-container');
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<div class="container">
<section class="page-title bg-3">
  <div class="overlay"></div>
  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <div class="block text-center">
          <h1 class="text-capitalize mb-5 text-lg">A/S 신청</h1>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- portfolio -->
<section class="section doctors">
  <div class="container">
  	  <div class="row justify-content-center">
				<div class="col-lg-6 text-center">
			    <div class="section-title">
		        <h2>장비 및 엔지니어 선택</h2>
		        <div class="divider mx-auto my-4"></div>
		        <p>A/S를 신청할 장비를 선택하세요</p>
			    </div>
				</div>
      </div>
    	<div class="col-12 text-center mb-5">
        <div class="btn-group btn-group-toggle " data-toggle="buttons">
          <label class="btn active ">
            <input type="radio" name="shuffle-filter" value="all" checked="checked" />전체상품
          </label>
          <label class="btn">
            <input type="radio" name="shuffle-filter" value="UV" />UV
          </label>
          <label class="btn">
            <input type="radio" name="shuffle-filter" value="AAs" />AAs
          </label>
          <label class="btn">
            <input type="radio" name="shuffle-filter" value="ICP" />ICP
          </label>
          <label class="btn">
            <input type="radio" name="shuffle-filter" value="GC" />GC
          </label>
           <label class="btn">
            <input type="radio" name="shuffle-filter" value="LC" />LC
          </label>
          <label class="btn">
            <input type="radio" name="shuffle-filter" value="etc" />etc
          </label>
        </div>
    </div>
    
    <div class="shuffle-container">
    <div class="col-12 text-center mb-5">
	    <c:forEach var="vo" items="${vos}" varStatus="st">
	    	<c:set var="mach" value="${fn:split(vo.machine,',')}"/>
	    	<c:set var="catGroup">
		    	<c:forEach var="cat" items="${mach}" varStatus="catSt">
		    		"${cat}"<c:if test="${!catSt.last}">,</c:if>
		    	</c:forEach>
	    	</c:set>
		  	<div class="shuffle-wrapper">
			    <div class="border shuffle-item portfolio-gallery mb-4" data-groups='[${catGroup}]'>
			    	<table class="table table-borderless">
				      <tr>
				      	<td rowspan="3" style="width:20%;"><img src="${ctp}/images/${vo.photo}" width="150px"/></td>
				      	<td colspan="2"><b>${vo.name}</b> 엔지니어</td>
				      	<td><i class="fa-solid fa-star mr-2" style="color:#FFB724"></i> ${vo.starPoint}</td>
				      </tr>
				      <tr class="text-center">
				      	<th>담당기기</th>
				      	<td>${vo.machine}</td>
				      	<td rowspan="2" style="width:20%; text-align:center;">
				      		<a href="${ctp}/customer/requests/asAppointment?idx=${vo.idx}"><i class="fa-regular fa-calendar-days"></i><br/>예약하기</a>
				      	</td>
				      </tr>
				      <tr class="text-center">
				      	<th>담당지역</th>
				      	<td>${vo.place}</td>
				      </tr>
				    </table>
				  </div>
		    </div>
		  </c:forEach>
	  </div>
	  </div>
	  
  </div>
</section>
</div>
<script>
	var Shuffle = window.Shuffle;
	var shuffleInstances = [];
	
	// 각 shuffle-wrapper에 Shuffle 객체 초기화
	var shuffleWrappers = document.querySelectorAll('.shuffle-wrapper');
	shuffleWrappers.forEach(function(wrapper) {
	  var shuffleInstance = new Shuffle(wrapper, {
	    itemSelector: '.shuffle-item',
	    buffer: 0 // Buffer 값 설정 (선택사항)
	  });
	  shuffleInstances.push(shuffleInstance);
	});
	
	// 필터링 기능 추가
	jQuery('input[name="shuffle-filter"]').on('change', function(evt) {
	  var input = evt.currentTarget;
	  if (input.checked) {
	    var value = input.value;
	    shuffleInstances.forEach(function(instance) {
	      instance.filter(value);
	    });
	  }
	});
/*
	document.addEventListener('DOMContentLoaded', function() {
	  var Shuffle = window.Shuffle;
	  var jQuery = window.jQuery;

	  var myShuffle = new Shuffle(document.querySelector('.shuffle-wrapper'), {
	    itemSelector: '.shuffle-item',
	    buffer: 1
	  });

	  jQuery('input[name="shuffle-filter"]').on('change', function (evt) {
	    var input = evt.currentTarget;
	    if (input.checked) {
	      var filterValue = input.value;
	      myShuffle.filter(filterValue);
	    }
	  });
	});
*/	
</script>
<%-- <jsp:include page="/WEB-INF/views/include/scripts.jsp" /> --%>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>