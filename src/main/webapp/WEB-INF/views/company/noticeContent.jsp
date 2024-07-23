<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>공지사항 - ${vo.title}</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<script>
		'use strict';
		
		function deleteCheck(){
			let ans = confirm("현재 게시글을 삭제하시겠습니까?");
			if(!ans) return false;
			location.href="${ctp}/admin/company/noticeDelete?idx=${vo.idx}";
		}
		
		// 게시판 검색
		function boardSearch() {
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
			location.href="${ctp}/customer/board/noticeList?pag=${pageVo.pag}&pageSize=${pageVo.pageSize}&part="+part+"&searchString="+searchString;
		}
		
	</script>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
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
		<div class="row">
			<div class="col-lg-8">
				<div class="row">
					<div class="col-lg-12 mb-5">
						<div class="single-blog-item">
							<div class="blog-item-content mt-2">
								<div class="blog-item-meta mb-3">
									<div style="color:#223a66; font-size:1.2rem;">
										<a href="noticeList?pag=1&pageSize=${pageVO.pageSize}&part=part&searchString=${vo.part}"><i class="icofont-ui-folder mr-2"></i>
											${vo.part=='events' ? '이벤트' : ''}
											${vo.part=='notices' ? '일반공지' : ''}</a>
									</div>
									<span class="text-black text-capitalize mr-3"><i class="icofont-calendar mr-2"></i> ${vo.date_diff == 0 ? fn:substring(vo.writeDate,11,19) : fn:substring(vo.writeDate,0,10) }</span>
								</div>
												
								<h2 class="mb-2 text-md"><a href="#">${vo.title}</a></h2>
								<div class="nav-item lead mb-4 font-weight-normal text-black">관리자</div>
								<c:if test="${sLevel==0}">
									<div class="text-right">
										<input type="button" value="수정하기" onclick="location.href='${ctp}/admin/company/noticeEdit?idx=${vo.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}';" class="btn btn-main-2 btn-icon-sm btn-round-full mr-2" >
										<input type="button" value="삭제하기" onclick="deleteCheck()" class="btn btn-main btn-icon-sm btn-round-full" >
									</div>
								</c:if>
								<hr/>
								<p>${fn:replace(vo.content,newLine,'<br/>')}</p>
				
								<div class="mt-5 clearfix">
							    <ul class="float-right list-inline">
						        <li class="list-inline-item"> 공유하기: </li>
						        <li class="list-inline-item"><a href="#" target="_blank"><i class="icofont-facebook" aria-hidden="true"></i></a></li>
						        <li class="list-inline-item"><a href="#" target="_blank"><i class="icofont-twitter" aria-hidden="true"></i></a></li>
						        <li class="list-inline-item"><a href="#" target="_blank"><i class="icofont-linkedin" aria-hidden="true"></i></a></li>
							  	</ul>
							  </div>
							</div>
						</div>
					</div>

					<div class="col-lg-12">
						<hr/>
					</div>
					<div class="col-lg-12 text-center">
						<div class="mt-5">
							<hr/>
							<a href="noticeList?pag=${pageVO.pag}&pageSize=${pageVO.pageSize}&search=${pageVO.search}&searchString=${pageVO.searchString}" class="btn btn-main btn-icon" style="padding: .4rem 1.2rem;">목록으로</a>
						</div>
					</div>
				</div>
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