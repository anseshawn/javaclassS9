<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>견적 내역</title>
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
					<div class="col text-right"><h3>견적 내역</h3></div>
				</div>
				<div class="row mb-3">
					<p><br/></p>
					<table class="table table-hover text-center">
						<tr style="background:#003675; color:#fff;">
							<th>견적번호</th>
							<th>견적날짜</th>
							<th>확인</th>
						</tr>
						<c:forEach var="vo" items="${vos}">
							<tr>
								<td>${vo.idx}</td>
								<td>${fn:substring(vo.sendDate, 0, 10)}</td>
								<td><a href="${ctp}/member/estimateContent?saleIdx=${vo.saleIdx}" class="btn btn-main btn-icon-sm">상세보기</a></td>
							</tr>
						</c:forEach>
					</table>
				</div>
				<!-- 블록페이지 시작 -->	
			  <div class="row mt-5">
			    <div class="col text-center">
			      <nav class="pagination py-2 d-inline-block">
			        <div class="nav-links">
			          <c:if test="${pageVO.pag > 1}"><a class="page-numbers" href="estimateList?pag=1&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-left"></i></a></c:if>
			          <c:if test="${pageVO.curBlock > 0}"><a class="page-numbers" href="estimateList?pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-left"></i></a></c:if>
								<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
									<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><span aria-current="page" class="page-numbers current">${i}</span></c:if>
									<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><a class="page-numbers" href="estimateList?pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></c:if>
								</c:forEach>
								<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><a class="page-numbers" href="estimateList?pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-right"></i></a></c:if>
								<c:if test="${pageVO.pag < pageVO.totPage}"><a class="page-numbers" href="estimateList?pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-right"></i></a></c:if>
			      	</div>
			    	</nav>
					</div>
				</div>
				<!-- 블록페이지 끝 -->	
			</div>
		</div>
		
	</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>