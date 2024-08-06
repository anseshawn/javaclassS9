<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 엔지니어 리스트</title>
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
			let str = '<table class="table table-bordered text-center">';
			$.ajax({
				url: "${ctp}/admin/engineer/engineerList/"+mid,
				type: "post",
				data: {mid:mid},
				success: function(mVo) {
					let joinDate = mVo.joinDate.substring(0,10);
					str += '<tr>';
					str += '<td rowspan="5" colspan="2"><img src="${ctp}/engineer/'+mVo.photo+'" width="200px" /></td></tr>';
					str += '<tr><th>이름</th><td>'+mVo.name+'</td></tr>';
					str += '<tr><th>고유번호</th><td>'+mVo.idx+'</td></tr>';
					str += '<tr><th>아이디</th><td><span id="selectMid">'+mVo.mid+'</span></td></tr>';
					str += '<tr><th>입사일</th><td>'+joinDate+'</td></tr>';
					str += '<tr><th>이메일</th><td>'+mVo.email+'</td>';
					str += '<th>연락처</th><td>'+mVo.tel+'</td></tr>';
					str += '<tr><th>출장 가능 지역</th><td colspan="3">'+mVo.place+'</td></tr>';
					str += '<tr><th>담당기기</th><td colspan="3">'+mVo.machine+'</td></tr>';
					/*	
					str += "<tr><td><img src='${ctp}/images/"+mVo.photo+"' width='200px'/></td>";
					str += "<td><tr><th>이름</th><td>"+mVo.name+"</td></tr><tr><th>고유번호</th><td>"+mVo.idx+"</td></tr></td>";
					str += "<td><tr><th>아이디</th><td>"+mVo.mid+"</td></tr><tr><th>입사일</th><td>"+mVo.joinDate+"</td></tr></td></tr>";
					str += "<tr><th>이메일</th><td>"+mVo.email+"</td><th>연락처</th><td>"+mVo.tel+"</td></tr>";
					str += "<tr><th>출장 가능 지역</th><td colspan='3'>"+mVo.place+"</td></tr>"
					str += "<tr><th>담당 기기</th><td colspan='3'>"+mVo.machine+"</td></tr>";
					str += "</table>";
					*/
					str += '</table>';
					$("#content").html(str);
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
		
		// 사원 삭제 or 모달에서 지정한 사원 삭제
		function engineerDelete(mid) {
			if(mid==='modal') mid = document.getElementById("selectMid").innerText;
			let message = "";
			let icon = "";
			
			Swal.fire({
        html : "<h3>선택한 사원을 삭제하시겠습니까?</h3>",
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
						url: "${ctp}/admin/engineer/engineerDelete",
						type: "post",
						data: {mid:mid},
						success: function(res){
							if(res != "0") {
								message = "사원 정보를 삭제했습니다.";
								icon = "success";
							}
							else {
								message = "삭제에 실패했습니다.\n(근무 중인 사원은 삭제할 수 없습니다. 정보를 다시 확인하세요.)";
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
		
		// 사원 지역별 보기
		function selectPlaceShow() {
			let searchString = $("#searchPlace").val();
			location.href="${ctp}/admin/engineer/engineerList?pag=${pageVo.pag}&pageSize=${pageVo.pageSize}&part=place&searchString="+searchString;
		}
		// 사원 기기별 보기
		function selectMachineShow() {
			let searchString = $("#searchMachine").val();
			location.href="${ctp}/admin/engineer/engineerList?pag=${pageVo.pag}&pageSize=${pageVo.pageSize}&part=machine&searchString="+searchString;
		}
		
		// 사원 검색
		function engineerSearch() {
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
			location.href="${ctp}/admin/engineer/engineerList?pag=${pageVo.pag}&pageSize=${pageVo.pageSize}&part="+part+"&searchString="+searchString;
		}
		
		// 선택 사원 메일 보내기
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
				alert("메일을 전송할 사원을 선택하세요.");
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
		<div class="col-lg-12 text-center"><h2>전체 엔지니어 리스트(총 ${pageVO.totRecCnt} 건)</h2></div>
	</div>
	<div class="row">
		<div class="col-lg-12"><div class="divider2 mx-auto my-4 text-center" style="width:50%;"></div></div>
	</div>
	<div class="row">
		<div class="col-md-3">
			<div class="input-group">
				<select name="part" id="part" class="custom-select" style="height:36px;">
					<option value="">분류</option>
					<option value="mid" ${pageVO.part=='mid'? 'selected' : ''}>아이디</option>
					<option value="name" ${pageVO.part=='name'? 'selected' : ''}>이름</option>
					<option value="email" ${pageVO.part=='email'? 'selected' : ''}>이메일</option>
				</select>
				<input type="text" name="searchString" id="searchString" class="form-control" style="height:36px;"/>
				<div class="input-group-append">
					<a href="javascript:engineerSearch()" class="btn btn-main btn-icon-md btn-round" style="padding:0.3rem 0.5rem;">검색<i class="fa-solid fa-magnifying-glass ml-1"></i></a>
				</div>
			</div>
		</div>
		<div class="col-md-3">
			<input type="button" onclick="location.href='${ctp}/admin/engineer/engineerList';" value="전체보기" class="btn btn-main-2 btn-icon-md btn-round-full" style="padding:0.3rem 0.5rem;"/>
			<input type="button" onclick="sendEmail()" value="메일보내기" class="btn btn-main btn-icon-md btn-round-full" style="padding:0.3rem 0.5rem;"/>
		</div>
		<div class="col-md-4 offset-md-2 text-right">
			<form name="searchSelect">
				<div class="input-group">
					<select name="searchMachine" id="searchMachine" class="custom-select" onchange="selectMachineShow()">
						<option>기기별 보기</option>
						<option value="">전체</option>
						<option value="UV" ${pageVO.searchString=='UV' ? 'selected' : ''}>UV</option>
						<option value="AAs" ${pageVO.searchString=='AAs' ? 'selected' : ''}>AAs</option>
						<option value="ICP" ${pageVO.searchString=='ICP' ? 'selected' : ''}>ICP</option>
						<option value="GC" ${pageVO.searchString=='GC' ? 'selected' : ''}>GC</option>
						<option value="LC" ${pageVO.searchString=='LC' ? 'selected' : ''}>LC</option>
						<option value="etc" ${pageVO.searchString=='etc' ? 'selected' : ''}>기타</option>
					</select>
					<select name="searchPlace" id="searchPlace" class="custom-select" onchange="selectPlaceShow()">
						<option>지역별 보기</option>
						<option value="">전체</option>
						<option value="서울" ${pageVO.searchString=='서울' ? 'selected' : ''}>서울</option>
						<option value="인천" ${pageVO.searchString=='인천' ? 'selected' : ''}>인천</option>
						<option value="부산" ${pageVO.searchString=='부산' ? 'selected' : ''}>부산</option>
						<option value="대구" ${pageVO.searchString=='대구' ? 'selected' : ''}>대구</option>
						<option value="광주" ${pageVO.searchString=='광주' ? 'selected' : ''}>광주</option>
						<option value="대전" ${pageVO.searchString=='대전' ? 'selected' : ''}>대전</option>
						<option value="울산" ${pageVO.searchString=='울산' ? 'selected' : ''}>울산</option>
						<option value="세종" ${pageVO.searchString=='세종' ? 'selected' : ''}>세종</option>
						<option value="경기" ${pageVO.searchString=='경기' ? 'selected' : ''}>경기</option>
						<option value="강원" ${pageVO.searchString=='강원' ? 'selected' : ''}>강원</option>
						<option value="충북" ${pageVO.searchString=='충북' ? 'selected' : ''}>충북</option>
						<option value="충남" ${pageVO.searchString=='충남' ? 'selected' : ''}>충남</option>
						<option value="전북" ${pageVO.searchString=='전북' ? 'selected' : ''}>전북</option>
						<option value="전남" ${pageVO.searchString=='전남' ? 'selected' : ''}>전남</option>
						<option value="경북" ${pageVO.searchString=='경북' ? 'selected' : ''}>경북</option>
						<option value="경남" ${pageVO.searchString=='경남' ? 'selected' : ''}>경남</option>
						<option value="제주" ${pageVO.searchString=='제주' ? 'selected' : ''}>제주</option>
					</select>
				</div>
			</form>
		</div>
	</div>
	<hr/>
	<div class="row">
		<div class="col-lg-9">
			<table class="table table-hover text-center">
				<tr style="background:#003675; color:#fff;">
					<th><input type="checkbox" name="allSelect" id="allSelect" onclick="allSelect()" class="custom-conrol-input"/></th>
					<th>번호</th>
					<th>이름</th>
					<th>아이디</th>
					<th>이메일</th>
					<th>담당 지역</th>
					<th>담당 기기</th>
					<th>비고</th>
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
							<a href="#" onclick="modalView('${vo.mid}')" data-toggle="modal" data-target="#engineerInfoModal">${vo.mid}</a>
						</td>
						<td><a href="${ctp}/admin/emailInput/${vo.mid}">${vo.email}</a></td>
						<td>${vo.place}</td>
						<td>${vo.machine}</td>
						<td>
							<a href="${ctp}/admin/engineer/engineerUpdate?idx=${vo.idx}" class="badge edit">수정</a>
							<a href="javascript:engineerDelete('${vo.mid}')" class="badge delete">삭제</a>
						</td>
					</tr>
					<c:set var="curScrStartNo" value="${curScrStartNo - 1}"/>
				</c:forEach>
				<tr><td colspan="8" class="m-0 p-0"></td></tr>
			</table>
		</div>
		<div class="col-lg-3 text-center align-items-center">
			<table class="table table-bordered text-center">
				<tr>
					<th>번호</th>
					<th>이름</th>
					<th>별점</th>
				</tr>
				<c:forEach var="vo" items="${vos}" varStatus="st">
					<tr>
						<td>${st.count}</td>
						<td>${vo.name}</td>
						<td>
							<c:forEach var="i" begin="1" end="${vo.starPoint}" varStatus="st1"><font color="gold">
								<i class="fa-solid fa-star"></i></font>
							</c:forEach>
							<c:forEach var="i" begin="1" end="${5 - vo.starPoint}" varStatus="st2">
								<font color="#ddd"><i class="fa-solid fa-star"></i></font>
							</c:forEach>
						</td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
	<!-- 블록페이지 시작 -->	
	<div class="text-center">
		<ul class="pagination justify-content-center" style="margin:20px 0">
			<c:if test="${pageVO.pag > 1}"><li class="page-item"><a class="page-link" href="engineerList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=1&pageSize=${pageVO.pageSize}">처음</a></li></c:if>
			<c:if test="${pageVO.curBlock > 0}"><li class="page-item"><a class="page-link" href="engineerList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">이전블록</a></li></c:if>
			<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
				<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><li class="page-item active"><a class="page-link" href="engineerList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
				<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><li class="page-item"><a class="page-link" href="engineerList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></li></c:if>
			</c:forEach>
			<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><li class="page-item"><a class="page-link" href="engineerList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}">다음블록</a></li></c:if>
			<c:if test="${pageVO.pag < pageVO.totPage}"><li class="page-item"><a class="page-link" href="engineerList?search=${pageVo.search}&searchString=${pageVo.searchString}&pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}">끝</a></li></c:if>
		</ul>
	</div>
	<!-- 블록페이지 끝 -->
</div>
<!-- 멤버 정보 모달에 출력하기 -->
<div class="modal fade" id="engineerInfoModal">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
    
      <!-- Modal Header -->
      <div class="modal-header text-center">
        <h4 class="modal-title">사원 상세정보</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
    		<span id="content"></span>
    		<hr/>
    		<input type="button" onclick="engineerDelete('modal')" value="삭제하기" class="btn btn-main btn-icon-sm btn-round" />
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