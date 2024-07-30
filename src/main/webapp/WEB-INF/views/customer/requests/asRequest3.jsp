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

		function modalView(engineerIdx) {
			let str = "<table class='table text-left'>";
			$.ajax({
				url: "${ctp}/customer/requests/engineerStarShow",
				type: "post",
				data: {engineerIdx : engineerIdx},
				success: function(vos) {
					for(let i=0; i<vos.length; i++){
						let star = "";
						for(let j=1; j<=vos[i].starPoint; j++) star += '<font color="gold"><i class="fa-solid fa-star"></i></font>';
						for(let j=1; j<=(5-vos[i].starPoint); j++) star += '<font color="#ddd"><i class="fa-solid fa-star"></i></font>';
						str += "<tr><td>"+star+"</td><td>"+vos[i].reviewDetail+"</td></tr>";
					}
					str += "</table>";
					$("#content").html(str);
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
		
  	let lastScroll = 0;
  	let curPage = 1;
    function loadMoreItems(page) {
      $.ajax({
        url: '${ctp}/customer/requests/asRequest/more',
        method: 'GET',
        data: {
            page: page,
            size: 3
        },
        success: function(data) {
            $('#items-container').append(data);
            page++;
        },
        error: function() {
            alert('Could not load more items');
        }
      });
    }

    $(window).scroll(function() {
  		let currentScroll = $(this).scrollTop();		// 스크롤바 위쪽 시작 위치, 처음은 0이다.
  		let documentHeight = $(document).height();	// 본문의 크기(화면에 표시되는 문서의 전체 높이)
  		let nowHeight = $(this).scrollTop() + $(window).height();	// 현재 화면 상단 + 현재 화면높이
  		
  		//스크롤이 아래로 내려갔을 때 이벤트 처리...
  		if(currentScroll > lastScroll) {
  			if(documentHeight < (nowHeight+(documentHeight*0.1))){ // 현재위치가 문서의 크기를 벗어났는지
  				// 다음페이지 가져오기...
  				console.log("다음페이지 가져오기");
  				curPage++;
  				loadMoreItems(curPage);
  			}
  		}
  		lastScroll = currentScroll;
    });
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
    <div class="col-12 text-center mb-5" id="items-container">
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
				      	<td rowspan="3" style="width:20%;"><img src="${ctp}/engineer/${vo.photo}" width="150px"/></td>
				      	<td colspan="2"><b>${vo.name}</b> 엔지니어</td>
				      	<td>
				      		<a href="#" onclick="modalView('${vo.idx}')" data-toggle="modal" data-target="#myModal"><i class="fa-solid fa-star mr-2" style="color:#FFB724"></i> ${vo.starPoint}
				      		<span style="font-size:13px;"><br/>상세리뷰</span></a>
				      	</td>
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

<!-- 별점 상세 내역 모달에 출력하기 -->
<div class="modal fade" id="myModal">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
    
      <!-- Modal Header -->
      <div class="modal-header text-center">
        <h4 class="modal-title">리뷰 상세보기</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
    		<span id="content"></span>
    		<hr/>
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-main-3 btn-icon-md" data-dismiss="modal">Close</button>
      </div>
      
    </div>
  </div>
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