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
  <title>견적서 출력</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js" integrity="sha512-GsLlZN/3F2ErC5ifS5QtgpiJtWd43JWSuIgh7mbzZ8zBps+dvLusV+eNQATqgA/HdeKFVgA5v3S/cIrLF7QnIg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<style>
		img {
	    max-width: 100%;
	    height: auto;
		}
	</style>
	<script>
		'use strict';
		
		function wClose(){
			window.close();
		}
		
		function printContent() {
			var element = document.getElementById('element-to-print');
			var opt = {
					  margin:       [20,20,0,20],
					  filename:     '${vo.co_name}_견적서.pdf',
					  image:        { type: 'jpeg', quality: 0.98 },
					  html2canvas:  { height: element.offsetHeight, scale: 2 , useCORS: true},
					  jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' },
					  pagebreak: {mode: ['avoid-all', 'css', 'legacy']}
					};
			var worker = html2pdf().set(opt).from(element).save();
		}
	</script>
</head>
<body id="top">
<p><br/></p>
<div class="container">
	<div id="element-to-print">
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
	<hr/>
	<input type="button" onclick="printContent()" value="출력하기" class="btn btn-main-2 btn-icon-md mb-2"/>
	<input type="button" onclick="wClose()" value="취소" class="btn btn-main-3 btn-icon-md mb-2 ml-2"/>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
</body>
</html>