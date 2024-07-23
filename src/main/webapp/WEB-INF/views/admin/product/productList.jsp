<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자 - 등록 장비 리스트</title>
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Shuffle/5.2.3/shuffle.min.js"></script>
	<script src="${ctp}/js/shuffle.js"></script>
	<style>
		.badge.edit {
			background-color: #5089EF;
			color: #fff;
		}
		.badge.delete {
			background-color: #EC4651;
			color: #fff;
		}
	</style>
	<script>
		'use strict';
		
		function productDelete(idx, photo) {
			let message = "";
			let icon = "";
			Swal.fire({
        html : "<h3>해당 장비를 DB에서 영구삭제하겠습니까?</h3>",
        confirmButtonText : '확인',
        showCancelButton: true,
        confirmButtonColor : '#003675',
        customClass: {
          popup : 'custom-swal-popup',
          htmlContainer : 'custom-swal-text'
        }
			}).then((result)=>{
				if(result.isConfirmed) {
					$.ajax({
						url: "${ctp}/admin/product/productDelete",
						type: "post",
						data: {
							idx : idx,
							photo : photo
						},
						success: function(res){
							if(res != "0") {
								message = "장비가 삭제 되었습니다.";
								icon = "success";
							}
							else {
								message = "장비 삭제에 실패했습니다.";
								icon = "warning";
							}
							Swal.fire({
								html: message,
								icon: icon,
								confirmButtonText: '확인',
								customClass: {
				        	confirmButton : 'swal2-confirm‎',
				          popup : 'custom-swal-popup',
				          htmlContainer : 'custom-swal-text'
								}
							}).then(function(){
								location.href="${ctp}/admin/product/productList";
							});
						},
						error: function(){
							alert("전송오류");
						}
					});
				}
			});
		}
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<div class="container">
<p><br/></p>
	<section class="section doctors">
	  <div class="container">
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
				    <div class="col-lg-3 col-sm-6 col-md-6 mb-4 shuffle-item" data-groups='["${vo.proType}"]'>
							<div class="position-relative doctor-inner-box">
								<div class="doctor-profile">
									<div class="product-img">
										<a href="${ctp}/admin/product/productContent?idx=${vo.idx}"><img src="${ctp}/product/${vo.proPhoto}" alt="${vo.proName}" class="img-fluid w-100"/></a>
									</div>
								</div>
								<div class="content mt-3">
									<h4 class="mb-0"><a href="${ctp}/admin/product/productContent?idx=${vo.idx}">${vo.proName}</a></h4>
									<p>
										(${vo.proYear}) 제조사: ${vo.proMade}<br/>
										<c:if test="${vo.available=='OK'}"><font color="#2768FF">판매중</font></c:if>
										<c:if test="${vo.available!='OK'}"><font color="#E71825">판매완료</font></c:if>
									</p>
									<p class="text-right">
										<a href="${ctp}/admin/product/productEdit?idx=${vo.idx}" class="badge edit mr-2">수정</a>
										<a href="javascript:productDelete('${vo.idx}','${vo.proPhoto}')" class="badge delete">삭제</a>
									</p>
								</div>
							</div>
					  </div>
				  </c:forEach>
			  </div>
		  </div>
		  
	  </div>
	</section>
<p><br/></p>
</div>
<!-- 블록페이지 시작 -->	
<div class="text-center">
	<ul class="pagination justify-content-center" style="margin:20px 0">
		<c:if test="${pageVO.pag > 1}"><li class="page-item"><a class="page-link" href="productList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=1&pageSize=${pageVO.pageSize}">처음</a></li></c:if>
		<c:if test="${pageVO.curBlock > 0}"><li class="page-item"><a class="page-link" href="productList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">이전블록</a></li></c:if>
		<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
			<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><li class="page-item active"><a class="page-link" href="productList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
			<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><li class="page-item"><a class="page-link" href="productList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
		</c:forEach>
		<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><li class="page-item"><a class="page-link" href="productList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">다음블록</a></li></c:if>
		<c:if test="${pageVO.pag < pageVO.totPage}"><li class="page-item"><a class="page-link" href="productList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}">끝</a></li></c:if>
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
</body>
</html>