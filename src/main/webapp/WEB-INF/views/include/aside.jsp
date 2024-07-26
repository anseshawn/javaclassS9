<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<style>
	  .accordion {
	  	background-color: #fff;
	    cursor: pointer;
	    /*padding: 18px;*/
	    width: 100%;
	    border: none;
	    outline: none;
	  }
	  
	  .panel {
	    /* padding: 0 18px; */
	    display: none;
	    overflow: hidden;
	  }
	  
	  .panel a {
	    display: block;
	    /* padding: 12px 16px; */
	    text-decoration: none;
	  }
	  
	  .panel a:hover {
	    background-color: #eee;
	  }
	</style>
	<script>
		document.addEventListener("DOMContentLoaded", function() {
		  var acc = document.querySelectorAll(".accordion");
		  
		  acc.forEach(function(el) {
		    el.addEventListener("click", function() {
		      this.classList.toggle("active");
		      var panel = this.nextElementSibling;
		      if (panel.style.display === "block") {
		        panel.style.display = "none";
		      } else {
		        panel.style.display = "block";
		      }
		    });
		  });
		});
	</script>
</head>
<body>
<div class="row">
	<!-- <div class="col-lg-3"> -->
	<div class="col">
		<div class="sidebar-wrap pl-lg-4 mt-5 mt-lg-0">
			<div class="sidebar-widget search mb-3 ">
					<h2 class="text-center">My Page</h2>
					<div class="divider" style="width:100%;"></div>
					<div class="text-right">아이디: ${sMid}</div>
					<br/>
				<div class="row">
					<div class="col">
						<div class="title text-center">내 정보 관리</div>
					</div>
				</div>
				<div class="divider2 mx-auto my-2"></div>
				<div class="row">
					<div class="col"><a href="${ctp}/member/memberUpdate"> 정보 수정</a></div>
				</div>
				<div class="row">
					<div class="col"><a href="${ctp}/member/consultingList">문의내역</a></div>
				</div>
				<div class="row">
					<div class="col"><a href="${ctp}/member/machineLikeList">관심장비 목록</a></div>
				</div>
				<div class="row">
					<div class="col"><a href="${ctp}/member/boardLikeList">관심글</a></div>
				</div>
				<div class="row mt-3">
					<div class="col">
						<div class="title text-center">내 활동내역</div>
					</div>
				</div>
				<div class="divider2 mx-auto my-2"></div>
				<div class="row">
					<div class="col">
						<div class="dropdown">
							<button class="accordion">게시글 확인<i class="fa-solid fa-caret-down ml-2"></i></button>
							<div class="panel">
							 <a href="${ctp}/member/writeBoard" class="dropdown-item">작성게시글</a>
							 <a href="${ctp}/member/writeReply" class="dropdown-item">작성댓글</a>
							 <a href="${ctp}/member/estimateList" class="dropdown-item">견적내역</a>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col"><a href="${ctp}/member/messageList">받은 메세지</a></div>
				</div>
			</div>
			</div>
	</div>

</div>
</body>
</html>