<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>자유게시판</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<style>
		.blog-item-content .title {
		  font-weight: 700;
		  font-size: 1.75rem;
		}
		
		.pagination .page-item {
			background-color: #C7C3BB;
		}
		
		.pagination .page-item a {
			color: #fff;
		}
		
	</style>
	<script>
		'use strict';

		// 게시판 검색
		function boardSearch() {
			let part = $("#search").val();
			let searchString = $("#searchString").val();
			if(part.trim()=="") {
				alert("검색 분류를 선택하세요.");
				return false;
			}
			if(searchString.trim()=="") {
				alert("검색어를 입력하세요.");
				return false;
			}
			location.href="${ctp}/customer/board/freeBoardList?pag=${pageVo.pag}&pageSize=${pageVo.pageSize}&part="+part+"&searchString="+searchString;
		}

	</script>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container">
	
<section class="page-title bg-1">
  <div class="overlay"></div>
  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <div class="block text-center">
          <span class="text-white">다양한 이야기를 올려주세요</span>
          <h1 class="text-capitalize mb-5 text-lg"><a href="${ctp}/customer/board/freeBoardList" style="color: #fff;">자유게시판</a></h1>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="section blog-wrap">
	<div class="container">
		<c:if test="${!empty part}">
			<div class="row">
				<div class="col-lg-12"><h2>검색결과</h2></div>
				<br/>
				<div class="col-lg-12" style="font-size:1.2rem;"><p>${part}(으)로 '${searchString}'(을)를 검색한 결과 <b>${searchCount}</b> 건의 게시글이 검색되었습니다.</p></div>
			</div>
		</c:if>
	
		<div class="row">
 			<div class="col-lg-8">
				<div class="row">

					<c:set var="curScrStartNo" value="${curScrStartNo}"/>
					<c:forEach var="vo" items="${vos}" varStatus="st">
						<div class="col-lg-12 col-md-12 mb-3">
							<div class="blog-item">
								<div class="blog-item-content">
									<div class="blog-item-meta mb-3 mt-4">
										<span class="text-muted text-capitalize mr-3"><i class="fa-solid fa-eye mr-2"></i>${vo.readNum}</span>
										<span class="text-muted text-capitalize mr-3"><i class="icofont-comment mr-2"></i>${vo.replyCnt} Comments</span>
										<span class="text-black text-capitalize mr-3">
											<i class="icofont-calendar mr-2"></i> ${vo.date_diff == 0 ? fn:substring(vo.writeDate,11,19) : fn:substring(vo.writeDate,0,10) }
										</span>
										<span class="user-name text-muted text-capitalize mr-3">
											<i class="icofont-user mr-2"></i>${vo.nickName}
										</span>
										<!-- 								
								    <div id="userMenu" class="menu">
							        <ul>
						            <li onclick="sendMessage()">쪽지 보내기</li>
						            <li onclick="reportUser()">유저 신고하기</li>
							        </ul>
							    	</div>
							    	 -->
									</div> 
									<div class="title mt-3 mb-3">
										<a href="${ctp}/customer/board/freeBoardContent?idx=${vo.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}">${vo.title}</a>
										<a href="${ctp}/customer/board/freeBoardContent?idx=${vo.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}" target="_blank" class="btn btn-main btn-icon-sm btn-round-full ml-2">
											새창으로 보기<i class="fa-solid fa-up-right-from-square ml-2"></i>
										</a>
									</div>
								</div>
							</div>
							<hr/>			
						</div>
					</c:forEach>
				</div>
				
				<!-- 블록페이지 시작 -->	
				<div class="text-center">
					<ul class="pagination justify-content-center" style="margin:20px 0">
						<c:if test="${pageVO.pag > 1}"><li class="page-item"><a class="page-link" href="freeBoardList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=1&pageSize=${pageVO.pageSize}">처음</a></li></c:if>
						<c:if test="${pageVO.curBlock > 0}"><li class="page-item"><a class="page-link" href="freeBoardList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">이전블록</a></li></c:if>
						<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
							<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><li class="page-item active"><a class="page-link" href="freeBoardList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
							<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><li class="page-item"><a class="page-link" href="freeBoardList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
						</c:forEach>
						<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><li class="page-item"><a class="page-link" href="freeBoardList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">다음블록</a></li></c:if>
						<c:if test="${pageVO.pag < pageVO.totPage}"><li class="page-item"><a class="page-link" href="freeBoardList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}">끝</a></li></c:if>
					</ul>
				</div>
				<!-- 블록페이지 끝 -->
			</div>
			
			<div class="col-lg-4">
				<div class="sidebar-wrap pl-lg-4 mt-5 mt-lg-0">
				<c:if test="${!empty sLevel && sLevel != 1}">
					<div class="sidebar-widget write mb-3 text-center">
						<a href="${ctp}/customer/board/freeBoardInput" class="btn btn-main-2 btn-icon btn-round-full" style="width:80%; margin:8px;">글쓰기</a>
					</div>
				</c:if>	
					<!-- 검색창 -->
					<div class="sidebar-widget search mb-3 ">
						<h5>게시판 검색</h5>
						<select name="search" id="search" class="form-control">
							<option value="title">제목</option>
							<option value="nickName">작성자</option>
							<option value="content">내용</option>
						</select>
						<div class="input-group mb-1">
							<input type="text" name="searchString" id="searchString" class="form-control mt-2" placeholder="검색어를 입력하세요." required />
							<i class="ti-search"></i>
							<div class="input-group-append">
								<!-- <input type="submit" value="search" class="btn btn-main btn-icon-sm btn-round mt-2"/> -->
								<button onclick="boardSearch()" class="btn btn-main-2 btn-icon-md btn-round mt-2">검색<i class="fa-solid fa-magnifying-glass ml-2"></i></button>
							</div>
						</div>
					</div>
					<!-- 검색창 끝 -->
					
					<div class="sidebar-widget latest-post mb-3">
						<h5>인기 게시글</h5>
						<c:forEach var="gVo" items="${gVos}" varStatus="st">
	        		<div class="py-2">
		        		<span class="text-sm text-muted">${gVo.date_diff == 0 ? fn:substring(gVo.writeDate,11,19) : fn:substring(gVo.writeDate,0,10) }</span>
		            <h6 class="my-2"><a href="${ctp}/customer/board/freeBoardContent?idx=${gVo.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}">${gVo.title}</a></h6>
	        		</div>
        		</c:forEach>
					</div>

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