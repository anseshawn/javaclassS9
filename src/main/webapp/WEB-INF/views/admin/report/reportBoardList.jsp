<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 신고 게시글 리스트</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
	<style>
		#spinner {
		  position: absolute;
		  left: 50%;
		  top: 50%;
		  z-index: 1;
		}
	</style>
	<script>
		'use strict';
		let message = "";
		let icon = "";
		
		function allSelect(){
  		if(document.getElementById("allSelect").checked){
	  		for(let i=0; i<${vos.size()}; i++) {
	  			document.getElementsByName("selectReport")[i].checked = true;
	  		}  			
  		}
  		else {
	  		for(let i=0; i<${vos.size()}; i++) {
	  			document.getElementsByName("selectReport")[i].checked = false;
	  		}  
  		}
		}
		
		function modalView(mid) {
			let str = "<table class='table text-center'>";
			$.ajax({
				url: "${ctp}/admin/member/memberList/"+mid,
				type: "post",
				data: {mid:mid},
				success: function(mVo) {
					let birthday = mVo.birthday.substring(0,10);
					let lastDate = mVo.lastDate.substring(0,10);
					str += "<tr><th>이름</th><td>"+mVo.name+"</td><th>고유번호</th><td>"+mVo.idx+"</td></tr>";
					str += "<tr><th>최종접속일</th><td>"+lastDate+"</td><th>등급</th><td>"+mVo.level+"</td></tr>";
					str += "<tr><th>아이디</th><td><span id='selectMid'>"+mVo.mid+"</span></td><th>닉네임</th><td>"+mVo.nickName+"</td></tr>";
					str += "<tr>";
					str += "<th>이메일</th><td>"+mVo.email+"</td><th>뉴스레터<br/>구독여부</th><td>"+mVo.emailNews;
					if(mVo.emailNews=='OK') {
						str += "<br/><a href='${ctp}/admin/emailInput/"+mVo.mid+"' class='btn btn-main btn-icon-sm btn-round-full'>메일전송</a>";
					}
					str += "</td></tr>";
					str += "<tr><th>연락처</th><td>"+mVo.tel+"</td><th>생일</th><td>"+birthday+"</td></tr>";
					str += "<tr><th>재직자 여부</th><td colspan='3'>"+mVo.m_group+"</td></tr>"
					if(mVo.m_group=='재직자') {
						str += "<tr><th>회사명</th><td>"+mVo.co_name+"</td><th>분류</th><td>"+mVo.co_category+"</td></tr>";
						str += "<tr><th>소재지</th><td colspan='3'>"+mVo.co_address+"</td></tr>";
						str += "<tr><th>회사 연락처</th><td colspan='3'>"+mVo.co_tel+"</td></tr>";
					}
					str += "<tr><th>가입목적</th><td colspan='3'>"+mVo.purpose+"</td></tr>";
					str += "</table>";
					$("#content").html(str);
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
		
		
		// 회원 탈퇴 & 삭제
		function memberDelete(mid) {
			if(mid==='modal') mid = document.getElementById("selectMid").innerText;
			Swal.fire({
        html : "<h3>선택한 회원을 탈퇴 처리하시겠습니까?</h3>",
        confirmButtonText : '삭제',
        showCancelButton: true,
      	confirmButtonColor : '#003675',
        customClass: {
          popup : 'custom-swal-popup',
          htmlContainer : 'custom-swal-text'
        }
			}).then((result)=>{
				if(result.isConfirmed) {
					$.ajax({
						url: "${ctp}/admin/member/memberDeleteAll",
						type: "post",
						data: {mid:mid},
						success: function(res){
							if(res != "0") {
								message = "회원 정보를 영구 삭제했습니다.";
								icon = "success";
							}
							else {
								message = "삭제에 실패했습니다.";
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
		
		// 게시판 분류별 보기
		function selectBoardShow() {
			let part = $("#part").val();
			location.href="${ctp}/admin/report/reportBoardList?pag=${pageVO.pag}&pageSize=${pageVO.pageSize}&part="+part;
		}
		
		// 게시글 한번에 지우기
		function deleteBoard() {
			let idx = "";
			for(let i=0; i<document.getElementsByName("selectReport").length; i++) {
				if(document.getElementsByName("selectReport")[i].checked) {
					idx += document.getElementsByName("selectReport")[i].value+",";
				}
			}
			Swal.fire({
        html : "<h3>선택한 게시글을 삭제 처리하시겠습니까?</h3>",
        confirmButtonText : '삭제',
        showCancelButton: true,
      	confirmButtonColor : '#003675',
        customClass: {
          popup : 'custom-swal-popup',
          htmlContainer : 'custom-swal-text'
        }
			}).then((result)=>{
				if(result.isConfirmed) {
					$.ajax({
						url: "${ctp}/admin/report/reportBoardDeleteAll",
						type: "post",
						data: {idx : idx},
						success: function(res){
							if(res != "0") {
								message = "신고된 게시글을 영구 삭제했습니다.";
								icon = "success";
								location.reload();
							}
							else {
								message = "삭제에 실패했습니다.";
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
<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="spinner-border text-muted" id="spinner" style="display:none;"></div>
<div class="container">
	<div class="row">
		<div class="col-lg-12 text-center"><h2>신고 게시글 목록(총 ${fn:length(vos)} 건)</h2></div>
	</div>
	<div class="row">
		<div class="col-lg-12"><div class="divider2 mx-auto my-4 text-center" style="width:50%;"></div></div>
	</div>
	<div class="row">
		<div class="col-md-3">
			<input type="button" onclick="location.href='${ctp}/admin/report/reportBoardList';" value="전체보기" class="btn btn-main-2 btn-icon-md btn-round-full" style="padding:0.3rem 0.5rem;"/>
			<input type="button" onclick="deleteBoard()" value="게시글삭제" class="btn btn-main btn-icon-md btn-round-full" style="padding:0.3rem 0.5rem;"/>
		</div>
		<div class="col-md-3 offset-md-6 text-right">
			<form name="searchSelect">
				<select name="part" id="part" class="custom-select" onchange="selectBoardShow()">
					<option>게시판별 보기</option>
					<option value="">전체</option>
					<option value="freeBoard" ${pageVO.part=='freeBoard' ? 'selected' : ''}>자유게시판</option>
					<option value="questionBoard" ${pageVO.part=='questionBoard' ? 'selected' : ''}>Q&A게시판</option>
					<option value="recruitBoard" ${pageVO.part=='recruitBoard' ? 'selected' : ''}>채용공고 게시판</option>
				</select>
			</form>
		</div>
	</div>
	<hr/>
	<div class="row">
		<table class="table table-hover text-center">
			<tr style="background:#003675; color:#fff;">
				<th><input type="checkbox" name="allSelect" id="allSelect" onclick="allSelect()" class="custom-conrol-input"/></th>
				<th>번호</th>
				<th>게시판</th>
				<th>신고자</th>
				<th>신고사유</th>
				<th>신고날짜</th>
				<th>제목</th>
				<th>작성자</th>
			</tr>
			<c:set var="curScrStartNo" value="${pageVO.curScrStartNo}"/>
			<c:forEach var="vo" items="${vos}" varStatus="st">
				<tr>
					<td>
						<form name="selectForm">
							<input type="checkbox" name="selectReport" id="selectReport${st}" value="${vo.idx}/${vo.board}" />
						</form>
					</td>
					<td>${curScrStartNo}</td>
					<td>
						<c:if test="${vo.board=='freeBoard'}">자유게시판</c:if>
						<c:if test="${vo.board=='questionBoard'}">Q&A게시판</c:if>
						<c:if test="${vo.board=='recruitBoard'}">채용공고 게시판</c:if>
					</td>
					<td>
						<a href="#" onclick="modalView('${vo.rpMid}')" data-toggle="modal" data-target="#memberInfoModal">${vo.rpMid}</a>
					</td>
					<td>${vo.rpContent}</td>
					<td>${fn:substring(vo.rpDate,0,10)}</td>
					<td>
						<c:if test="${vo.board=='freeBoard'}">
							<a href="${ctp}/customer/board/freeBoardContent?idx=${vo.fbIdx}">${vo.fbTitle}</a>
						</c:if>
						<c:if test="${vo.board=='questionBoard'}">
							<a href="${ctp}/customer/board/questionBoardContent?idx=${vo.qtIdx}">${vo.qtTitle}</a>
						</c:if>
						<c:if test="${vo.board=='recruitBoard'}">
							<a href="${ctp}/customer/board/recruitBoardContent?idx=${vo.rcIdx}">${vo.rcTitle}</a>
						</c:if>
					</td>
					<td>
						<c:if test="${vo.board=='freeBoard'}"><a href="#" onclick="modalView('${vo.fbMid}')" data-toggle="modal" data-target="#memberInfoModal">${vo.fbMid}</a></c:if>
						<c:if test="${vo.board=='questionBoard'}"><a href="#" onclick="modalView('${vo.qtMid}')" data-toggle="modal" data-target="#memberInfoModal">${vo.qtMid}</a></c:if>
						<c:if test="${vo.board=='recruitBoard'}"><a href="#" onclick="modalView('${vo.rcMid}')" data-toggle="modal" data-target="#memberInfoModal">${vo.rcMid}</a></c:if>
					</td>
				</tr>
				<c:set var="curScrStartNo" value="${curScrStartNo - 1}"/>
			</c:forEach>
			<tr><td colspan="8" class="m-0 p-0"></td></tr>
		</table>
	</div>
</div>
<!-- 블록페이지 시작 -->	
<div class="text-center">
	<ul class="pagination justify-content-center" style="margin:20px 0">
		<c:if test="${pageVO.pag > 1}"><li class="page-item"><a class="page-link" href="reportBoardList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=1&pageSize=${pageVO.pageSize}">처음</a></li></c:if>
		<c:if test="${pageVO.curBlock > 0}"><li class="page-item"><a class="page-link" href="reportBoardList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">이전블록</a></li></c:if>
		<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
			<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><li class="page-item active"><a class="page-link" href="reportBoardList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
			<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><li class="page-item"><a class="page-link" href="reportBoardList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
		</c:forEach>
		<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><li class="page-item"><a class="page-link" href="reportBoardList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">다음블록</a></li></c:if>
		<c:if test="${pageVO.pag < pageVO.totPage}"><li class="page-item"><a class="page-link" href="reportBoardList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}">끝</a></li></c:if>
	</ul>
</div>
<!-- 블록페이지 끝 -->
<!-- 멤버 정보 모달에 출력하기 -->
<div class="modal fade" id="memberInfoModal">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
    
      <!-- Modal Header -->
      <div class="modal-header text-center">
        <h4 class="modal-title">회원 상세정보</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
    		<span id="content"></span>
    		<hr/>
    		<input type="button" onclick="memberDelete('modal')" value="탈퇴처리" class="btn btn-main btn-icon-sm btn-round" />
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
      
    </div>
  </div>
</div>
<p><br/></p>
</body>
</html>