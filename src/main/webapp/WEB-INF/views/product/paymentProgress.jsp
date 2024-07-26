<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>결제하기</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>
  <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
  <style>
  	#spinner {
		  position: absolute;
		  left: 50%;
		  top: 50%;
		  z-index: 1;
		}
  </style>
  <script>
    var IMP = window.IMP;
    IMP.init("imp32885183");

    //function requestPay() {
      IMP.request_pay(
        {
          pg: "html5_inicis.INIpayTest",
          pay_method: "card",
          merchant_uid: "javaclassS9" + new Date().getTime(),
          name : "${eVo.productIdx}",
          amount : "${vo.amount}",
          buyer_email: "${vo.buyer_email}",
          buyer_name: "${vo.buyer_name}",
          buyer_tel: "${vo.buyer_tel}",
          buyer_addr: "${vo.buyer_addr}",
          buyer_postcode: "${vo.buyer_postcode}",
        }, // 여기까진 이니시스에서 제공하는 결제
        function (rsp) { // 이후에 성공하면 내가 제어
					if(rsp.success) {
						message = "결제가 완료되었습니다.";
						icon = "success";
						changeStatement();
					}
					else {
						message = "결제에 실패했습니다. 다시 시도해주세요.";
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
						opener.location.reload();
						window.close();
					});
        }
      );
    //}
    
    function changeStatement(){
    	$.ajax({
    		url: "${ctp}/product/productEstimateChange",
    		type: "post",
    		data: {
    			idx : ${eVo.idx},
    			statement : "PAYMENT",
    			saleIdx : ${eVo.saleIdx}
    		},
    		error: function(){
    			alert("전송오류");
    		}
    	});
    }
  </script>
</head>
<body id="top">
<p><br/></p>
<div class="container">
	<div class="spinner-border text-muted" id="spinner" style="display:block;"></div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
</body>
</html>