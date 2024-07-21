<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>내 정보 관리</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <jsp:include page="/WEB-INF/views/include/scripts.jsp" />
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
  	.tab-content {
    	width: 100%;
		}
  </style>
  <script>
  	'use strict';
  	/*
    $(document).ready(function(){
      $(".nav-tabs a").click(function(){
        $(this).tab('show');
      });
      $('.nav-tabs a').on('shown.bs.tab', function(event){
        var x = $(event.target).text();         // active tab
        var y = $(event.relatedTarget).text();  // previous tab
      });
    });
  	*/
  	function boardRemoveLike(board,idx){
  		let message = "";
			let icon = "";
			Swal.fire({
	    html : "<h3>해당 게시글을 관심글 목록에서 삭제하겠습니까?</h3>",
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
						url: "${ctp}/customer/board/removeBoardLike",
						type: "post",
						data: {
	    				board: board,
	    				boardIdx: idx,
	    				memberMid: '${sMid}'
						},
						success: function(res){
							if(res != "0") {
								message = "관심글에서 해당 게시글을 삭제 했습니다.";
								icon = "success";
							}
							else {
								message = "관심글 삭제에 실패했습니다.";
								icon = "warning";
							}
							Swal.fire({
								html: message,
								icon: icon,
								confirmButtonText: '확인',
								customClass: {
				        	confirmButton : 'swal2-confirm‎',
				          popup : 'custom-swal-popup',
				          htmlContainer : 'custom-swal-text'
								}
							}).then(function(){
								location.reload();
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
		<div class="col-lg-9 container-fluid">
		<p><br/></p>
			<div class="bodyRight">
		    <ul class="nav nav-tabs" role="tablist">
		      <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#freeBoard">자유게시판</a></li>
		      <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#questionBoard">Q&A게시판</a></li>
		      <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#recruitBoard">채용공고</a></li>
		    </ul>
				<div class="row">
					<div class="tab-content">
					<!-- 자유게시판 관심글 목록 -->
						<p><br/></p>
      			<div id="freeBoard" class="container tab-pane active">
							<table class="table table-hover text-center">
								<tr style="background:#003675; color:#fff;">
									<th>번호</th>
									<th>제목</th>
									<th>작성자</th>
									<th>작성일</th>
									<th>추천</th>
									<th></th>
								</tr>
								<c:forEach var="freeVO" items="${freeBoardVOS}">
									<tr>
										<td>${freeVO.idx}</td>
										<td>
											<a href="${ctp}/customer/board/freeBoardContent?idx=${freeVO.idx}">${freeVO.title}</a>
										</td>
										<td>${freeVO.nickName}</td>
										<td>
											${freeVO.date_diff == 0 ? fn:substring(freeVO.writeDate,11,19) : fn:substring(freeVO.writeDate,0,10) }
										</td>
										<td>${freeVO.good}</td>
										<td><input type="button" value="삭제" onclick="boardRemoveLike('freeBoard','${freeVO.idx}')" class="btn btn-main-3 btn-icon-sm btn-round-full"/></td>
									</tr>
								</c:forEach>
							</table>
						</div>
						<!-- 자유게시판 관심목록 끝 -->
						<!-- Q&A게시판 관심글 목록 -->
      			<div id="questionBoard" class="container tab-pane">
							<table class="table table-hover text-center">
								<tr style="background:#003675; color:#fff;">
									<th>번호</th>
									<th>제목</th>
									<th>작성자</th>
									<th>작성일</th>
									<th>추천</th>
									<th></th>
								</tr>
								<c:forEach var="questionVO" items="${questionBoardVOS}">
									<tr>
										<td>${questionVO.idx}</td>
										<td>
											<a href="${ctp}/customer/board/questionBoardContent?idx=${questionVO.idx}">${questionVO.title}</a>
										</td>
										<td>${questionVO.nickName}</td>
										<td>
											${questionVO.date_diff == 0 ? fn:substring(questionVO.writeDate,11,19) : fn:substring(questionVO.writeDate,0,10) }
										</td>
										<td>${questionVO.good}</td>
										<td><input type="button" value="삭제" onclick="boardRemoveLike('questionBoard','${questionVO.idx}')" class="btn btn-main-3 btn-icon-sm btn-round-full"/></td>
									</tr>
								</c:forEach>
							</table>
						</div>
						<!-- 자유게시판 관심목록 끝 -->
						
					</div>
			  </div>
			  
			</div>
		</div>
	</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>