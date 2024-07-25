<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>작성한 댓글</title>
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
  	
		function replySearch() {
			let part = $("#part").val();
			let searchString = $("#searchString").val();
			if(searchString.trim()=="") {
				alert("검색어를 입력하세요.");
				return false;
			}
			location.href="${ctp}/member/writeReply?part="+part+"&searchString="+searchString;
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
				<div class="row"></div>
				<div class="row mb-3">
					<div class="col-md-5">
						<div class="input-group">
							<select name="part" id="part" class="form-control">
								<option value="content">내용</option>
							</select>
							<input type="text" name="searchString" id="searchString" class="form-control" style="height:36px;" required />
							<div class="input-group-append">
								<a href="javascript:replySearch()" class="btn btn-main btn-icon-md btn-round" style="padding:0.3rem 0.5rem;">검색<i class="fa-solid fa-magnifying-glass ml-1"></i></a>
							</div>
						</div>
					</div>
					<div class="col-md-3">
						<input type="button" onclick="location.href='writeReply';" value="전체보기" class="btn btn-main-2 btn-icon-md btn-round-full" style="padding:0.3rem 0.5rem;"/>
					</div>
				</div>
				<table class="table table-hover text-center">
					<tr style="background:#003675; color:#fff;">
						<th>게시판</th>
						<th>댓글내용</th>
						<th>작성일</th>
					</tr>
					<c:if test="${!empty replyVOS}">
						<c:forEach var="replyVO" items="${replyVOS}">
							<tr>
								<td>
									${replyVO.board=='freeBoard' ? '자유게시판' : ''}
									${replyVO.board=='questionBoard' ? 'Q&A게시판' : ''}
									${replyVO.board=='recruitBoard' ? '채용공고' : ''}
								</td>
								<c:set var="length" value="${fn:length(replyVO.content)}"/>
								<c:set var="board" value="${replyVO.board}"/>
								<td>
									<a href="${ctp}/customer/board/${board}Content?idx=${replyVO.boardIdx}">
										<c:if test="${length > 10}">${fn:substring(replyVO.content, 0, 10)}......</c:if>
										<c:if test="${length <= 10}">${replyVO.content}</c:if>
									</a>
								</td>
								<td>${fn:substring(replyVO.replyDate, 0, 10)}</td>
							</tr>
						</c:forEach>
					</c:if>
				</table>
				<!-- 블록페이지 시작 -->	
				<div class="row mt-5">
				  <div class="col text-center">
				    <nav class="pagination py-2 d-inline-block">
				      <div class="nav-links">
				        <c:if test="${pageVO.pag > 1}"><a class="page-numbers" href="writeReply?pag=1&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-left"></i></a></c:if>
				        <c:if test="${pageVO.curBlock > 0}"><a class="page-numbers" href="writeReply?pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-left"></i></a></c:if>
								<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
									<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><span aria-current="page" class="page-numbers current">${i}</span></c:if>
									<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><a class="page-numbers" href="writeReply?pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></c:if>
								</c:forEach>
								<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><a class="page-numbers" href="writeReply?pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-right"></i></a></c:if>
								<c:if test="${pageVO.pag < pageVO.totPage}"><a class="page-numbers" href="writeReply?pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-right"></i></a></c:if>
				    	</div>
				  	</nav>
					</div>
				</div>
				<!-- 블록페이지 끝 -->	
				<p><br/></p>
			</div>
		</div>
		
	</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>