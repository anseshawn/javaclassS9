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
		
		function reportMember(hostIp) {
			let message = "";
			
			Swal.fire({
        html : "<h3>해당 유저를 신고하겠습니까?</h3>",
        confirmButtonText : '확인',
        showCancelButton: true,
        confirmButtonColor : '#003675',
        customClass: {
          popup : 'custom-swal-popup',
          htmlContainer : 'custom-swal-text'
        }
			}).then((result)=>{
				if(result.isConfirmed) {
					$.ajax({
						url: "${ctp}/member/reportMember",
						type: "post",
						data: {
							hostIp : hostIp,
							mid : "${sMid}"
						},
						success: function(res){
							if(res != "0") {
								message = "신고가 완료되었습니다.";
							}
							else {
								message = "이미 신고한 유저입니다.";
							}
							Swal.fire({
								html: message,
								confirmButtonText: '확인',
								customClass: {
				        	confirmButton : 'swal2-confirm‎',
				          popup : 'custom-swal-popup',
				          htmlContainer : 'custom-swal-text'
								}
							});
						},
						error: function(){
							alert("전송오류");
						}
					});
				}
			});
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

					<c:set var="curScrStartNo" value="${pageVO.curScrStartNo}"/>
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
										<div class="menu-container">
											<span class="text-muted text-capitalize mr-3">
												<i class="icofont-user mr-2"></i><span class="writeNickName">${vo.nickName}</span>
											</span>
											<div class="menu hidden">
				                <ul>
													<c:if test="${vo.mid != 'guest'}">
			                    <li><a href="javascript:sendMessage('${vo.mid}')">쪽지 보내기</a></li>
							            </c:if>
			                    <li><a href="javascript:reportMember('${vo.hostIp}')">유저신고</a></li>
				                </ul>
					            </div>
						        </div>
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
		    <div class="row mt-5">
		      <div class="col-lg-9">
		        <nav class="pagination py-2 d-inline-block">
		          <div class="nav-links">
			          <c:if test="${pageVO.pag > 1}"><a class="page-numbers" href="freeBoardList?pag=1&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-left"></i></a></c:if>
			          <c:if test="${pageVO.curBlock > 0}"><a class="page-numbers" href="freeBoardList?pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-left"></i></a></c:if>
								<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
									<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><span aria-current="page" class="page-numbers current">${i}</span></c:if>
									<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><a class="page-numbers" href="freeBoardList?pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></c:if>
								</c:forEach>
								<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><a class="page-numbers" href="freeBoardList?pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-right"></i></a></c:if>
								<c:if test="${pageVO.pag < pageVO.totPage}"><a class="page-numbers" href="freeBoardList?pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-right"></i></a></c:if>
		        	</div>
		      	</nav>
					</div>
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