<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자 - 문의내역 조회</title>
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
	<link rel="stylesheet" href="${ctp}/css/bootstrap-datepicker.css">
	<style>
	  .narrow-row .col {
	    padding-left: 2px;
	    padding-right: 2px;
	  }
		#spinner {
		  position: absolute;
		  left: 50%;
		  top: 50%;
		  z-index: 100;
		}
		.btn:disabled {
			pointer-events: none;
      cursor: none;
		}
	</style>
	<script>
		'use strict';
		$(function() {	
			$('.datePicker').datepicker({
			    format: "yyyy-mm-dd",	//데이터 포맷 형식(yyyy : 년 mm : 월 dd : 일 )
			    startDate: '-12m',	//달력에서 선택 할 수 있는 가장 빠른 날짜. 이전으로는 선택 불가능 ( d : 일 m : 달 y : 년 w : 주)
			    endDate: '-0d',	//달력에서 선택 할 수 있는 가장 느린 날짜. 이후로 선택 불가 ( d : 일 m : 달 y : 년 w : 주)
			    autoclose : true,
			    disableTouchKeyboard : false,
			    immediateUpdates: true, 
			    multidate : false, 
			    multidateSeparator :"~",
			    templates : {
			        leftArrow: '&laquo;',
			        rightArrow: '&raquo;'
			    }, 
			    showWeekDays : true,
			    todayHighlight : true , 
			    toggleActive : true,
			    weekStart : 0 , 
			    language : "ko"
			});
			// datepicker1에 한달 전 날짜 부여
      let now = new Date();
      let year = now.getFullYear();
      let month = now.getMonth();
      if(month.toString().length==1) month = "0"+month;
      let date = now.getDate();
      if(date.toString().length==1) date = "0"+date;
      let monthBefore = year+"-"+month+"-"+date;
      document.getElementById("datePicker1").value = monthBefore;
      
		});
		
		function searchValue() {
			if($("#part").val()=='part') {
				$("#partSelect").show();
				$("#searchString").hide();
			}
			else {
				$("#partSelect").hide();
				$("#searchString").show();				
			}
		}
		
		function consultingSearch() {
			let part = $("#part").val();
			let searchString = $("#searchString").val();
			if($("#part").val() != 'part' && searchString.trim()=="") {
				alert("검색어를 입력하세요.");
				return false;
			}
			if(part=='part') searchString = $("#partSelect").val();
			location.href="${ctp}/admin/consulting/consultingList?part="+part+"&searchString="+searchString;
		}
		
		function modalView(idx) {
			let str = "<table class='table text-center'>";
			$.ajax({
				url: "${ctp}/admin/consulting/consultingContent",
				type: "post",
				data: {idx : idx},
				success: function(cVo) {
					let writeDate = cVo.writeDate.substring(0,10);
					if(cVo.completeDate != null){
						let completeDate = cVo.completeDate.substring(0,10);
					}
					let content = cVo.content.replace(/\n/g,'<br/>');
					str += "<tr><th>이름</th><td>"+cVo.name+"</td><th>등록번호</th><td><span id='contentIdx'>"+cVo.idx+"</span></td></tr>";
					str += "<tr><th>이메일</th><td><span id='email'>"+cVo.email+"</span></td><th>연락처</th><td>"+cVo.phone+"</td></tr>";
					str += "<tr><th>주제</th><td>"+cVo.title+"</td><th>문의 날짜</th><td>"+writeDate+"</td></tr>";
					str += "<tr><th>문의 내용</th><td colspan='3'>"+content+"</td></tr>";
					str += "</table>";
					$("#content").html(str);
					if(cVo.completeDate != null) {
						$("#answerInputBtn").attr("disabled",true);
						$("#answer").html(cVo.answer);
						$("#answer").attr("readonly",true);
					}
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
		
		function answerInput() {
			document.getElementById("spinner").style.display='block';
			let answer = $("#answer").val();
			let email = document.getElementById("email").innerText
			let idx = document.getElementById("contentIdx").innerText
			
			let query = {
					answer : answer,
					email : email,
					idx : idx
			}
			$.ajax({
				url: "${ctp}/admin/consulting/consultingAnswer",
				type: "post",
				data: query,
				success: function(res) {
					document.getElementById("spinner").style.display='none';
					if(res != 0) {
						alert("답변이 등록되었습니다.");
						location.reload();
					}
					else alert("답변 등록 실패");
				},
				error: function() {
					document.getElementById("spinner").style.display='none';
					alert("전송 오류");
				}
			});
		}
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="spinner-border text-muted" id="spinner" style="display:none;"></div>
<div class="container">
	<div class="row">
		<div class="col-lg-12 text-center"><h2>전체 문의 현황 (총 ${pageVO.totRecCnt} 건)</h2></div>
	</div>
	<div class="row">
		<div class="col-lg-12"><div class="divider2 mx-auto my-4 text-center" style="width:50%;"></div></div>
	</div>
	<div class="row mb-2">
		<div class="col-md-3">
			<div class="input-group">
				<select name="part" id="part" class="custom-select" onchange="searchValue()" style="height:36px;">
					<option value="">분류</option>
					<option value="title" ${pageVO.part=='title'? 'selected' : ''}>주제</option>
					<option value="name" ${pageVO.part=='name'? 'selected' : ''}>이름</option>
					<option value="part" ${pageVO.part=='part'? 'selected' : ''}>불편사항신고</option>
				</select>
				<select name="partSelect" id="partSelect" class="custom-select" style="display:none;">
					<option>진행상황별 보기</option>
					<option value="">전체</option>
					<option value="SERVICE" ${pageVO.searchString=='SERVICE' ? 'selected' : ''}>상담요청</option>
					<option value="COMPLAINT" ${pageVO.searchString=='COMPLAINT' ? 'selected' : ''}>불편사항</option>
				</select>
				<input type="text" name="searchString" id="searchString" class="form-control" style="height:36px;"/>
				<div class="input-group-append">
					<a href="javascript:consultingSearch()" class="btn btn-main btn-icon-md btn-round" style="padding:0.3rem 0.5rem;">검색<i class="fa-solid fa-magnifying-glass ml-1"></i></a>
				</div>
			</div>
		</div>
		<div class="col-md-3">
			<input type="button" onclick="location.href='${ctp}/admin/consulting/consultingList';" value="전체보기" class="btn btn-main-2 btn-icon-md btn-round-full" style="padding:0.3rem 0.5rem;"/>
		</div>
		<div class="col-md-4 offset-md-2 text-right">
			<form name="dateForm" method="post">
				<div class="col ml-auto">
					<div class="row narrow-row align-items-center">
						<div class="input-group">
								<input type="text" id="datePicker1" name="startSearchDate" class="datePicker form-control">
							<div class="col-auto d-flex align-itmes-center px-0">~</div>
								<input type="text" id="datePicker2" name="endSearchDate" class="datePicker form-control" value="<%=java.time.LocalDate.now() %>">
							<div class="input-group-append">
								<input type="submit" value="검색" class="btn btn-main btn-icon-md btn-round"/>
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<div class="row mb-3">
		<div class="col-md-12">
			<table class="table table-hover text-center">
				<tr style="background:#003675; color:#fff;">
					<th>신청번호</th>
					<th>분류</th>
					<th>주제</th>
					<th>이름</th>
					<th>문의일자</th>
					<th>진행현황</th>
					<th>자세히보기</th>
				</tr>
				<c:forEach var="vo" items="${vos}">
					<tr>
						<td>${vo.idx}</td>
						<td>
							${vo.part=='SERVICE' ? '온라인 상담' : '불편사항'}
						</td>
						<td>${vo.title}</td>
						<td>${vo.name}</td>
						<td>
							${vo.date_diff==0 ? fn:substring(vo.writeDate,11,19) : fn:substring(vo.writeDate,0,10)}
						</td>
						<td>
							<c:if test="${empty vo.completeDate}"><font color="#E71825">답변미등록</font></c:if>
							<c:if test="${!empty vo.completeDate}">
								<font color="#717171">답변등록</font>
							</c:if>
						</td>
						<td>
							<a href="#" onclick="modalView('${vo.idx}')" data-toggle="modal" data-target="#myModal" class="btn btn-main btn-icon-sm">
								답변하기<i class="fa-solid fa-chevron-right ml-2"></i>
							</a>
						</td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
	<!-- 블록페이지 시작 -->	
  <div class="row mt-5">
    <div class="col-lg-9">
      <nav class="pagination py-2 d-inline-block">
        <div class="nav-links">
          <c:if test="${pageVO.pag > 1}"><a class="page-numbers" href="consultingList?pag=1&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-left"></i></a></c:if>
          <c:if test="${pageVO.curBlock > 0}"><a class="page-numbers" href="consultingList?pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-left"></i></a></c:if>
					<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
						<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><span aria-current="page" class="page-numbers current">${i}</span></c:if>
						<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><a class="page-numbers" href="consultingList?pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></c:if>
					</c:forEach>
					<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><a class="page-numbers" href="consultingList?pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-right"></i></a></c:if>
					<c:if test="${pageVO.pag < pageVO.totPage}"><a class="page-numbers" href="consultingList?pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-right"></i></a></c:if>
      	</div>
    	</nav>
		</div>
	</div>
	<!-- 블록페이지 끝 -->
	
<!-- 문의 내용과 답변 입력 창 모달에 출력하기 -->
<div class="modal fade" id="myModal">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
    
      <!-- Modal Header -->
      <div class="modal-header text-center">
        <h4 class="modal-title">답변 등록</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
    		<span id="content"></span>
    		<hr/>
    		<table class="table table-borderless text-center">
    			<tr>
	    			<th>답변</th>
	    			<td><textarea rows="3" name="answer" id="answer" class="form-control"></textarea></td>
    			</tr>
    		</table>
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" onclick="answerInput()" id="answerInputBtn" class="btn btn-main btn-icon-md">등록하기</button>
        <button type="button" class="btn btn-main-3 btn-icon-md" data-dismiss="modal">Close</button>
      </div>
      
    </div>
  </div>
</div>
<p><br/></p>	
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.js"></script>
<script src="${ctp}/js/bootstrap-datepicker.ko.js"></script>
</body>
</html>