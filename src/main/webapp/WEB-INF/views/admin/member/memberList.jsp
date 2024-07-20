<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 회원 리스트</title>
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
		
		function allSelect(){
  		if(document.getElementById("allSelect").checked){
	  		for(let i=0; i<${vos.size()}; i++) {
	  			document.getElementsByName("selectUser")[i].checked = true;
	  		}  			
  		}
  		else {
	  		for(let i=0; i<${vos.size()}; i++) {
	  			document.getElementsByName("selectUser")[i].checked = false;
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
					if(mVo.level==3) {
						str += "<tr><th>재직자 여부</th><td colspan='3'>"+mVo.m_group+"<input type='button' onclick='changeLevel()' value='재직자인증' class='btn btn-main-2 btn-icon-sm btn-round ml-4' /></td></tr>";
					}
					else if(mVo.level<3){
						str += "<tr><th>재직자 여부</th><td colspan='3'>"+mVo.m_group+"</td></tr>"
					}
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
		
		// 등급 변경
		function changeLevel() {
			let mid = document.getElementById("selectMid").innerText;
			let message = "";
			let icon = "";
			
			Swal.fire({
        html : "<h3>선택한 회원의 등급을 재직자로 변경하시겠습니까?</h3>",
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
						url: "${ctp}/admin/member/memberChangeLevel",
						type: "post",
						data: {mid:mid},
						success: function(res){
							if(res != "0") {
								message = "등급 변경이 완료되었습니다.";
								icon = "success";
							}
							else {
								message = "등급 변경에 실패했습니다.";
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
		
		// 30일 경과 탈퇴 회원 삭제 or 모달에서 지정한 회원 삭제
		function memberDelete(mid) {
			if(mid==='modal') mid = document.getElementById("selectMid").innerText;
			let message = "";
			let icon = "";
			
			Swal.fire({
        html : "<h3>선택한 회원을 DB에서 영구 삭제하시겠습니까?</h3>",
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
		
		// 회원 등급별 보기
		function selectLevelShow() {
			let m_group = $("#searchLevel").val();
			location.href="${ctp}/admin/member/memberList?pag=${pageVO.pag}&pageSize=${pageVO.pageSize}&m_group="+m_group;
		}
		
		// 회원 검색
		function memberSearch() {
			let part = $("#part").val();
			let searchString = $("#searchString").val();
			if(part.trim()=="") {
				alert("검색 분류를 선택하세요.");
				return false;
			}
			if(searchString.trim()=="") {
				alert("검색어를 입력하세요.");
				return false;
			}
			location.href="${ctp}/admin/member/memberList?pag=${pageVO.pag}&pageSize=${pageVO.pageSize}&part="+part+"&searchString="+searchString;
		}
		
		// 선택 회원 메일 보내기
		function sendEmail() {
			document.getElementById("spinner").style.display='block';
			let mids = "";
			let cnt = 0;
			for(let i=0; i<document.getElementsByName("selectUser").length; i++) {
				if(document.getElementsByName("selectUser")[i].checked) {
					cnt++;
					mids += document.getElementsByName("selectUser")[i].value+",";
				}
			}
			if(cnt==0) {
				alert("메일을 전송할 회원을 선택하세요.");
				document.getElementById("spinner").style.display='none';
				return false;
			}
			mids = mids.substring(0,mids.length-1);
			location.href="${ctp}/admin/emailInput/"+mids;
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
		<div class="col-lg-12 text-center"><h2>전체 회원 리스트(총 ${fn:length(vos)} 건)</h2></div>
	</div>
	<div class="row">
		<div class="col-lg-12"><div class="divider2 mx-auto my-4 text-center" style="width:50%;"></div></div>
	</div>
	<div class="row">
		<div class="col-md-3">
			<div class="input-group">
				<select name="part" id="part" class="custom-select" style="height:36px;">
					<option value="">분류</option>
					<option value="mid" ${pageVO.part=='mid' ? 'selected' : ''}>아이디</option>
					<option value="name" ${pageVO.part=='name' ? 'selected' : ''}>이름</option>
					<option value="email" ${pageVO.part=='email' ? 'selected' : ''}>이메일</option>
				</select>
				<input type="text" name="searchString" id="searchString" class="form-control" style="height:36px;"/>
				<div class="input-group-append">
					<a href="javascript:memberSearch()" class="btn btn-main btn-icon-md btn-round" style="padding:0.3rem 0.5rem;">검색<i class="fa-solid fa-magnifying-glass ml-1"></i></a>
				</div>
			</div>
		</div>
		<div class="col-md-3">
			<input type="button" onclick="location.href='${ctp}/admin/member/memberList';" value="전체보기" class="btn btn-main-2 btn-icon-md btn-round-full" style="padding:0.3rem 0.5rem;"/>
			<input type="button" onclick="sendEmail()" value="메일보내기" class="btn btn-main btn-icon-md btn-round-full" style="padding:0.3rem 0.5rem;"/>
		</div>
		<div class="col-md-3 offset-md-3 text-right">
			<form name="searchSelect">
				<select name="searchLevel" id="searchLevel" class="custom-select" onchange="selectLevelShow()">
					<option>등급별 보기</option>
					<option value="">전체</option>
					<option value="개인" ${pageVO.searchString=='개인' ? 'selected' : ''}>개인회원</option>
					<option value="재직자" ${pageVO.searchString=='재직자' ? 'selected' : ''}>기업회원</option>
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
				<th>이름</th>
				<th>아이디</th>
				<th>이메일</th>
				<th>뉴스레터<a href="${ctp}/admin/member/memberList?part=emailNews&searchString=OK" style="color:#fff"><i class="fa-solid fa-caret-down ml-1"></i></a></th>
				<th>등급</th>
				<th>탈퇴신청</th>
			</tr>
			<c:set var="curScrStartNo" value="${pageVO.curScrStartNo}"/>
			<c:forEach var="vo" items="${vos}" varStatus="st">
				<tr>
					<td>
						<form name="selectForm">
							<input type="checkbox" name="selectUser" id="selectUser${st}" value="${vo.mid}" />
						</form>
					</td>
					<td>${curScrStartNo}</td>
					<td>${vo.name}</td>
					<td>
						<a href="#" onclick="modalView('${vo.mid}')" data-toggle="modal" data-target="#memberInfoModal">${vo.mid}</a>
					</td>
					<td><a href="${ctp}/admin/emailInput/${vo.mid}">${vo.email}</a></td>
					<td>${vo.emailNews}</td>
					<td>
						<c:if test="${vo.level==3}">개인회원</c:if>
						<c:if test="${vo.level==2}">기업회원</c:if>
						<c:if test="${vo.level==1}">엔지니어</c:if>
						<c:if test="${vo.level==0}">관리자</c:if>
					</td>
					<td>
						<c:if test="${vo.deleteDiff < 30}">
							<c:if test="${vo.userDel=='OK'}"><font color="#EB003B">${vo.userDel}</font></c:if>
							<c:if test="${vo.userDel!='OK'}">${vo.userDel}</c:if>
						</c:if>
						<c:if test="${vo.deleteDiff >= 30}">
							<input type="button" onclick="memberDelete('${vo.mid}')" class="btn btn-icon-sm btn-danger" value="탈퇴처리"/>
						</c:if>
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
		<c:if test="${pageVO.pag > 1}"><li class="page-item"><a class="page-link" href="memberList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=1&pageSize=${pageVO.pageSize}">처음</a></li></c:if>
		<c:if test="${pageVO.curBlock > 0}"><li class="page-item"><a class="page-link" href="memberList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">이전블록</a></li></c:if>
		<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
			<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><li class="page-item active"><a class="page-link" href="memberList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
			<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><li class="page-item"><a class="page-link" href="memberList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
		</c:forEach>
		<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><li class="page-item"><a class="page-link" href="memberList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">다음블록</a></li></c:if>
		<c:if test="${pageVO.pag < pageVO.totPage}"><li class="page-item"><a class="page-link" href="memberList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}">끝</a></li></c:if>
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

</body>
</html>