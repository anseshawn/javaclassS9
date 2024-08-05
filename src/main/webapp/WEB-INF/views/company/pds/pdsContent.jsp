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
  <title>자료실 - ${vo.title}</title>
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
	    z-index: 1000;
		}
		
		.menu ul {
	    list-style-type: none;
	    margin: 0;
	    padding: 0;
	  	white-space: nowrap;
		}
		
		.menu li {
			display: block;
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
		
		ul {
		  display: block;
		  list-style-type: decimal;
		  margin-block-start: 1em;
		  margin-block-end: 1em;
		  margin-inline-start: 20px;
		  margin-inline-end: 20px;
		  padding-inline-start: 40px;
		  padding-inline-end: 20px;
		}
	</style>
	<script>
		'use strict';
		
		$(function(){
			//const rect = document.querySelector("#fileLocation").getBoundingClientRect();
			//console.log(rect);
			if("${fileLocation}") {
				let topLocation = document.querySelector("#fileLocation").offsetTop;
				window.scrollTo({top:topLocation, left:0, behavior:'smooth'});
			}
			
	    var menus = document.querySelectorAll('.menu-container');

	    menus.forEach(function(menuContainer) {
        var writeNickName = menuContainer.querySelector('.writeNickName');
        var menu = menuContainer.querySelector('.menu');
        writeNickName.addEventListener('click', function() {
            menu.classList.toggle('hidden');
        });
        document.addEventListener('click', function(event) {
          if (!menuContainer.contains(event.target)) {
              menu.classList.add('hidden');
          }
        });
	  	});
		});
		
		function deleteCheck(){
			let ans = confirm("현재 게시글을 삭제하시겠습니까?");
			if(!ans) return false;
			$.ajax({
				url: "${ctp}/company/pds/pdsDelete",
				type: "post",
				data: {
					idx : ${vo.idx},
					fileSName : "${vo.fileSName}"
				},
				success: function(res) {
					if(res != 0) {
						alert("게시글이 삭제되었습니다.");
						location.href="${ctp}/company/pds/pdsList?pag=${pageVO.pag}&pageSize=${pageVO.pageSize}";
					}
					else alert("게시글 삭제 실패");
				},
				error: function(){
					alert("전송 오류");
				}
			});
		}
		
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
			location.href="${ctp}/customer/board/pdsList?pag=${pageVo.pag}&pageSize=${pageVo.pageSize}&part="+part+"&searchString="+searchString;
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
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<p><br/></p>
<div class="container">
<section class="page-title bg-2">
  <div class="overlay"></div>
  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <div class="block text-center">
          <span class="text-white">자료실</span>
          <h1 class="text-capitalize mb-5 text-lg"><a href="${ctp}/company/pds/pdsList" style="color: #fff;">PDS</a></h1>
        </div>
      </div>
    </div>
  </div>
</section>
<c:set var="fileNames" value="${fn:split(vo.fileName,'/')}"/>
<c:set var="fileSNames" value="${fn:split(vo.fileSName,'/')}"/>
<section class="section blog-wrap">
	<div class="container">
		<div class="row">
			<div class="col-lg-8">
				<div class="row">
					<div class="col-lg-12 mb-5">
						<div class="single-blog-item">
							<div class="blog-item-content mt-2">
								<div class="blog-item-meta mb-3">
									<span class="text-muted text-capitalize mr-3"><i class="fa-solid fa-eye mr-2"></i>${vo.readNum}</span>
									<span class="text-muted text-capitalize mr-3"><i class="icofont-calendar mr-2"></i> ${vo.date_diff == 0 ? fn:substring(vo.writeDate,11,19) : fn:substring(vo.writeDate,0,10) }</span>
								</div>
												
								<h2 class="mb-2 text-md"><a href="#">${vo.title}</a></h2>
								<div class="menu-container">
									<div class="nav-item lead mb-4 font-weight-normal text-black"><span class="writeNickName">${vo.mid}</span></div>
										<div class="menu hidden">
			                <ul>
		                    <li><a href="javascript:sendMessage('${vo.mid}')">쪽지 보내기</a></li>
			                </ul>
				            </div>								
				        </div>
								<c:if test="${sLevel==0 || sMid==vo.mid}">
									<div class="text-right">
										<input type="button" value="수정하기" onclick="location.href='${ctp}/company/pds/pdsEdit?idx=${vo.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}';" class="btn btn-main-2 btn-icon-sm btn-round-full mr-1" >
										<input type="button" value="삭제하기" onclick="deleteCheck()" class="btn btn-main btn-icon-sm btn-round-full" >
									</div>
								</c:if>
								<hr/>
								<div class="text-center mt-3 mb=3">
									<c:forEach var="fileSName" items="${fileSNames}" varStatus="st">
										<c:set var="len" value="${fn:length(fileSName)}"/>
										<c:set var="ext" value="${fn:substring(fileSName,len-3,len)}"/>
										<c:set var="extLower" value="${fn:toLowerCase(ext)}"/>
										<c:if test="${extLower == 'jpg' || extLower == 'gif' || extLower == 'png'}">
											<img src="${ctp}/data/pds/${fileSName}" width="85%"/>
										</c:if>
										<br/><br/>
									</c:forEach>
								</div>
								
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
							<div class="mt-5 clearfix" style="border:1px solid #eee; color:black;">
								<ul style="list-style-type: none;">
									<li id="fileLocation">첨부파일 목록</li>								
								</ul>
								<ul class="files">
									<c:forEach var="fileName" items="${fileNames}" varStatus="st">
										<li>
											<a href="${ctp}/data/pds/${fileSNames[st.index]}" download="${fileName}"> ${fileName} </a>
										</li> 
									</c:forEach>
								</ul>
								<ul style="list-style-type: none;"><li>(<fmt:formatNumber value="${vo.fileSize / 1024}" pattern="#,##0" />KB)</li></ul>
							</div>
						</div>
					</div>

					<div class="col-lg-12 text-center">
						<div class="mt-5">
							<hr/>
							<a href="pdsList?pag=${pageVO.pag}&pageSize=${pageVO.pageSize}&search=${pageVO.search}&searchString=${pageVO.searchString}" class="btn btn-main btn-icon" style="padding: .4rem 1.2rem;">목록으로</a>
						</div>
					</div>
				</div>
			</div>
			
			<div class="col-lg-4">
				<div class="sidebar-wrap pl-lg-4 mt-5 mt-lg-0">
				<c:if test="${!empty sLevel && sLevel == 0}">
					<div class="sidebar-widget write text-center mb-5 ">
						<a href="${ctp}/company/pds/pdsInput" class="btn btn-main btn-icon btn-round" style="width:80%;">글쓰기</a>
					</div>
				</c:if>	
					<!-- 검색창 -->
					<div class="sidebar-widget search mb-3 ">
						<h5>검색</h5>
						<select name="search" id="search" class="form-control">
							<option value="title">제목</option>
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