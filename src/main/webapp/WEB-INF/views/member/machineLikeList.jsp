<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>내 정보 관리</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <style>
  	.title {
  		font-size: 1.6rem;
  		font-family: "Do Hyeon";
  		font-weight: 700;
  		color: black;
  	}
  	.col {
  		text-align: center;
  		font-size: 1.2rem;
  		margin-bottom: 0.5rem;
  		margin-top: 0.5rem;
  	}
  </style>
  <script>
  	'use strict';
  	
  	function productRemoveLike(idx){
  		let message = "";
			let icon = "";
			Swal.fire({
	    html : "<h3>해당 장비를 관심 목록에서 삭제하겠습니까?</h3>",
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
						url: "${ctp}/product/productRemoveLike",
						type: "post",
						data: {
							idx : idx,
							mid : "${sMid}"
						},
						success: function(res){
							if(res != "0") {
								message = "관심목록에서 장비를 삭제 했습니다.";
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
								location.reload();
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
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<p><br/></p>
<div class="container">
	<div class="row">
		<div class="col-lg-3">
			<div class="bodyLeft">
				<jsp:include page="/WEB-INF/views/include/aside.jsp" />
			</div>
		</div>
		<div class="col-lg-9">
			<div class="bodyRight">
			<p><br/></p>
				<div class="row mb-3">
					<div class="col text-right"><h3>관심 장비 목록</h3></div>
				</div>
				<!-- 관심장비 목록 -->
				<div class="row">
					<p><br/></p>
			    <c:forEach var="vo" items="${vos}" varStatus="st">
				    <div class="border col-lg-4 col-sm-6 col-md-6 mb-4 mr-2">
							<div class="position-relative">
								<div class="doctor-profile">
									<div class="product-img">
										<a href="${ctp}/product/productContent?idx=${vo.idx}"><img src="${ctp}/product/${vo.proPhoto}" alt="${vo.proName}" class="img-fluid w-100" style="width:100px;"/></a>
									</div>
								</div>
								<div class="content mt-3">
									<h4 class="mb-0"><a href="${ctp}/product/productContent?idx=${vo.idx}">${vo.proName}</a></h4>
									<p>
										(${vo.proYear}) 제조사: ${vo.proMade}<br/>
										<c:if test="${vo.available=='OK'}"><font color="#2768FF">판매중</font></c:if>
										<c:if test="${vo.available!='OK'}"><font color="#E71825">판매완료</font></c:if>
									</p>
									<p class="text-right">
										<a href="javascript:productRemoveLike('${vo.idx}')" class="badge delete">삭제</a>
									</p>
								</div>
							</div>
					  </div>
				  </c:forEach>
			  </div>
			  
			</div>
		</div>
	</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>