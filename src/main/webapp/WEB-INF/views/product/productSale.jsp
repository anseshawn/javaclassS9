<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장비 판매 페이지</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/Shuffle/5.2.3/shuffle.min.js"></script>
<script src="${ctp}/js/shuffle.js"></script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<div class="container">
	<section class="page-title bg-3">
	  <div class="overlay"></div>
	  <div class="container">
	    <div class="row">
	      <div class="col-md-12">
	        <div class="block text-center">
	          <span class="text-white">좋은 장비는 분석 효율을 높입니다</span>
	          <h1 class="text-capitalize mb-5 text-lg">분석장비</h1>
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
                <h2>실험실 장비 목록</h2>
                <div class="divider mx-auto my-4"></div>
                <p>성능 좋은 중고 장비를 취급하여 판매하고 있습니다.</p>
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
		    <div class="row shuffle-wrapper portfolio-gallery">
			    <c:forEach var="vo" items="${vos}" varStatus="st">
				    <c:if test="${vo.available=='OK'}">
					    <div class="col-lg-3 col-sm-6 col-md-6 mb-4 shuffle-item" data-groups='["${vo.proType}"]'>
								<div class="position-relative doctor-inner-box">
									<div class="doctor-profile">
										<div class="product-img">
											<a href="${ctp}/product/productContent?idx=${vo.idx}"><img src="${ctp}/product/${vo.proPhoto}" alt="${vo.proName}" class="img-fluid w-100"/></a>
										</div>
									</div>
									<div class="content mt-3">
										<h4 class="mb-0"><a href="${ctp}/product/productContent?idx=${vo.idx}">${vo.proName}</a></h4>
										<p>(${vo.proYear}) 제조사: ${vo.proMade}</p>
									</div>
								</div>
						  </div>
					  </c:if>
				  </c:forEach>
			  </div>
		  </div>
		  
	  </div>
	</section>
</div>
<!-- 블록페이지 시작 -->	
<div class="text-center">
	<ul class="pagination justify-content-center" style="margin:20px 0">
		<c:if test="${pageVO.pag > 1}"><li class="page-item"><a class="page-link" href="productSale?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=1&pageSize=${pageVO.pageSize}">처음</a></li></c:if>
		<c:if test="${pageVO.curBlock > 0}"><li class="page-item"><a class="page-link" href="productSale?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">이전블록</a></li></c:if>
		<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
			<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><li class="page-item active"><a class="page-link" href="productSale?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
			<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><li class="page-item"><a class="page-link" href="productSale?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
		</c:forEach>
		<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><li class="page-item"><a class="page-link" href="productSale?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">다음블록</a></li></c:if>
		<c:if test="${pageVO.pag < pageVO.totPage}"><li class="page-item"><a class="page-link" href="productSale?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}">끝</a></li></c:if>
	</ul>
</div>
<!-- 블록페이지 끝 -->
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
</script>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>