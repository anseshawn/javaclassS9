<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>견적서 확인</title>
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
  	.btn:disabled {
      pointer-events: none;
      cursor: none;
  	}
	  body {
	    margin: 20px;
	  }
	  .table {
	    width: 100%;
	    border-collapse: collapse;
	    margin-bottom: 20px;
	  }
	  .table, th, td {
	    padding: 8px;
	    text-align: center;
	  }
	  .header-section {
	    text-align: left;
	    font-weight: bold;
	    background-color: #f2f2f2;
	    padding: 20px;
	  }
	  .subtotal-section {
	    font-weight: bold;
	    background-color: #f2f2f2;
	  }
	  .total-section {
	    font-weight: bold;
	  }
	</style>
	<script>
		'use strict';
    
		$(function(){
			if('${vo.statement}'=='CANCEL') {
				$("#cancelBtn").prop("disabled",true);
				$("#paymentBtn").prop("disabled",true);
				$("#orderBtn").prop("disabled",true);
			}
			if('${vo.statement}'=='CHECK') $("#paymentBtn").prop("disabled",true);
			if('${vo.statement}'!='CHECK') {
				$("#orderBtn").prop("disabled",true);
				$("#cancelBtn").prop("disabled",true);
				$("#searchBtn").prop("disabled", true);
				$("#addAddressBtn").prop("disabled", true);
				$("#orderAddress").prop("disabled",true);
			}
			if('${vo.statement}'=='PAYMENT' || '${vo.statement}'=='COMPLETE') {
				$("#paymentBtn").prop("disabled",true);
			}
		
	    var inputAddress = document.getElementById('orderAddress');
	    var searchBtn = document.getElementById('searchBtn');
	    inputAddress.addEventListener('keyup', function(e) {
	      e.preventDefault();
	      if (e.keyCode == 13) {
	        searchBtn.click();
	      }
	    });
		});
		
		function deleteEstimate() {
	  	let message = "";
			let icon = "";
			Swal.fire({
	    html : "<h3>견적을 취소하시겠습니까?</h3>",
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
						url: "${ctp}/product/productEstimateDelete",
						type: "post",
						data: {
							idx : ${vo.idx},
							saleIdx : ${vo.saleIdx}
						},
						success: function(res){
							if(res != "0") {
								message = "견적을 취소했습니다.";
								icon = "success";
							}
							else {
								message = "견적 취소에 실패했습니다.\n다시 시도해주세요.";
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
								location.href="${ctp}/member/estimateList";
							});
						},
						error: function(){
							alert("전송오류");
						}
					});
				}
			});
		}
		
		function orderRequest() {
	  	let message = "";
			let icon = "";
			Swal.fire({
	    html : "<h3>발주를 요청 하시겠습니까?</h3>",
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
						url: "${ctp}/product/orderRequest",
						type: "post",
						data: {
							idx : ${vo.idx},
							saleIdx : ${vo.saleIdx}
						},
						success: function(res){
							if(res != "0") {
								message = "발주를 요청했습니다.";
								icon = "success";
							}
							else {
								message = "요청에 실패했습니다.\n다시 시도해주세요.";
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
		
		function makePayment() {
			let url = "${ctp}/product/paymentWindow?saleIdx=${vo.saleIdx}";
			let widthSize= 880;
			let heightSize = 630;
			let leftCenter = Math.ceil((window.screen.width - widthSize)/2);
			let topCenter = Math.ceil((window.screen.height - heightSize)/2);
			window.open(
				url, // url
				'결제하기', // title
				'width='+widthSize+', height='+heightSize+', top='+topCenter+', left='+leftCenter // 설정
			);
		}
		
		function saveAddress() {
			let addressName = '${vo.co_name}';
			let latitude = document.getElementById("latitude").value;
			let longitude = document.getElementById("longitude").value;
			console.log(latitude);
			console.log(longitude);
			console.log(addressName);
			
			$.ajax({
				url: "${ctp}/member/estimateAddAddress",
				type: "post",
				data: {
					saleIdx : ${vo.saleIdx},
					addressName : addressName,
					latitude : latitude,
					longitude : longitude
				},
				success: function(res) {
					if(res != 0) {
						$("#searchBtn").prop("disabled", true);
						$("#addAddressBtn").prop("disabled", true);
						$("#orderAddress").prop("disabled",true);
					}
					else alert("등록을 다시 시도해주세요.\n이미 장소를 등록했다면 장소 수정은 관리자에게 문의하세요.");
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
		
		function printContent(saleIdx) {
			let url = "${ctp}/member/printContentWindow?saleIdx="+saleIdx;
			let widthSize= 600;
			let heightSize = 700;
			let leftCenter = Math.ceil((window.screen.width - widthSize)/2);
			let topCenter = Math.ceil((window.screen.height - heightSize)/2);
			window.open(
				url, // url
				'견적서', // title
				'width='+widthSize+', height='+heightSize+', top='+topCenter+', left='+leftCenter // 설정
			);
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
				<div class="row justify-content-center mb-3">
					<div class="col-md-8">
						<c:if test="${vo.statement =='CANCEL'}"><div><font color="#E71825">취소 된 견적 건입니다.</font></div></c:if>
						<c:if test="${vo.statement =='COMPLETE'}"><div><font color="#246BEB">진행 완료된 견적 건입니다.</font></div></c:if>
						<div class="text-right"><input type="button" value="견적서출력" onclick="printContent(${vo.saleIdx})" class="btn btn-main btn-icon-md btn-round-full mb-2"/></div>
						<table class="table">
							<tr class="text-center"><td colspan="4"><h4> 견 적 서</h4></td></tr>
						  <tr>
						    <td class="header-section" colspan="2">${vo.co_name}</td>
						    <td class="header-section text-center">사업장명</td>
						    <td class="header-section">그린 엔지니어링</td>
						  </tr>
						  <tr>
						    <td class="header-section" colspan="2">${vo.name}</td>
						    <td class="header-section text-center">Tel.</td>
						    <td class="header-section">043-123-4567</td>
						  </tr>
						  <tr>
						    <td class="header-section" colspan="2">${vo.email}</td>
						    <td class="header-section" colspan="2"></td>
						  </tr>
						  <tr><td colspan="4"></td></tr>
						  <tr>
						    <th>상품명</th>
						    <th>수량</th>
						    <th>단가</th>
						    <th>가격</th>
						  </tr>
						  <tr>
						    <td>${vo.proName}</td>
						    <td id="inputQuantity">${vo.quantity}</td>
						    <td id="productPrice">${vo.proPrice}</td>
						    <td class="unitPrice">${vo.unitPrice}</td>
						  </tr>
						  <tr><td colspan="4"></td></tr>
						  <tr>
						    <td class="subtotal-section" colspan="3">공급가</td>
						    <td class="subtotal-section unitPrice">${vo.unitPrice}</td>
						  </tr>
						  <tr>
						    <td class="subtotal-section" colspan="3">부가세</td>
						    <td class="subtotal-section" id="vat">${vo.vat}</td>
						  </tr>
						  <tr>
						    <td class="total-section" colspan="3">합계</td>
						    <td class="total-section" id="totPrice">${vo.totPrice}</td>
						  </tr>
						  <tr><td colspan="4" class="m-0 p-0"></td></tr>
						</table>
					</div>
				</div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-8">
						<div>주소를 검색하여 발주처를 등록해주세요.</div>
						<div class="input-group">
							<input type="text" name="orderAddress" id="orderAddress" class="form-control" />
							<input type="button" value="주소검색" onclick="searchAddress()" id="searchBtn" class="btn btn-main btn-icon-md input-group-append"/>
							<input type="button" value="발주처등록" onclick="saveAddress()" id="addAddressBtn" class="btn btn-main-2 btn-icon-md input-group-append"/>
							<input type="hidden" name="latitude" id="latitude" />
							<input type="hidden" name="longitude" id="longitude" />
						</div>
						<!-- 카카오맵 추가 -->
						<div id="map" style="width:100%;height:350px;position:relative;overflow:hidden;"></div>
						<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=72ddec57bb46287e893efd27beb4a21e&libraries=services"></script>
						<script>
							var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
						    mapOption = { 
						        center: new kakao.maps.LatLng(36.63508163115122, 127.459535598743), // 지도의 중심좌표
						        level: 3 // 지도의 확대 레벨
						    };
							var map = new kakao.maps.Map(mapContainer, mapOption);
							if('${oVo.addressName}' && '${oVo.addressName}'!='') {
								// 마커가 표시될 위치입니다 
								let markerPosition  = new kakao.maps.LatLng('${oVo.latitude}', '${oVo.longitude}'); 
								// 마커를 생성합니다
								let marker = new kakao.maps.Marker({
								    position: markerPosition
								});
								// 마커가 지도 위에 표시되도록 설정합니다
								marker.setMap(map);
								map.setCenter(markerPosition);
							}
							
							function searchAddress(){
								let orderAddress = document.getElementById("orderAddress").value;
								// 주소-좌표 변환 객체를 생성합니다
								var geocoder = new kakao.maps.services.Geocoder();
								
								// 주소로 좌표를 검색합니다
								geocoder.addressSearch(orderAddress, function(result, status) {
	
							    // 정상적으로 검색이 완료됐으면 
							     if (status === kakao.maps.services.Status.OK) {
							        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
							        // 결과값으로 받은 위치를 마커로 표시합니다
							        var marker = new kakao.maps.Marker({
							            map: map,
							            position: coords
							        });
							        // 인포윈도우로 장소에 대한 설명을 표시합니다
							        var infowindow = new kakao.maps.InfoWindow({
							            content: '<div style="width:150px;text-align:center;padding:6px 0;">${vo.co_name}</div>'
							        });
							        infowindow.open(map, marker);
							        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
							        map.setCenter(coords);
							        $("#latitude").val(result[0].y);
							        $("#longitude").val(result[0].x);
							     } 
								});
							}	
							
						</script>
					</div>
				</div>
				<hr/>
				<div class="row justify-content-center mb-5">
					<div class="col-md-3 text-left">
						<a href="estimateList" class="btn btn-main-3 btn-icon-md btn-round-full">목록으로</a>
					</div>
					<div class="col-md-5 text-right">
						<input type="button" value="발주요청" id="orderBtn" onclick="orderRequest()" class="btn btn-main btn-icon-md mr-2"/>
						<input type="button" value="결제진행" id="paymentBtn" onclick="makePayment()" class="btn btn-main btn-icon-md mr-2"/>
						<input type="button" value="견적취소" id="cancelBtn" onclick="deleteEstimate()" class="btn btn-main-3 btn-icon-md"/>
					</div>
				</div>
			</div>
		</div>
		
	</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>