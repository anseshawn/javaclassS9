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
  <title>자유게시판 - ${vo.title}</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<style>
		.likeBtn, .reportBtn {
      border-color: #C7C3BB;
      color: #C7C3BB;
      background-color: #fff;
      cursor: pointer;
    }
    .likeBtn.act {
      border-color: #EC4651;
      color: #EC4651;
      background-color: #fff;
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
	    z-index: 1000;
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
		
		let likeBtnP = null;
		$(function(){
			if('${likeSw}'=='act'){
				$(".likeBtn").addClass("act");
				likeBtnP = "good";
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
		
		// 관심글 등록 버튼
		function addBoardLike() {
    	if(likeBtnP) {
    		let ans = confirm("이미 추천 된 게시글입니다.\n해당 게시글을 관심글 목록에서 삭제하겠습니까?");
    		if(!ans) return false;
    		$.ajax({
    			url: "${ctp}/customer/board/removeBoardLike",
    			type: "post",
    			data: {
    				board:"freeBoard",
    				boardIdx: ${vo.idx},
    				memberMid: '${sMid}'
    			},
    			success: function(res){
    				if(res != "0") {
    					alert("관심글 목록에서 삭제 되었습니다.");
    					$(".likeBtn").removeClass("act");
	    				likeBtnP = null;
	    				location.reload();
    				}
    				else alert("삭제 실패. 다시 시도하세요.");
    			},
    			error: function(){
    				alert("전송 오류");
    			}
    		});
    	}
    	else {
				$.ajax({
					url: "${ctp}/customer/board/addBoardLike",
					type: "post",
					data: {
						board:"freeBoard",
						boardIdx: ${vo.idx},
						memberMid: '${sMid}'
					},
					success: function(res) {
						if(res != "0"){
							alert("추천을 눌렀습니다.\n마이페이지 관심글 목록에서 게시글을 확인할 수 있습니다.");
							$(".likeBtn").addClass("act");
							likeBtnP = "good";
							location.reload();
						}
						else alert("추천 실패. 다시 시도하세요.");
					},
					error: function() {
						alert("전송오류");
					}
				});
    	}
		}
		
		function deleteCheck(){
			let ans = confirm("현재 게시글을 삭제하시겠습니까?");
			if(!ans) return false;
			else if(${vo.replyCnt} != 0) {
				ans = confirm("현재 게시글을 삭제하면 다른 회원의 댓글까지 모두 삭제됩니다.\n정말 삭제하시겠습니까?");
				if(!ans) return false;
			}
			location.href="${ctp}/customer/board/freeBoardDelete?idx=${vo.idx}";
		}
		
		// 신고 (중복 불허)
		function etcShow(){
			$("#reportTxt").show();
		}
		// 신고사항 전송하기
		function reportCheck(){
			if(!$("input[type=radio][name=report]:checked").is(':checked')) {
				alert("신고 사유를 선택하세요.");
				return false;
			}
			if($("input[type=radio]:checked").val()=='기타' && $("#reportTxt").val().trim()==""){
				alert("기타 사유를 입력하세요.");
				return false;
			}
			let rpContent = modalForm.report.value;
			if(rpContent=='기타') rpContent += "/"+$("#reportTxt").val();
			
			let query = {
					board: 'freeBoard',
					boardIdx: ${vo.idx},
					rpMid: '${sMid}',
					rpContent: rpContent 
			}
			
			$.ajax({
				url: "${ctp}/customer/board/boardReport",
				type: "post",
				data: query,
				success: function(res){
					if(res!="0") {
						alert("신고가 완료되었습니다.");
						location.reload();
					}
					else alert("이미 게시글에 대한 신고를 완료했습니다.");
				},
				error: function(){
					alert("전송오류");
				}
			});
		}
		
		// 댓글 달기
		function replyCheck(){
			let mid = "";
			let nickName = "";
			let content = replyForm.content.value;
			if('${sLevel}'=='') {
				mid = "guest";
				nickName = replyForm.nickName.value;
				if(nickName.trim()=="") {
					alert("댓글 작성자를 입력해주세요.");
					return false;
				}
			}
			else {
				mid = "${sMid}";
				nickName = "${sNickName}";
			}
			if(content.trim()=="") {
				alert("내용을 입력해주세요.");
				return false;
			}
			let query = {
					board: "freeBoard",
					boardIdx: ${vo.idx},
					mid: mid,
					nickName: nickName,
					hostIp: "${pageContext.request.remoteAddr}",
					content: content
			}
			$.ajax({
				url: "${ctp}/customer/board/replyInput",
				type: "post",
				data: query,
				success: function(res){
					if(res != 0) {
						alert("댓글이 등록되었습니다.");
						location.reload();
					}
					else {
						alert("댓글 등록 실패");
					}
				},
				error: function(){
					alert("댓글 전송 오류");
				}
			});
		}
		// 댓글&답글 삭제
		function replyDelete(idx) {
			let ans = confirm("현재 댓글을 삭제하시겠습니까?");
			if(!ans) return false;
			$.ajax({
				url: "${ctp}/customer/board/replyDelete",
				type: "post",
				data: {
					board : "freeBoard",
					boardIdx : ${vo.idx},
					idx : idx
				},
				success: function(res){
					if(res != 0){
						alert("댓글을 삭제했습니다.");
						location.reload();
					}
					else alert("댓글 삭제 실패");
				},
				error: function(){
					alert("전송오류");
				}
			});
		}
		// 댓글 수정창 토글
		function replyEdit(idx){
			let replyDisplay = window.getComputedStyle(document.getElementById("reEditDemo"+idx)).display;
			if(replyDisplay=='none') {
				$(".reEditDemo").hide();
				$("#reEditDemo"+idx).show();
			}
			else {
				$("#reEditDemo"+idx).toggle();				
			}
		}
		function editFormClose(idx){
			$("#reEditDemo"+idx).hide();
		}
		
		// 댓글&답글 수정
		function replyEditCheck(idx) {
			let content = $("#content"+idx).val();
			
			$.ajax({
				url: "${ctp}/customer/board/replyUpdate",
				type: "post",
				data: {
					mid: "${sMid}",
					nickName: "${sNickName}",
					idx:idx,
					content:content,
					hostIp: "${pageContext.request.remoteAddr}"
				},
				success:function(res) {
					if(res != 0) {
						location.reload();
					}
				},
				error: function(){
					alert("전송 오류");
				}
			});
		}
		
		// 대댓글 영역
		// 대댓글 입력창 토글
		function replyFormRe(idx){
			$(".reEditDemo").hide();
			let reReplyDisplay = window.getComputedStyle(document.getElementById("reReplyDemo"+idx)).display;
			if(reReplyDisplay=='none') {
				$(".reReplyDemo").hide();
				$("#reReplyDemo"+idx).show();
			}
			else {
				$("#reReplyDemo"+idx).toggle();				
			}
		}
		function replyFormCloseRe(idx){
			$("#reReplyDemo"+idx).hide();
		}
		
		// 대댓글 입력
		function replyInputRe(idx,re_step,re_order){
			let reMid = "";
			let reNickName = "";
			let reContent = $("#reContent"+idx).val();
			if(${empty sLevel}) {
				reMid = "guest";
				reNickName = $("#guestNickName").val();
				if(reNickName.trim()=="") {
					alert("작성자를 입력해주세요.");
					return false;
				}
			}
			else {
				reMid = "${sMid}"
				reNickName = "${sNickName}";
			}
			if(reContent.trim()=="") {
				alert("내용을 입력해주세요.");
				return false;
			}
			
			let query = {
					board: "freeBoard",
					boardIdx: ${vo.idx},
					re_step: re_step,
					re_order: re_order,
					parentId: idx,
					mid: reMid,
					nickName: reNickName,
					hostIp: "${pageContext.request.remoteAddr}",
					content: reContent
			}
			$.ajax({
				url: "${ctp}/customer/board/replyInputRe",
				type: "post",
				data: query,
				success: function(res){
					if(res != 0) {
						alert("답글이 등록되었습니다."); 
						location.reload();
					}
					else {
						alert("답글 등록 실패");
					}
				},
				error: function(){
					alert("전송오류");
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
	      	<h1 class="text-capitalize mb-5 text-lg"><a href="freeBoardList" style="color: #fff;">자유게시판</a></h1>
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
									<span class="text-muted text-capitalize mr-3"><i class="fa-solid fa-eye mr-2"></i>${vo.readNum}</span>
									<span class="text-muted text-capitalize mr-3"><i class="icofont-comment mr-2"></i>${vo.replyCnt} Comments</span>
									<span class="text-black text-capitalize mr-3"><i class="icofont-calendar mr-2"></i> ${vo.date_diff == 0 ? fn:substring(vo.writeDate,11,19) : fn:substring(vo.writeDate,0,10) }</span>
								</div>
												
								<h2 class="mb-2 text-md"><a href="#">${vo.title}</a></h2>
								<div class="nav-item lead mb-4 font-weight-normal text-black">${vo.nickName}(${vo.mid})</div>
								<c:if test="${sLevel==0 || sMid==vo.mid}">
									<div class="text-right">
										<input type="button" value="수정하기" onclick="location.href='${ctp}/customer/board/freeBoardEdit?idx=${vo.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}';" class="btn btn-main-2 btn-icon-sm btn-round-full mr-2" >
										<input type="button" value="삭제하기" onclick="deleteCheck()" class="btn btn-main btn-icon-sm btn-round-full" >
									</div>
								</c:if>
								<hr/>
								<p>${fn:replace(vo.content,newLine,'<br/>')}</p>
				
								<div class="mt-5 clearfix">
							    <ul class="float-left list-inline tag-option">
							    	<c:if test="${vo.mid != sMid && sLevel > 1}">
								    	<li class="list-inline-item">
								    		<button class="btn likeBtn btn-icon-md" onclick="addBoardLike()" id="likeBtn">
								    			<i class="icofont-thumbs-up mr-1"></i>추천<span class="ml-1">${vo.good}</span>
								    		</button>
								    	</li>
								    	<li class="list-inline-item">
									    	<button type="button" data-toggle="modal" data-target="#myModal" class="btn reportBtn btn-icon-md">
									    		<i class="fa-solid fa-triangle-exclamation mr-2"></i>신고
									    	</button>
								    	</li>
							    	</c:if>
							   	</ul>
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
						<div class="comment-area mt-4 mb-5">
							<h4 class="mb-5">${vo.replyCnt} 개의 댓글</h4>
							<ul class="comment-tree list-unstyled">
							
								<c:forEach var="rVo" items="${replyVos}" varStatus="st">
									<li class="mb-5">
										<div class="comment-area-box">
										<c:if test="${rVo.re_step < 1}">
											<div class="comment-info">
												<c:if test="${rVo.nickName!='' || rVo.mid!=''}">
													<div class="menu-container">
													 <h5 class="mb-1 writeNickName">${rVo.nickName}(${rVo.mid})</h5>
								            <div class="menu hidden">
							                <ul>
						                    <li><a href="javascript:sendMessage('${rVo.mid}')">쪽지 보내기</a></li>
							                </ul>
								            </div>
						        			</div>
													<span>${rVo.hostIp}</span>
													<span class="date-comm mr-2">| ${rVo.date_diff == 0 ? fn:substring(rVo.replyDate,11,19) : fn:substring(rVo.replyDate,0,10) }</span>
													<span class="comment-meta mr-2"><a href="javascript:replyFormRe(${rVo.idx})" ><i class="icofont-reply mr-2 text-muted"></i>답글</a></span>
													<c:if test="${sLevel==0 || sMid == rVo.mid}">
													 <span class="comment-meta mr-2"><a href="javascript:replyEdit(${rVo.idx})"><i class="icofont-edit mr-2 text-muted"></i>수정</a></span>
													 <span class="comment-meta"><a href="javascript:replyDelete(${rVo.idx})"><i class="icofont-ui-delete mr-2 text-muted"></i>삭제</a></span>
													</c:if>
												</c:if>
											</div>
											<div class="comment-content mt-3">
												${fn:replace(rVo.content,newLine,'<br/>')}
											</div>
										</c:if>

											
										<!-- 대댓글 창 -->
										<c:if test="${rVo.re_step >= 1}">
										<hr/>
											<div class="col-lg-8">
											<div class="comment-info">
												<div class="menu-container">
													<h5 class="mb-1 writeNickName">${rVo.nickName}(${rVo.mid})</h5>
													<div class="menu hidden">
						                <ul>
					                    <li><a href="javascript:sendMessage('${rVo.mid}')">쪽지 보내기</a></li>
						                </ul>
							            </div>
						            </div>
												<span>${rVo.hostIp}</span>
												<span class="date-comm mr-2">| ${rVo.date_diff == 0 ? fn:substring(rVo.replyDate,11,19) : fn:substring(rVo.replyDate,0,10) }</span>
												<c:if test="${sLevel==0 || sMid == rVo.mid}">
												 <span class="comment-meta mr-2"><a href="javascript:replyEdit(${rVo.idx})"><i class="icofont-edit mr-2 text-muted"></i>수정</a></span>
												 <span class="comment-meta"><a href="javascript:replyDelete(${rVo.idx})"><i class="icofont-ui-delete mr-2 text-muted"></i>삭제</a></span>
												</c:if>
											</div>
											<div class="comment-content mt-3">
												${fn:replace(rVo.content,newLine,'<br/>')}
											</div>
											</div>
										</c:if>
										<!-- 대댓글 창 끝 -->
											
										<!-- 댓글 수정창 -->
										<div class="reEditDemo" id="reEditDemo${rVo.idx}" style="display:none;">
											<div class="col-lg-10">
											<hr/>
											<form class="comment-form" name="replyEditForm" >
												<div class="row">
													<div class="col-md-4">
														<div class="form-group">
															<c:if test="${!empty sLevel}">
																<input class="form-control" type="text" name="nickName" value="${rVo.nickName}(${rVo.mid})" readonly>
															</c:if>
														</div>
													</div>
												</div>
												<textarea class="form-control mb-4" name="content" id="content${rVo.idx}" cols="30" rows="5">${rVo.content}</textarea>
												<div class="text-right">
													<input class="btn btn-main-2 btn-icon-sm btn-round-full mr-2" type="button" onclick="replyEditCheck(${rVo.idx})" value="수정하기"/>
													<input class="btn btn-main btn-icon-sm btn-round-full" type="button" onclick="editFormClose(${rVo.idx})" value="닫기"/>
												</div>
											</form>
											</div>
										</div>
										<!-- 댓글 수정창 끝 -->
											
										<!-- 대댓글 입력창 -->
										<div class="reReplyDemo" id="reReplyDemo${rVo.idx}" style="display:none;">
											<div class="col-lg-10">
											<hr/>
											<form class="comment-form" name="replyForm2" >
												<div class="row">
													<div class="col-md-4">
														<div class="form-group">
															<c:if test="${!empty sLevel}">
																<input class="form-control" type="text" name="reNickName" value="${sNickName}(${sMid})" readonly>
															</c:if>
															<c:if test="${empty sLevel}">
																<input class="form-control" type="text" name="reNickName" id="guestNickName" placeholder="Name:">
															</c:if>
														</div>
													</div>
												</div>
												<textarea class="form-control mb-4" name="content" id="reContent${rVo.idx}" cols="30" rows="5"></textarea>
												<div class="text-right">
													<input class="btn btn-main-2 btn-icon-sm btn-round-full mr-2" type="button" onclick="replyInputRe(${rVo.idx},${rVo.re_step},${rVo.re_order})" value="등록하기"/>
													<input class="btn btn-main btn-icon-sm btn-round-full" type="button" onclick="replyFormCloseRe(${rVo.idx})" value="닫기"/>
												</div>
											</form>
											</div>
										</div>
										<!-- 대댓글 입력창 끝 -->
										</div>
									</li>
								</c:forEach>
							</ul>
						</div>
					</div>
					<div class="col-lg-12">
						<hr/>
						<!-- 댓글 입력 창 -->
						<form class="comment-form my-5" name="replyForm">
							<h4 class="mb-4">댓글 쓰기</h4>
							<div class="row">
								<div class="col-md-4">
									<div class="form-group">
										<c:if test="${!empty sLevel}">
											<input class="form-control" type="text" name="nickName" value="${sNickName}(${sMid})" readonly>
										</c:if>
										<c:if test="${empty sLevel}">
											<input class="form-control" type="text" name="nickName" placeholder="Name:">
										</c:if>
									</div>
								</div>
							</div>
							<textarea class="form-control mb-4" name="content" id="content" cols="30" rows="5" placeholder="Comment"></textarea>
							<div class="text-right">
								<input class="btn btn-main-2 btn-round-full" type="button" onclick="replyCheck()" value="댓글 작성"/>
							</div>
						</form>
						<!-- 댓글 입력창 끝 -->
					</div>
					<div class="col-lg-12 text-center">
						<div class="mt-5">
							<hr/>
							<c:if test="${empty flag}"><a href="${ctp}/customer/board/freeBoardList?pag=${pageVO.pag}&pageSize=${pageVO.pageSize}" class="btn btn-main btn-icon" style="padding: .4rem 1.2rem;">목록으로</a></c:if>
							<c:if test="${!empty flag}"><a href="FreeBoardSearch.do?pag=${pageVO.pag}&pageSize=${pageVO.pageSize}&search=${pageVO.search}&searchString=${pageVO.searchString}" class="btn btn-main btn-icon" style="padding: .4rem 1.2rem;">목록으로</a></c:if>
						</div>
					</div>
				</div>
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

<!-- 신고하기 폼 modal -->
<div class="modal fade" id="myModal">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
    
      <!-- Modal Header -->
      <div class="modal-header">
        <div class="modal-title">현재 게시글 신고하기</div>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      <!-- Modal body -->
      <div class="modal-body">
      	<h3 class="mt-2">신고사유</h3>
      	<div class="divider2 mt-4 mb-4" style="width:100%"></div>
      	<form name="modalForm">
      		<div class="mb-2"><input type="radio" name="report" id="report1" value="광고,홍보,영리목적" /> 광고,홍보,영리목적</div>
      		<div class="mb-2"><input type="radio" name="report" id="report2" value="욕설,비방,차별,혐오" /> 욕설,비방,차별,혐오</div>
      		<div class="mb-2"><input type="radio" name="report" id="report3" value="불법정보" /> 불법정보</div>
      		<div class="mb-2"><input type="radio" name="report" id="report4" value="음란,청소년유해" /> 음란,청소년유해</div>
      		<div class="mb-2"><input type="radio" name="report" id="report5" value="개인정보노출,유포,거래" /> 개인정보노출,유포,거래</div>
      		<div class="mb-2"><input type="radio" name="report" id="report6" value="도배,스팸" /> 도배,스팸</div>
      		<div class="mb-2"><input type="radio" name="report" id="report7" value="기타" onclick="etcShow()" /> 기타</div>
      		<div id="etc"><textarea rows="2" id="reportTxt" class="form-control" style="display:none"></textarea> </div>
      		<div class="divider2 mt-4 mb-4" style="width:100%"></div>
      		<input type="button" value="확인" onclick="reportCheck()" class="btn btn-main btn-icon-md form-control" />
      	</form>
      </div>
      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-main-2 btn-icon-sm" data-dismiss="modal">Close</button>
      </div>
      
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>