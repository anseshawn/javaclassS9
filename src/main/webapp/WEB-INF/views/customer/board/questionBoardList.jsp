<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Q&A 게시판</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<style>
		.writeNickName {
			cursor: pointer;
		}
		
		.menu-container {
	    position: relative;
	    display: inline-block;
		}
		
		.menu {
	    position: absolute;
	    top: 100%;
	    left: 0;
	    background-color: white;
	    border: 1px solid #ccc;
	    padding: 5px;
	    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	    z-index: 100;
		}
		
		.menu ul {
	    list-style-type: none;
	    margin: 0;
	    padding: 0;
	  	white-space: nowrap;
		}
		
		.menu li {
			display: inline-block;
			margin-right: 10px;
	    margin-bottom: 5px;
		}
		
		.menu a {
	    display: block;
	    padding: 5px;
	    text-decoration: none;
	    color: #333;
		}
		
		.menu a:hover {
	    color: #6F8BA4;
		}
		
		.hidden {
	    display: none;
		}
	</style>
	<script>
		'use strict';
		
		document.addEventListener('DOMContentLoaded', function() {
	    var menus = document.querySelectorAll('.menu-container');

	    menus.forEach(function(menuContainer) {
        var writeNickName = menuContainer.querySelector('.writeNickName');
        var menu = menuContainer.querySelector('.menu');
        // 닉네임을 클릭하면 메뉴를 토글합니다
        writeNickName.addEventListener('click', function() {
            menu.classList.toggle('hidden');
        });
	        // 화면의 다른 곳을 클릭하면 메뉴를 숨깁니다
        document.addEventListener('click', function(event) {
          if (!menuContainer.contains(event.target)) {
              menu.classList.add('hidden');
          }
        });
	  	});
		});
		
		function pageSizeCheck(){
			let pageSize = $("#pageSize").val();
			location.href = "${ctp}/customer/board/questionBoardList?pageSize="+pageSize;
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
		
		function searchEnter(){
			searchForm.submit();
		}
		
		function sendMessage(receiveMid){
			let url = "${ctp}/member/sendMessage?receiveMid="+receiveMid;
			let widthSize= 450;
			let heightSize = 500;
			let leftCenter = Math.ceil((window.screen.width - widthSize)/2);
			let topCenter = Math.ceil((window.screen.height - heightSize)/2);
			window.open(
				url, // url
				'쪽지 보내기', // title
				'width='+widthSize+', height='+heightSize+', top='+topCenter+', left='+leftCenter // 설정
			);
		}
	</script>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container">

<section class="page-title bg-3">
  <div class="overlay"></div>
  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <div class="block text-center">
          <span class="text-white">실험에 관한 질문을 올려주세요</span>
          <h1 class="text-capitalize text-lg"><a href="${ctp}/customer/board/questionBoardList" style="color: #fff;">Q & A</a></h1>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="section blog-wrap">
	<div class="container">
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
					<th width="40%">제목</th>
					<th width="15%">작성자</th>
					<th width="15%">작성일</th>
					<th width="10%">조회수</th>
					<th width="5%"><i class="icofont-thumbs-up mr-1"></i></th>
				</tr>
				<c:set var="curScrStartNo" value="${pageVO.curScrStartNo}"/>
				<c:forEach var="vo" items="${vos}" varStatus="st">
					<tr>
						<td>${curScrStartNo}</td>
						<td class="text-left"><a href="questionBoardContent?idx=${vo.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}">${vo.title}</a> (${vo.replyCnt})</td>
						<td>
							<div class="menu-container">
								<span class="writeNickName">${vo.nickName}</span>
								<div class="menu hidden">
	                <ul>
	                  <li><a href="javascript:sendMessage('${vo.mid}')">쪽지 보내기</a></li>
	                </ul>
		            </div>
			        </div>
						</td>
						<td>${vo.date_diff == 0 ? fn:substring(vo.writeDate,11,19) : fn:substring(vo.writeDate,0,10)}</td>
						<td>${vo.readNum}</td>
						<td>${vo.good}</td>
					</tr>
					<c:set var="curScrStartNo" value="${curScrStartNo-1}"/>
				</c:forEach>
				<tr><td colspan="6" class="m-0 p-0"></td></tr>
			</table>

		<!-- 블록페이지 시작(목록 아래 딱 붙어 나오도록) -->	
    <div class="row mt-5">
      <div class="col-lg-9">
        <nav class="pagination py-2 d-inline-block">
          <div class="nav-links">
	          <c:if test="${pageVO.pag > 1}"><a class="page-numbers" href="questionBoardList?pag=1&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-left"></i></a></c:if>
	          <c:if test="${pageVO.curBlock > 0}"><a class="page-numbers" href="questionBoardList?pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-left"></i></a></c:if>
						<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
							<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><span aria-current="page" class="page-numbers current">${i}</span></c:if>
							<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><a class="page-numbers" href="questionBoardList?pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></c:if>
						</c:forEach>
						<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><a class="page-numbers" href="questionBoardList?pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-right"></i></a></c:if>
						<c:if test="${pageVO.pag < pageVO.totPage}"><a class="page-numbers" href="questionBoardList?pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-right"></i></a></c:if>
        	</div>
      	</nav>
			</div>
		</div>
		<!-- 블록페이지 끝 -->
		</div>
		
		<div class="col-lg-3">
			<div class="sidebar-wrap pl-lg-4 mt-5 mt-lg-0">
			<c:if test="${!empty sLevel && sLevel != 1}">
				<div class="sidebar-widget write text-center mb-5 ">
					<a href="${ctp}/customer/board/questionBoardInput" class="btn btn-main btn-icon btn-round" style="width:80%;">질문하기</a>
				</div>
			</c:if>	
			<!-- 검색창 -->
			<div class="sidebar-widget search mb-3 ">
				<h5>질문 검색</h5>
				<form name="searchForm" method="post">
					<select name="search" id="search" class="form-control" onchange="searchValue()">
						<option value="title">제목</option>
						<option value="nickName">작성자</option>
						<option value="content">내용</option>
						<option value="part">분류</option>
					</select>
					<select name="partSelect" id="partSelect" class="form-control mt-2" style="display:none;">
						<option>실험방법</option>
						<option>실험장비</option>
						<option>법규</option>
						<option>기타</option>
					</select>
					<input type="text" name="searchString" id="searchString" class="form-control mt-2" placeholder="검색어를 입력하세요." required />
					<i class="ti-search"></i>
					<div class="text-right"><a href="javascript:searchEnter()" class="btn btn-main btn-icon-sm btn-round mt-2"><i class="icofont-search-2"></i> 검색</a></div>
				</form>
			</div>
			<!-- 검색창 끝 -->
			
			<div class="sidebar-widget latest-post mb-2">
				<h5>최근 댓글</h5>
				<c:forEach var="recentVO" items="${recentVOS}" varStatus="st">
	     		<div class="py-1">
	      		<span class="text-sm text-muted">${recentVO.date_diff == 0 ? fn:substring(recentVO.writeDate,11,19) : fn:substring(recentVO.writeDate,0,10) }</span>
	          <h6 class="my-1"><a href="questionBoardContent?idx=${recentVO.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}">${recentVO.title}</a></h6>
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