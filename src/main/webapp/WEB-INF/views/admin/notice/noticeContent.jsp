<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${vo.title}</title>
  <script src="${ctp}/ckeditor/ckeditor.js"></script>
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<link rel="stylesheet" href="${ctp}/css/bootstrap-datepicker.css">
	<script>
		'use strict';
		
		function deleteCheck(){
			let ans = confirm("현재 공지사항을 삭제하시겠습니까?");
			if(!ans) return false;
			location.href="${ctp}/admin/notice/noticeDelete?idx=${vo.idx}";
		}
	</script>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
	<div class="row align-items-center">
		<div class="col-lg-12 col-md-10 mb-5">
			<div class="blog-item-content mt-2">
				<div class="blog-item-meta mb-3">
					<div class="mb-2" style="color:#223a66; font-size:1.2rem;">
							${vo.part=='events' ? '이벤트' : ''}
							${vo.part=='notices' ? '일반공지' : ''}
					</div>
					<span class="text-black text-muted mr-3"><i class="icofont-calendar mr-2"></i> ${vo.date_diff == 0 ? fn:substring(vo.writeDate,11,19) : fn:substring(vo.writeDate,0,10) }</span>
					<c:if test="${!empty vo.endDate}">
						<span class="text-black text-muted mr-3"><i class="fa-solid fa-stopwatch"></i> ${fn:substring(vo.endDate,0,10)}</span>
					</c:if>
				</div>
								
				<h2 class="mb-2 text-md"><a href="#">${vo.title}</a></h2>
				<div class="text-right">
					<input type="button" value="수정하기" onclick="location.href='${ctp}/admin/notice/noticeEdit?idx=${vo.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}';" class="btn btn-main-2 btn-icon-sm btn-round-full mr-2" >
					<input type="button" value="삭제하기" onclick="deleteCheck()" class="btn btn-main btn-icon-sm btn-round-full" >
				</div>
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

		<div class="col-lg-12 text-center">
			<div class="mt-5">
				<hr/>
				<a href="noticeList?pag=${pageVO.pag}&pageSize=${pageVO.pageSize}&search=${pageVO.search}&searchString=${pageVO.searchString}" class="btn btn-main btn-icon" style="padding: .4rem 1.2rem;">목록으로</a>
			</div>
		</div>
	</div>
		
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.js"></script>
<script src="${ctp}/js/bootstrap-datepicker.ko.js"></script>
</body>
</html>