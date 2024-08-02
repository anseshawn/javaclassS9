<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 견적 요청 리스트</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
	<style>
		#spinner {
		  position: absolute;
		  left: 50%;
		  top: 50%;
		  z-index: 1;
		}
		.badge.edit {
			background-color: #5089EF;
			color: #fff;
		}
		.badge.delete {
			background-color: #EC4651;
			color: #fff;
		}
		td {
			vertical-align: middle;
		}
	</style>
	<script>
		'use strict';
		
		let message = "";
		let icon = "";
		
		function allSelect(){
  		if(document.getElementById("allSelect").checked){
	  		for(let i=0; i<${vos.size()}; i++) {
	  			document.getElementsByName("selectContent")[i].checked = true;
	  		}  			
  		}
  		else {
	  		for(let i=0; i<${vos.size()}; i++) {
	  			document.getElementsByName("selectContent")[i].checked = false;
	  		}  
  		}
		}
		
		// 견적 상태별 보기
		function selectStatementShow() {
			let searchString = $("#searchPlace").val();
			location.href="${ctp}/admin/product/productEstimate?pag=${pageVo.pag}&pageSize=${pageVo.pageSize}&part=statement&searchString="+searchString;
		}
		
		// 견적 건 검색
		function estimateSearch() {
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
			location.href="${ctp}/admin/product/productEstimate?pag=${pageVo.pag}&pageSize=${pageVo.pageSize}&part="+part+"&searchString="+searchString;
		}
		
		function changeThisStatement(idx) {
			let statement = $("#changeStatement"+idx).val();
			console.log(statement);
			Swal.fire({
        html : "<h3>해당 건의 진행상태를 변경하시겠습니까?</h3>",
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
						url: "${ctp}/admin/product/productSaleChange",
						type: "post",
						data: {
							idx : idx,
							statement : statement
						},
						success: function(res){
							if(res != "0") {
								message = "진행상태가 변경되었습니다.";
								icon = "success";
							}
							else {
								message = "상태 변경에 실패했습니다.";
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
		
		function deleteEstimate() {
			let idxs = "";
			let cnt = 0;
			for(let i=0; i<document.getElementsByName("selectContent").length; i++) {
				if(document.getElementsByName("selectContent")[i].checked) {
					cnt++;
					idxs += document.getElementsByName("selectContent")[i].value+",";
				}
			}
			if(cnt==0) {
				alert("삭제할 항목을 선택하세요.");
				return false;
			}
			idxs = idxs.substring(0,idxs.length-1);
			Swal.fire({
        html : "<h3>선택한 견적 건을 삭제하시겠습니까?</h3>",
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
						url: "${ctp}/admin/product/productSaleDelete",
						type: "post",
						data: {
							idxs : idxs
						},
						success: function(res){
							if(res != "0") {
								message = "선택한 견적 건이 삭제되었습니다.";
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
		<div class="col-lg-12 text-center"><h2>견적 요청 리스트(총 ${fn:length(vos)} 건)</h2></div>
	</div>
	<div class="row">
		<div class="col-lg-12"><div class="divider2 mx-auto my-4 text-center" style="width:50%;"></div></div>
	</div>
	<div class="row mt-2">
		<div class="col-md-3">
			<div class="input-group">
				<select name="part" id="part" class="custom-select" style="height:36px;">
					<option value="">분류</option>
					<option value="mid">아이디</option>
					<option value="co_name">회사명</option>
					<option value="email">이메일</option>
				</select>
				<input type="text" name="searchString" id="searchString" class="form-control" style="height:36px;"/>
				<div class="input-group-append">
					<a href="javascript:estimateSearch()" class="btn btn-main btn-icon-md btn-round" style="padding:0.3rem 0.5rem;">검색<i class="fa-solid fa-magnifying-glass ml-1"></i></a>
				</div>
			</div>
		</div>
		<div class="col-md-3">
			<input type="button" onclick="location.href='${ctp}/admin/product/productEstimate';" value="전체보기" class="btn btn-main-2 btn-icon-md btn-round-full mb-2" style="padding:0.3rem 0.5rem;"/>
			<input type="button" onclick="deleteEstimate()" value="삭제" class="btn btn-main-3 btn-icon-md btn-round-full mb-2" style="padding:0.3rem 0.5rem;"/>
		</div>
		<div class="col-md-4 offset-md-2 text-right">
			<form name="searchSelect">
				<select name="searchStatement" id="searchStatement" class="custom-select mb-2" onchange="selectStatementShow()">
					<option>요청 상태</option>
					<option value="">전체</option>
					<option value="QUOTE" ${pageVo.searchString=="QUOTE" ? "selected" : ""}>견적요청</option>
					<option value="CANCEL" ${pageVo.searchString=="CANCEL" ? "selected" : ""}>취소</option>
					<option value="CHECK" ${pageVo.searchString=="CHECK" ? "selected" : ""}>견적발송</option>
					<option value="ORDERING" ${pageVo.searchString=="ORDERING" ? "selected" : ""}>발주요청</option>
					<option value="DELIVER" ${pageVo.searchString=="DELIVER" ? "selected" : ""}>발주진행</option>
					<option value="PAYMENT" ${pageVo.searchString=="PAYMENT" ? "selected" : ""}>결제대기</option>
					<option value="COMPLETE" ${pageVo.searchString=="COMPLETE" ? "selected" : ""}>진행완료</option>
				</select>
			</form>
		</div>
	</div>
	<hr/>
	<div class="row">
	<p><br/></p>
	<div class="col align-items-center">
		<table class="table table-hover text-center">
			<tr style="background:#003675; color:#fff;">
				<th><input type="checkbox" name="allSelect" id="allSelect" onclick="allSelect()" class="custom-conrol-input"/></th>
				<th>번호</th>
				<th>회사명</th>
				<th>담당자</th>
				<th>요청기기</th>
				<th>연락처</th>
				<th>이메일</th>
				<th>상태</th>
				<th>비고</th>
			</tr>
			<c:set var="curScrStartNo" value="${pageVO.curScrStartNo}"/>
			<c:forEach var="vo" items="${vos}" varStatus="st">
				<tr>
					<td>
						<form name="selectForm">
							<input type="checkbox" name="selectContent" id="selectContent${st.index}" value="${vo.idx}" />
						</form>
					</td>
					<td>${curScrStartNo}</td>
					<td>${vo.co_name}</td>
					<td>${vo.memberMid}</td>
					<td>${vo.productIdx}</td>
					<td>${vo.tel}</td>
					<td><a href="${ctp}/admin/emailInput/${vo.memberMid}">${vo.email}</a></td>
					<td>
						<!-- 
						<c:if test="${vo.statement == 'QUOTE'}"><font color="#E71825">견적요청</font></c:if>
						<c:if test="${vo.statement == 'CANCEL'}">취소</c:if>
						<c:if test="${vo.statement == 'CHECK'}">견적발송</c:if>
						<c:if test="${vo.statement == 'ORDERING'}"><font color="#E71825">발주요청</font></c:if>
						<c:if test="${vo.statement == 'DELIVER'}"><font color="#2768FF">발주진행</font></c:if>
						<c:if test="${vo.statement == 'PAYMENT'}">결제대기</c:if>
						<c:if test="${vo.statement == 'COMPLETE'}">진행완료</c:if>
						-->
						<select name="changeStatement" id="changeStatement${vo.idx}" class="custom-select" onchange="changeThisStatement(${vo.idx})">
							<option value="QUOTE" ${vo.statement=="QUOTE" ? "selected" : ""}>견적요청</option>
							<option value="CANCEL" ${vo.statement=="CANCEL" ? "selected" : ""}>취소</option>
							<option value="CHECK" ${vo.statement=="CHECK" ? "selected" : ""}>견적발송</option>
							<option value="ORDERING" ${vo.statement=="ORDERING" ? "selected" : ""}>발주요청</option>
							<option value="DELIVER" ${vo.statement=="DELIVER" ? "selected" : ""}>발주진행</option>
							<option value="PAYMENT" ${vo.statement=="PAYMENT" ? "selected" : ""}>결제대기</option>
							<option value="COMPLETE" ${vo.statement=="COMPLETE" ? "selected" : ""}>진행완료</option>
						</select>
					</td>
					<td><a href="${ctp}/admin/product/productEstimateDetail?idx=${vo.idx}" class="btn btn-main btn-icon-sm">상세보기</a></td>
				</tr>
				<c:set var="curScrStartNo" value="${curScrStartNo - 1}"/>
			</c:forEach>
			<tr><td colspan="9" class="m-0 p-0"></td></tr>
		</table>
		</div>
		<p><br/></p>
	</div>
</div>
<!-- 블록페이지 시작 -->	
<div class="text-center">
	<ul class="pagination justify-content-center" style="margin:20px 0">
		<c:if test="${pageVO.pag > 1}"><li class="page-item"><a class="page-link" href="productEstimate?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=1&pageSize=${pageVO.pageSize}">처음</a></li></c:if>
		<c:if test="${pageVO.curBlock > 0}"><li class="page-item"><a class="page-link" href="productEstimate?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">이전블록</a></li></c:if>
		<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
			<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><li class="page-item active"><a class="page-link" href="productEstimate?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
			<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><li class="page-item"><a class="page-link" href="productEstimate?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
		</c:forEach>
		<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><li class="page-item"><a class="page-link" href="productEstimate?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">다음블록</a></li></c:if>
		<c:if test="${pageVO.pag < pageVO.totPage}"><li class="page-item"><a class="page-link" href="productEstimate?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}">끝</a></li></c:if>
	</ul>
</div>
<!-- 블록페이지 끝 -->

</body>
</html>