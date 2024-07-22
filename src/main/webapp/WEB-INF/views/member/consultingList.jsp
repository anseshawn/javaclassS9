<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>문의 내역</title>
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
  	
		function modalView(idx) {
			let str = "<table class='table text-left'>";
			$.ajax({
				url: "${ctp}/member/consultingContent",
				type: "post",
				data: {idx : idx},
				success: function(cVo) {
					let writeDate = cVo.writeDate.substring(0,10);
					let completeDate = cVo.completeDate.substring(0,10);
					let content = cVo.content.replace(/\n/g,'<br/>');
					let answer = cVo.answer.replace(/\n/g,'<br/>');
					str += "<tr><th>등록번호</th><td colspan='3'><span id='contentIdx'>"+cVo.idx+"</span></td></tr>";
					str += "<tr><th>주제</th><td colspan='3'>"+cVo.title+"</td></tr>";
					str += "<tr><th>문의 날짜</th><td>"+writeDate+"</td><th>답변 날짜</th><td>"+completeDate+"</td></tr>";
					str += "<tr><th>문의 내용</th><td colspan='3'>"+content+"</td></tr>";
					str += "<tr><th>답변</th><td colspan='3'>"+answer+"</td></tr>";
					str += "</table>";
					$("#content").html(str);
				},
				error: function() {
					alert("전송 오류");
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
					<div class="col text-right"><h3>문의내역</h3></div>
				</div>
				<div class="row mb-3">
					<p><br/></p>
					<table class="table table-hover text-center">
						<tr style="background:#003675; color:#fff;">
							<th>신청번호</th>
							<th>분류</th>
							<th>주제</th>
							<th>문의일자</th>
							<th>답변일자</th>
							<th>진행현황</th>
							<th>답변보기</th>
						</tr>
						<c:forEach var="vo" items="${vos}">
							<tr>
								<td>${vo.idx}</td>
								<td>
									${vo.part=='SERVICE' ? '온라인 상담' : '불편사항'}
								</td>
								<td>${vo.title}</td>
								<td>
									${vo.date_diff==0 ? fn:substring(vo.writeDate,11,19) : fn:substring(vo.writeDate,0,10)}
								</td>
								<td>
									<c:if test="${!empty vo.completeDate}">
										${vo.date_diffC==0 ? fn:substring(vo.completeDate,11,19) : fn:substring(vo.completeDate,0,10)}
									</c:if>
								</td>
								<td>
									<c:if test="${empty vo.completeDate}"><font color="#E71825">답변미등록</font></c:if>
									<c:if test="${!empty vo.completeDate}">
										<font color="#717171">답변등록</font>
									</c:if>
								</td>
								<td>
									<c:if test="${!empty vo.completeDate}">
										<a href="#" onclick="modalView('${vo.idx}')" data-toggle="modal" data-target="#myModal" class="btn btn-main btn-icon-sm">
											GO<i class="fa-solid fa-chevron-right ml-2"></i>
										</a>
									</c:if>
								</td>
							</tr>
						</c:forEach>
					</table>
				</div>
				<!-- 블록페이지 시작 -->	
			  <div class="row mt-5">
			    <div class="col text-center">
			      <nav class="pagination py-2 d-inline-block">
			        <div class="nav-links">
			          <c:if test="${pageVO.pag > 1}"><a class="page-numbers" href="consultingList?pag=1&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-left"></i></a></c:if>
			          <c:if test="${pageVO.curBlock > 0}"><a class="page-numbers" href="consultingList?pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-left"></i></a></c:if>
								<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
									<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><span aria-current="page" class="page-numbers current">${i}</span></c:if>
									<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><a class="page-numbers" href="consultingList?pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></c:if>
								</c:forEach>
								<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><a class="page-numbers" href="consultingList?pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-right"></i></a></c:if>
								<c:if test="${pageVO.pag < pageVO.totPage}"><a class="page-numbers" href="consultingList?pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-right"></i></a></c:if>
			      	</div>
			    	</nav>
					</div>
				</div>
				<!-- 블록페이지 끝 -->	
			</div>
		</div>
		
	</div>
	<!-- 문의 내용과 답변 입력 창 모달에 출력하기 -->
	<div class="modal fade" id="myModal">
	  <div class="modal-dialog modal-lg modal-dialog-centered">
	    <div class="modal-content">
	      <!-- Modal Header -->
	      <div class="modal-header text-center">
	        <h4 class="modal-title">답변 내용 보기</h4>
	        <button type="button" class="close" data-dismiss="modal">&times;</button>
	      </div>
	      <!-- Modal body -->
	      <div class="modal-body">
	    		<span id="content"></span>
	    		<hr/>
	      </div>
	      <!-- Modal footer -->
	      <div class="modal-footer">
	        <button type="button" class="btn btn-main-3 btn-icon-md" data-dismiss="modal">Close</button>
	      </div>
	    </div>
	  </div>
	</div>

</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>