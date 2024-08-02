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
  <title>A/S 내용 출력</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js" integrity="sha512-GsLlZN/3F2ErC5ifS5QtgpiJtWd43JWSuIgh7mbzZ8zBps+dvLusV+eNQATqgA/HdeKFVgA5v3S/cIrLF7QnIg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<style>
		.container {
      width: 800px;
      margin: auto;
      padding: 0px;
    }
    .element-to-print {
    	margin: 0 0 0 0;
    	padding: 0 0 0 0;
    }
    .table {
    	margin: 0px;
    	padding: 0px;
      width: 100%;
      border-collapse: collapse;
      page-break-inside: avoid;
    }
		th {
			text-align: center;
		}
    @media print {
	    .table {
	    	page-break-inside: avoid;
	    }
    }
	</style>
	<script>
		'use strict';
		
		function wClose(){
			window.close();
		}
		function printContent() {
			var element = document.getElementById('top');
			//console.log(element.getBoundingClientRect().width);
			//console.log($("#element-to-print").width());
			console.log(element.offsetHeight);
			var opt = {
					  margin:       [0,0,0,0],
					  filename:     '${vo.asName}_수리내역.pdf',
					  image:        { type: 'jpeg', quality: 0.98 },
					  html2canvas:  { height: element.offsetHeight, scale: 2 , useCORS: true},
					  jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' },
					  pagebreak: {mode: ['avoid-all', 'css', 'legacy']}
					};
			html2pdf().set(opt).from(document.body).save();
		}
	</script>
</head>
<body id="top">
<div class="container" id="container">
	<div id="element-to-print">
    <table class="table">
      <tr>
        <th>신청번호 #</th>
        <td>${vo.idx}</td>
        <th colspan="2">고객정보</th>
      </tr>
      <tr>
        <th>제품종류</th>
        <td>${vo.machine}</td>
        <th>회사명</th>
        <td>${vo.asName}</td>
      </tr>
      <tr>
        <th>담당 엔지니어</th>
        <td>${vo.engineerName}</td>
        <th>지역</th>
        <td>${vo.asPlace}</td>
      </tr>
      <tr>
        <th>요청날짜</th>
        <td>${fn:substring(vo.requestDate,0,10)}</td>
        <th>완료날짜</th>
        <td>${fn:substring(vo.endDate,0,10)}</td>
      </tr>
      <tr>
      	<th>문제사항</th>
        <td colspan="3"><c:if test="${empty vo.detailNote}">-</c:if><c:if test="${!empty vo.detailNote}">${fn:replace(vo.detailNote,newLine,'<br/>')}</c:if></td>
      </tr>
      <tr>
        <th>해결내용</th>
        <td colspan="3">
          ${fn:replace(vo.comment,newLine,'<br/>')}
        </td>
      </tr>
  	</table>
	  <table class="table text-center">
			<c:set var="expendable" value="${fn:split(chargeVO.expendableName, ',')}"/>
			<c:set var="quantity" value="${fn:split(chargeVO.quantity, ',')}"/>
      <tr>
        <th colspan="2">소모품명</th>
        <th>수량</th>
      </tr>
      <c:forEach var="i" begin="0" end="${fn:length(expendable)-1}" varStatus="st">
	      <tr>
          <td colspan="2">${expendable[i]}</td>
          <td>${quantity[i]}</td>
	      </tr>
      </c:forEach>
      <tr>
      	<th colspan="2">소모품 총액</th>
      	<td colspan="2"><fmt:formatNumber value="${chargeVO.price}" pattern="#,###"/></td>
      </tr>
      <tr>
      	<th colspan="2">출장비</th>
      	<td colspan="2"><fmt:formatNumber value="${chargeVO.laborCharge}" pattern="#,###"/></td>
      </tr>
	  </table>
	  <table class="table table-bordered">
	    <tr>
	    	<th>총액</th>
	      <th>부가세</th>
	      <th>합계</th>
	    </tr>
	    <tr class="text-right">
	      <td><fmt:formatNumber value="${chargeVO.price + chargeVO.laborCharge}" pattern="#,###"/></td>
	      <td><fmt:formatNumber value="${(chargeVO.price + chargeVO.laborCharge)*0.1}" pattern="#,###"/></td>
	      <td><fmt:formatNumber value="${chargeVO.totPrice}" pattern="#,###"/></td>
	    </tr>
	  </table>
	</div>
	<hr/>
	<div class="text-right">
		<input type="button" onclick="printContent()" value="출력하기" class="btn btn-main-2 btn-icon-md mb-2"/>
		<input type="button" onclick="wClose()" value="취소" class="btn btn-main-3 btn-icon-md mb-2 ml-2"/>
	</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
</body>
</html>