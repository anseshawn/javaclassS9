<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>공지사항</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<style>
		.btn:disabled {
			pointer-events: none;
      cursor: none;
		}
		.badge.delete {
			background-color: #EC4651;
			color: #fff;
		}
	</style>
	<script>
		'use strict';
		
		function pageSizeCheck(){
			let pageSize = $("#pageSize").val();
			location.href = "${ctp}/company/noticeList?pageSize="+pageSize;
		}
		
		function searchValue(){
			if($("#search").val()=='part') {
				$("#partSelect").show();
				$("#searchString").hide();
			}
			else {
				$("#partSelect").hide();
				$("#searchString").show();				
			}
		}
		
		// 게시판 검색
		function noticeSearch() {
			let part = $("#search").val();
			let searchString = $("#searchString").val();
			if(part.trim()=="") {
				alert("검색 분류를 선택하세요.");
				return false;
			}
			if(part != 'part' && searchString.trim()=="") {
				alert("검색어를 입력하세요.");
				return false;
			}
			if(part=='part') searchString = $("#partSelect").val();
			location.href="${ctp}/company/noticeList?pag=${pageVo.pag}&pageSize=${pageVo.pageSize}&part="+part+"&searchString="+searchString;
		}
		
	</script>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<p><br/></p>
<div class="container">

<section class="page-title bg-2">
  <div class="overlay"></div>
  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <div class="block text-center">
          <span class="text-white">공지사항</span>
          <h1 class="text-capitalize mb-5 text-lg"><a href="${ctp}/company/noticeList">Notice</a></h1>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="section blog-wrap">
	<div class="container">
		<c:if test="${pageVO.part != '' }">
			<div class="row">
				<div class="col-lg-9"><h2>검색결과</h2></div>
				<br/>
				<div class="col-lg-9" style="font-size:1.2rem;"><p>${part}(으)로 '${searchString}'(을)를 검색한 결과 <b>${searchCount}</b> 건의 게시글이 검색되었습니다.</p></div>
			</div>
			<div class="row mb-2">
				<div class="col-lg-9 text-right">
					<a href="noticeList" class="btn btn-main btn-icon-sm btn-round">전체목록으로</a>
				</div>
			</div>
		</c:if>
		<div class="row mb-3">
			<div class="col-sm-9 search text-right">
				<select name="pageSize" id="pageSize" onchange="pageSizeCheck()">
					<option value="5" ${pageVO.pageSize==5 ? "selected" : ""}>5개 보기</option>
					<option value="10" ${pageVO.pageSize==10 ? "selected" : ""}>10개 보기</option>
					<option value="20" ${pageVO.pageSize==20 ? "selected" : ""}>20개 보기</option>
				</select>
			</div>
		</div>
		<div class="row">
		<div class="col-lg-9">
 			<table class="table table-hover text-center">
				<tr style="pointer-events: none; background:#223a66; color:#fff;">
					<th width="10%">번호</th>
					<th width="15%">구분</th>
					<th width="40%">제목</th>
					<th width="15%">작성자</th>
					<th width="20%">작성일</th>
				</tr>
				<c:forEach var="iVo" items="${imVos}" varStatus="st">
					<tr>
						<td><input type="button" value="중요" class="btn btn-main btn-icon-sm" disabled/></td>
						<td>
							${vo.part=='events' ? '이벤트' : ''}
							${vo.part=='notices' ? '일반공지' : ''}
						</td>
						<td class="text-left">
							<a href="noticeContent?idx=${vo.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}">${vo.title}</a>
							<c:if test="${!empty vo.endDate && today > fn:substring(vo.endDate,0,10)}">
								<a href="#" class="badge delete">종료</a>
							</c:if>
						</td>
						<td>관리자</td>
						<td>${iVo.date_diff == 0 ? fn:substring(vo.writeDate,11,19) : fn:substring(iVo.writeDate,0,10)}</td>
					</tr>
				</c:forEach>
				<c:set var="curScrStartNo" value="${pageVO.curScrStartNo}"/>
				<c:forEach var="vo" items="${vos}" varStatus="st">
					<tr>
						<td>${curScrStartNo}</td>
						<td>
							${vo.part=='events' ? '이벤트' : ''}
							${vo.part=='notices' ? '일반공지' : ''}
						</td>
						<td class="text-left"><a href="noticeContent?idx=${vo.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}">${vo.title}</a></td>
						<td>관리자</td>
						<td>${vo.date_diff == 0 ? fn:substring(vo.writeDate,11,19) : fn:substring(vo.writeDate,0,10)}</td>
					</tr>
					<c:set var="curScrStartNo" value="${curScrStartNo-1}"/>
				</c:forEach>
				<tr><td colspan="6" class="m-0 p-0"></td></tr>
			</table>

		<!-- 블록페이지 시작(목록 아래 딱 붙어 나오도록) -->	
    <div class="row mt-5 align-items-center">
      <div class="col-lg-9">
        <nav class="pagination py-2 d-inline-block">
          <div class="nav-links">
	          <c:if test="${pageVO.pag > 1}"><a class="page-numbers" href="noticeList?pag=1&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-left"></i></a></c:if>
	          <c:if test="${pageVO.curBlock > 0}"><a class="page-numbers" href="noticeList?pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-left"></i></a></c:if>
						<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
							<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><span aria-current="page" class="page-numbers current">${i}</span></c:if>
							<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><a class="page-numbers" href="noticeList?pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></c:if>
						</c:forEach>
						<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><a class="page-numbers" href="noticeList?pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-right"></i></a></c:if>
						<c:if test="${pageVO.pag < pageVO.totPage}"><a class="page-numbers" href="noticeList?pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-right"></i></a></c:if>
        	</div>
      	</nav>
			</div>
		</div>
		<!-- 블록페이지 끝 -->
		</div>
		
		<div class="col-lg-3">
			<div class="sidebar-wrap pl-lg-4 mt-5 mt-lg-0">
			<c:if test="${!empty sLevel && sLevel == 0}">
				<div class="sidebar-widget write text-center mb-5 ">
					<a href="${ctp}/admin/company/noticeInput" class="btn btn-main btn-icon btn-round" style="width:80%;">공지 작성</a>
				</div>
			</c:if>	
			<!-- 검색창 -->
			<div class="sidebar-widget search mb-3 ">
				<h5>검색</h5>
				<select name="search" id="search" class="form-control" onchange="searchValue()">
					<option value="title">제목</option>
					<option value="content">내용</option>
					<option value="part">분류</option>
				</select>
				<select name="partSelect" id="partSelect" class="form-control mt-2" style="display:none;">
					<option>공지사항</option>
					<option>이벤트</option>
				</select>
				<input type="text" name="searchString" id="searchString" class="form-control mt-2" placeholder="검색어를 입력하세요." required />
				<i class="ti-search"></i>
				<div class="text-right"><a href="javascript:noticeSearch()" class="btn btn-main btn-icon-sm btn-round mt-2"><i class="icofont-search-2"></i> 검색</a></div>
			</div>
			<!-- 검색창 끝 -->
			</div>
		</div>
		</div>
	</div>
</section>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>