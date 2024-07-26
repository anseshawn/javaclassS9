<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 견적서 작성</title>
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
	<style>
	  body {
	    margin: 20px;
	  }
	  table {
	    width: 100%;
	    border-collapse: collapse;
	    margin-bottom: 20px;
	  }
	  table, th, td {
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
		
		function fCheck() {
			myform.submit();
		}
		
		function numberChange(){
			let quantity = document.getElementById("quantity").value;
			let proPrice = document.getElementById("proPrice").value;
			let unitPrice = proPrice * quantity;
			let vat = unitPrice * 0.1;
			let totPrice = unitPrice + vat;
			
			$("#productPrice").text(proPrice);
			$("#inputQuantity").text(quantity);
			$(".unitPrice").text(unitPrice);
			$("#vat").text(vat);
			$("#totPrice").text(totPrice);
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
<div class="spinner-border text-muted" id="spinner" style="display:none;"></div>
	<div class="text-center"><h2>견적서 발송</h2></div>
	<div class="divider2 mx-auto my-4 text-center" style="width:70%;"></div>
	<form name="myform" method="post" class="was-validated">
		<div class="row justify-content-center mb-3">
			<div class="col-md-8">
				<div class="row justify-content-center mb-3">
					<div class="col-md-10"><h4>기기명</h4>
		        <input type="text" name="proName" id="proName" value="${vo.proName}" class="form-control" required readonly>
					</div>
				</div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-5"><label for="proPrice">단가</label>
		        <input type="number" name="proPrice" id="proPrice" value="${vo.proPrice}" oninput="numberChange()" class="form-control" required>
					</div>
					<div class="col-md-5"><label for="quantity">수량</label>
		        <input type="number" name="quantity" id="quantity" oninput="numberChange()" maxlength="3" class="form-control" required/>
					</div>
				</div>
			</div>
		</div>

		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2 text-center">
				<input type="button" value="견적서 전송" onclick="fCheck()" class="btn btn-main btn-icon-md btn-round-full mr-2" />
				<input type="button" value="취소" onclick="location.href='${ctp}/admin/product/productEstimateDetail?idx=${saleVO.idx}';" class="btn btn-main-3 btn-icon-md btn-round-full" />
			</div>
		</div>
		<input type="hidden" name="saleIdx" value="${saleVO.idx}" />
		<input type="hidden" name="productIdx" value="${vo.idx}" />
		<input type="hidden" name="name" value="${name}" />
		<input type="hidden" name="email" value="${saleVO.email}" />
		<input type="hidden" name="co_name" value="${saleVO.co_name}" />
	</form>
	<hr/>
	<div class="row justify-content-center mb-3">
		<div class="col-md-8">
		<table class="table">
			<tr class="text-center"><td colspan="4"><h4> 견적서 미리보기</h4></td></tr>
		  <tr>
		    <td class="header-section" colspan="2">${saleVO.co_name}</td>
		    <td class="header-section text-center">사업장명</td>
		    <td class="header-section">그린 엔지니어링</td>
		  </tr>
		  <tr>
		    <td class="header-section" colspan="2">${name}</td>
		    <td class="header-section text-center">Tel.</td>
		    <td class="header-section">043-123-4567</td>
		  </tr>
		  <tr>
		    <td class="header-section" colspan="2">${saleVO.email}</td>
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
		    <td id="inputQuantity"></td>
		    <td id="productPrice">${vo.proPrice}</td>
		    <td class="unitPrice"></td>
		  </tr>
		  <tr><td colspan="4"></td></tr>
		  <tr>
		    <td class="subtotal-section" colspan="3">공급가</td>
		    <td class="subtotal-section unitPrice"></td>
		  </tr>
		  <tr>
		    <td class="subtotal-section" colspan="3">부가세</td>
		    <td class="subtotal-section" id="vat"></td>
		  </tr>
		  <tr>
		    <td class="total-section" colspan="3">합계</td>
		    <td class="total-section" id="totPrice"></td>
		  </tr>
		  <tr><td colspan="4" class="m-0 p-0"></td></tr>
		</table>
		</div>
	</div>
</div>
<p><br/></p>
</body>
</html>