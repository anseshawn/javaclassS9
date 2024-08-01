<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자 - 견적 상세페이지</title>
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
	<style>
    th {
    	text-align: center;
    }
    
    .btn:disabled {
    	pointer-events: none;
      cursor: none;
    }
	</style>
	<script>
		'use strict';
		
		let message = "";
		let icon = "";
		
		$(function(){
			if('${saleVO.statement}' != 'ORDERING') {
				$("#makeOrderBtn").prop("disabled",true);
			}
		});
		
		function changeThisStatement(idx) {
			let statement = $("#changeStatement"+idx).val();
			//console.log(statement);
			Swal.fire({
        html : "<h3>해당 건의 진행상태를 변경하시겠습니까?</h3>",
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
						url: "${ctp}/admin/product/productSaleChange",
						type: "post",
						data: {
							idx : idx,
							statement : statement
						},
						success: function(res){
							if(res != "0") {
								message = "진행상태가 변경되었습니다.";
								icon = "success";
							}
							else {
								message = "상태 변경에 실패했습니다.";
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
				else location.reload();
			});
		}
		
		function makeOrder(idx) {
			Swal.fire({
        html : "<h3>해당 건의 발주를 진행하시겠습니까?</h3>",
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
						url: "${ctp}/admin/product/productSaleChange",
						type: "post",
						data: {
							saleIdx : idx,
							statement : 'DELIVER'
						},
						success: function(res){
							if(res != "0") {
								message = "발주가 진행되었습니다.";
								icon = "success";
							}
							else {
								message = "발주 진행에 실패했습니다.";
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
		function paymentCheck(idx) {
			Swal.fire({
        html : "<h3>해당 건의 결제를 확인하시겠습니까?</h3>",
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
						url: "${ctp}/admin/product/productSaleChange",
						type: "post",
						data: {
							saleIdx : idx,
							statement : 'COMPLETE'
						},
						success: function(res){
							if(res != "0") {
								message = "결제가 확인되었습니다.";
								icon = "success";
							}
							else {
								message = "결제 확인에 실패했습니다.";
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
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
	<div class="text-center"><h2>요청 상세</h2></div>
	<div class="divider2 mx-auto my-4 text-center" style="width:100%;"></div>
	<section class="section blog-wrap">
		<div class="container">
			<div class="product_info_box">
				<div class="row">
					<div class="col product_info_left text-center" style="float:left;">
						<a href="${ctp}/product/${vo.proPhoto}" target="_blank"><img src="${ctp}/product/${vo.proPhoto}" width="400px" /></a>
						<hr/>
						<c:if test="${!empty addressVO.addressName}">
							<h3>발주처</h3>
							<div id="map" style="width:100%;height:400px;position:relative;overflow:hidden;"></div>
						</c:if>
					</div>
					<div class="col product_info_right" style="float:right;">
						<div class="row mb-2">
							<div class="col">
								<div class="input-group" style="float:left;">
									<h3>진행 상태</h3>&nbsp;:&nbsp;
									<h4>
										<c:if test="${saleVO.statement == 'QUOTE'}"><font color="#E71825">견적요청</font></c:if>
										<c:if test="${saleVO.statement == 'CANCEL'}">취소</c:if>
										<c:if test="${saleVO.statement == 'CHECK'}"><font color="#2768FF">견적발송</font></c:if>
										<c:if test="${saleVO.statement == 'ORDERING'}"><font color="#E71825">발주요청</font></c:if>
										<c:if test="${saleVO.statement == 'DELIVER'}"><font color="#2768FF">발주진행</font></c:if>
										<c:if test="${saleVO.statement == 'PAYMENT'}"><font color="#E71825">결제대기</font></c:if>
										<c:if test="${saleVO.statement == 'COMPLETE'}">진행완료</c:if>
									</h4>
								</div>
							</div>
							<div class="col input-group" style="float:right;">
								<select name="changeStatement" id="changeStatement${saleVO.idx}" class="custom-select" onchange="changeThisStatement(${saleVO.idx})">
									<option value="QUOTE" ${saleVO.statement=="QUOTE" ? "selected" : ""}>견적요청</option>
									<option value="CANCEL" ${saleVO.statement=="CANCEL" ? "selected" : ""}>취소</option>
									<option value="CHECK" ${saleVO.statement=="CHECK" ? "selected" : ""}>견적발송</option>
									<option value="ORDERING" ${saleVO.statement=="ORDERING" ? "selected" : ""}>발주요청</option>
									<option value="DELIVER" ${saleVO.statement=="DELIVER" ? "selected" : ""}>발주진행</option>
									<option value="PAYMENT" ${saleVO.statement=="PAYMENT" ? "selected" : ""}>결제대기</option>
									<option value="COMPLETE" ${saleVO.statement=="COMPLETE" ? "selected" : ""}>진행완료</option>
								</select>
							</div>
						</div>
						<table class="table table-bordered">
							<tr>
								<th>견적번호</th>
								<td>${saleVO.idx}</td>
							</tr>
							<tr>
								<th>회사명</th>
								<td>${saleVO.co_name}</td>
							</tr>
							<tr>
								<th>담당자</th>
								<td>${saleVO.memberMid}</td>
							</tr>
							<tr>
								<th>연락처</th>
								<td>${saleVO.tel}</td>
							</tr>
							<tr>
								<th>이메일</th>
								<td><a href="${ctp}/admin/emailInput/${saleVO.memberMid}">${saleVO.email}</a></td>
							</tr>
							<tr>
								<th>내용</th>
								<td>${fn:replace(saleVO.etcDetail,newLine,'<br/>')}</td>
							</tr>
							<tr>
								<th>견적 요청일자</th>
								<td>${fn:substring(saleVO.requestDate,0,10)}</td>
							</tr>
						</table>
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
								<th>가격</th>
								<td>${vo.proPrice}</td>
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
							<c:if test="${saleVO.statement == 'QUOTE'}">
								<a href="${ctp}/admin/product/estimateInput?idx=${saleVO.idx}" class="btn btn-main btn-icon-md mr-2 mb-2">견적서 송부</a>
							</c:if>
							<input type="button" onclick="makeOrder(${saleVO.idx})" value="발주 진행" id="makeOrderBtn" class="btn btn-main btn-icon-md mr-2 mb-2">
							<c:if test="${saleVO.statement == 'DELIVER' || saleVO.statement == 'PAYMENT'}">
								<a href="javascript:paymentCheck(${saleVO.idx})" class="btn btn-main btn-icon-md mr-2 mb-2">결제 확인</a>
							</c:if>
							<a href="productEstimate" class="btn btn-main-3 btn-icon-md mb-2">목록으로</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
</div>
<p><br/></p>	
</body>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=72ddec57bb46287e893efd27beb4a21e&libraries=services"></script>
<script>
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	mapOption = { 
	    center: new kakao.maps.LatLng('${addressVO.latitude}', '${addressVO.longitude}'), // 지도의 중심좌표
	    level: 3 // 지도의 확대 레벨
	};
	var map = new kakao.maps.Map(mapContainer, mapOption);
	// 마커가 표시될 위치입니다 
	var markerPosition  = new kakao.maps.LatLng('${addressVO.latitude}', '${addressVO.longitude}'); 
	// 마커를 생성합니다
	var marker = new kakao.maps.Marker({
	    position: markerPosition
	});
	// 마커가 지도 위에 표시되도록 설정합니다
	marker.setMap(map);
	var iwContent = '<div style="padding:5px;">${addressVO.addressName}<br>';
			iwContent += '<a href="https://map.kakao.com/link/map/${addressVO.addressName},${addressVO.latitude},${addressVO.longitude}" style="color:#0E2B5E;" target="_blank">큰지도보기</a> / ';
			iwContent += '<a href="https://map.kakao.com/link/to/${addressVO.addressName},${addressVO.latitude},${addressVO.longitude}" style="color:#0E2B5E;" target="_blank">길찾기</a></div>',
	    iwPosition = new kakao.maps.LatLng('${addressVO.latitude}', '${addressVO.longitude}'); //인포윈도우 표시 위치입니다
	
	// 인포윈도우를 생성합니다
	var infowindow = new kakao.maps.InfoWindow({
	    position : iwPosition, 
	    content : iwContent 
	});
	  
	// 마커 위에 인포윈도우를 표시합니다. 두번째 파라미터인 marker를 넣어주지 않으면 지도 위에 표시됩니다
	infowindow.open(map, marker); 
</script>
</html>