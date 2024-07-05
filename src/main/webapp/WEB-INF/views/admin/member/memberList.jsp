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
	<script>
		'use strict';
		
		function allSelect(){
  		if(document.getElementById("aSelect").checked){
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
					str += "<tr><th>이메일</th><td>"+mVo.email+"</td><th>뉴스레터<br/>구독여부</th><td>"+mVo.emailNews+"</td></tr>";
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
        customClass: {
        	confirmButton : 'swal2-confirm‎',
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
								location.reload();
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
        customClass: {
        	confirmButton : 'swal2-confirm‎',
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
		
		// 회원 등급별 보기
		function selectLevelShow() {
			let m_group = $("#searchLevel").val();
			location.href="${ctp}/admin/member/memberList?m_group="+m_group;
		}
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
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
				<div class="input-group-prepend">
					<select name="part" id="part" class="custom-select">
						<option>셀렉트</option>
					</select>
				</div>
				<input type="text" name="searchString" id="searchString" class="form-control"/>
				<div class="input-group-append"><a href="#" class="btn btn-main btn-icon-sm btn-round">검색</a></div>
			</div>
		</div>
		<div class="col-md-3">
			<input type="button" onclick="sendEmail()" value="메일보내기" class="btn btn-main btn-icon btn-round"/>
		</div>
		<div class="col-md-3 offset-md-3 text-right">
			<form name="searchSelect">
				<select name="searchLevel" id="searchLevel" class="custom-select" onchange="selectLevelShow()">
					<option>등급별 보기</option>
					<option value="">전체회원</option>
					<option value="개인">개인회원</option>
					<option value="재직자">기업회원</option>
				</select>
			</form>
		</div>
	</div>
	<hr/>
	<div class="row">
		<table class="table table-hover text-center">
			<tr style="background:#003675; color:#fff;">
				<th><input type="checkbox" name="aSelect" id="aSelect" onclick="allSelect()" class="custom-conrol-input"/></th>
				<th>번호</th>
				<th>이름</th>
				<th>아이디</th>
				<th>이메일</th>
				<th>뉴스레터</th>
				<th>등급</th>
				<th>탈퇴신청</th>
			</tr>
			<c:forEach var="vo" items="${vos}" varStatus="st">
				<tr>
					<td><input type="checkbox" name="selectUser" id="selectUser${st}" value="${vo.idx}" /></td>
					<td>${vo.idx}</td>
					<td>${vo.name}</td>
					<td>
						<a href="#" onclick="modalView('${vo.mid}')" data-toggle="modal" data-target="#memberInfoModal">${vo.mid}</a>
					</td>
					<td>${vo.email}</td>
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
			</c:forEach>
			<tr><td colspan="8" class="m-0 p-0"></td></tr>
		</table>
	</div>
</div>

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