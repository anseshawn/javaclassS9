<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 유저 신고 리스트</title>
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
		
		// 차단내역 삭제하기
		function deleteAll() {
			let hostIp = "";
			let cnt = 0;
			for(let i=0; i<document.getElementsByName("selectReport").length; i++) {
				if(document.getElementsByName("selectReport")[i].checked) {
					cnt++;
					hostIp += document.getElementsByName("selectReport")[i].value+"|";
				}
			}
			if(cnt==0) {
				alert("삭제할 항목을 선택하세요.");
				return false;
			}
			hostIp = hostIp.substring(0,hostIp.length-1);
			Swal.fire({
        html : "<h3>선택한 신고 항목을 삭제하시겠습니까?</h3>",
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
						url: "${ctp}/admin/report/deleteReportMember",
						type: "post",
						data: {hostIp : hostIp},
						success: function(res){
							if(res != "0") {
								message = "선택한 항목을 삭제했습니다.";
								icon = "success";
							}
							else {
								message = "삭제 실패.\n현재 차단 중인 아이피인지 확인하세요.";
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
		
		// 유저 일괄 차단하기
		function blockIpAll() {
			let hostIp = "";
			let cnt = 0;
			for(let i=0; i<document.getElementsByName("selectReport").length; i++) {
				if(document.getElementsByName("selectReport")[i].checked) {
					cnt++;
					hostIp += document.getElementsByName("selectReport")[i].value+"|";
				}
			}
			if(cnt==0) {
				alert("차단할 유저를 선택하세요.");
				return false;
			}
			hostIp = hostIp.substring(0,hostIp.length-1);
			Swal.fire({
        html : "<h3>선택한 아이피를 차단하시겠습니까?</h3>",
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
						url: "${ctp}/admin/report/blockIpAll",
						type: "post",
						data: {hostIp : hostIp},
						success: function(res){
							if(res != "0") {
								message = "선택한 아이피를 일괄 차단했습니다.";
								icon = "success";
							}
							else {
								message = "차단에 실패했습니다.";
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
		
		// 유저 차단하기
		function blockIp(hostIp) {
			Swal.fire({
        html : "<h3>해당 유저를 하루동안 차단하시겠습니까?</h3>",
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
						url: "${ctp}/admin/report/blockIp",
						type: "post",
						data: {
							hostIp : hostIp
						},
						success: function(res){
							if(res != "0") {
								message = "해당 아이피를 차단했습니다.";
								icon = "success";
							}
							else {
								message = "차단에 실패했습니다.";
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
		
		// 차단 해제하기
		function deleteBlockIp(hostIp) {
			Swal.fire({
        html : "<h3>해당 유저의 차단을 해제하시겠습니까?</h3>",
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
						url: "${ctp}/admin/report/deleteBlockIp",
						type: "post",
						data: {
							hostIp : hostIp
						},
						success: function(res){
							if(res != "0") {
								message = "해당 아이피의 차단을 해제했습니다.";
								icon = "success";
							}
							else {
								message = "차단 해제에 실패했습니다.";
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
<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="spinner-border text-muted" id="spinner" style="display:none;"></div>
<div class="container">
	<div class="row">
		<div class="col-lg-12 text-center"><h2>신고 회원 목록(총 ${fn:length(vos)} 건)</h2></div>
	</div>
	<div class="row">
		<div class="col-lg-12"><div class="divider2 mx-auto my-4 text-center" style="width:50%;"></div></div>
	</div>
	<div class="row">
		<div class="col-md-3">
			<input type="button" onclick="location.href='${ctp}/admin/report/reportMemberList';" value="전체보기" class="btn btn-main-2 btn-icon-md btn-round-full" style="padding:0.3rem 0.5rem;"/>
			<input type="button" onclick="blockIpAll()" value="아이피차단" class="btn btn-main btn-icon-md btn-round-full" style="padding:0.3rem 0.5rem;"/>
			<input type="button" onclick="deleteAll()" value="삭제하기" class="btn btn-main btn-icon-md btn-round-full" style="padding:0.3rem 0.5rem;"/>
		</div>
	</div>
	<hr/>
	<div class="row">
		<table class="table table-hover text-center">
			<tr style="background:#003675; color:#fff;">
				<th><input type="checkbox" name="allSelect" id="allSelect" onclick="allSelect()" class="custom-conrol-input"/></th>
				<th>번호</th>
				<th>아이피</th>
				<th>신고날짜</th>
				<th>신고횟수</th>
				<th>차단횟수</th>
				<th>비고</th>
			</tr>
			<c:set var="curScrStartNo" value="${pageVO.curScrStartNo}"/>
			<c:forEach var="vo" items="${vos}" varStatus="st">
				<tr>
					<td>
						<form name="selectForm">
							<input type="checkbox" name="selectReport" id="selectReport${st}" value="${vo.hostIp}" />
						</form>
					</td>
					<td>${curScrStartNo}</td>
					<td>${vo.hostIp}</td>
					<td>${fn:substring(vo.rpDate,0,10)}</td>
					<td>${vo.rpNum}</td>
					<td>${vo.blockNum}</td>
					<td>
						<c:if test="${vo.block=='NO'}">
							<input type="button" value="차단하기" onclick="blockIp('${vo.hostIp}')" class="btn btn-main btn-icon-sm btn-round-full"/>
						</c:if>
						<c:if test="${vo.block=='OK'}">
							<input type="button" value="차단해제" onclick="deleteBlockIp('${vo.hostIp}')" class="btn btn-main-3 btn-icon-sm btn-round-full"/>
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
		<c:if test="${pageVO.pag > 1}"><li class="page-item"><a class="page-link" href="reportMemberList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=1&pageSize=${pageVO.pageSize}">처음</a></li></c:if>
		<c:if test="${pageVO.curBlock > 0}"><li class="page-item"><a class="page-link" href="reportMemberList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">이전블록</a></li></c:if>
		<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
			<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><li class="page-item active"><a class="page-link" href="reportMemberList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
			<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><li class="page-item"><a class="page-link" href="reportMemberList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
		</c:forEach>
		<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><li class="page-item"><a class="page-link" href="reportMemberList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">다음블록</a></li></c:if>
		<c:if test="${pageVO.pag < pageVO.totPage}"><li class="page-item"><a class="page-link" href="reportMemberList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}">끝</a></li></c:if>
	</ul>
</div>
<!-- 블록페이지 끝 -->

<p><br/></p>
</body>
</html>