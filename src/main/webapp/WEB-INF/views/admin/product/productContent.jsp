<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자 - 장비 상세페이지/${vo.proName}</title>
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
	<style>
    th {
    	text-align: center;
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
								location.href="${ctp}/admin/product/productList";
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
	<section class="section blog-wrap">
		<div class="container">
			<div class="product_info_box">
				<div class="row">
					<div class="col product_info_left" style="float:left;">
						<a href="${ctp}/product/${vo.proPhoto}" target="_blank"><img src="${ctp}/product/${vo.proPhoto}" width="400px" /></a>
					</div>
					<div class="col product_info_right" style="float:right;">
						<table class="table table-bordered">
							<tr>
								<td colspan="2">제품코드 : ${vo.idx}</td>
							</tr>
							<tr>
								<td colspan="2">${vo.proName}</td>
							</tr>
							<tr>
								<th style="width:30%;">제조사</th>
								<td style="width:70%;">${vo.proMade}</td>
							</tr>
							<tr>
								<th>연식</th>
								<td>${vo.proYear} 년도</td>
							</tr>
							<tr>
								<th>비고</th>
								<td>${fn:replace(vo.etcDetail,newLine,'<br/>') }</td>
							</tr>
							<tr>
								<th>현재 상태</th>
								<td>
									<c:if test="${vo.available=='OK'}"><font color="#2768FF">판매중</font></c:if>
									<c:if test="${vo.available!='OK'}"><font color="#E71825">판매완료</font></c:if>
								</td>
							</tr>
						</table>
						<div class="text-right">
							<a href="${ctp}/admin/product/productEdit?idx=${vo.idx}" class="btn btn-main-2 btn-icon mr-2 mb-2">설명 수정</a>
							<a href="javascript:productDelete('${vo.idx}','${vo.proPhoto}')" class="btn btn-main-2 btn-icon mr-2 mb-2">장비 삭제</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
	
</div>
</body>
</html>