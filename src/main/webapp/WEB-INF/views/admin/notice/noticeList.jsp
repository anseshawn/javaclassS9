<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자 - 공지사항 목록</title>
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
		.btn.important {
			pointer-events: none;
      cursor: none;
      background-color: #5089EF;
      border-color: #5089EF;
      color: #fff;
      border-radius: 0px;
		}
		.badge.delete {
			background-color: #8E8E8E;
			color: #fff;
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
		
		function noticeSearch() {
			let part = $("#part").val();
			let searchString = $("#searchString").val();
			if($("#part").val() != 'part' && searchString.trim()=="") {
				alert("검색어를 입력하세요.");
				return false;
			}
			if(part=='part') searchString = $("#partSelect").val();
			location.href="${ctp}/admin/notice/noticeList?part="+part+"&searchString="+searchString;
		}
		
		function deleteCheck(idx){
			let ans = confirm("현재 공지사항을 삭제하시겠습니까?");
			if(!ans) return false;
			location.href="${ctp}/admin/notice/noticeDelete?idx="+idx;
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="spinner-border text-muted" id="spinner" style="display:none;"></div>
<div class="container">
	<div class="row">
		<div class="col-lg-12 text-center"><h2>공지사항 리스트 (총 ${fn:length(vos)} 건)</h2></div>
	</div>
	<div class="row">
		<div class="col-lg-12"><div class="divider2 mx-auto my-4 text-center" style="width:50%;"></div></div>
	</div>
	<div class="row mb-2">
		<div class="col-md-3">
			<div class="input-group">
				<select name="part" id="part" class="form-control" onchange="searchValue()">
					<option value="title">제목</option>
					<option value="content">내용</option>
					<option value="part">분류</option>
				</select>
				<select name="partSelect" id="partSelect" class="form-control mt-2" style="display:none;">
					<option>공지사항</option>
					<option>이벤트</option>
				</select>
				<input type="text" name="searchString" id="searchString" class="form-control" style="height:36px;" required />
				<div class="input-group-append">
					<a href="javascript:noticeSearch()" class="btn btn-main btn-icon-md btn-round" style="padding:0.3rem 0.5rem;">검색<i class="fa-solid fa-magnifying-glass ml-1"></i></a>
				</div>
			</div>
		</div>
		<div class="col-md-3">
			<input type="button" onclick="location.href='${ctp}/admin/notice/noticeList';" value="전체보기" class="btn btn-main-2 btn-icon-md btn-round-full" style="padding:0.3rem 0.5rem;"/>
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
		<table class="table table-hover text-center">
			<tr style="pointer-events: none; background:#223a66; color:#fff;">
				<th>번호</th>
				<th>구분</th>
				<th>제목</th>
				<th>작성자</th>
				<th>작성일</th>
				<th>비고</th>
			</tr>
			<c:forEach var="iVo" items="${imVos}" varStatus="st">
				<tr>
					<td><input type="button" value="중요" class="btn important btn-main btn-icon-sm"/></td>
					<td>
						${iVo.part=='events' ? '이벤트' : ''}
						${iVo.part=='notices' ? '공지' : ''}
					</td>
					<td class="text-left">
						<a href="noticeContent?idx=${iVo.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}">${iVo.title}</a>
						<c:if test="${!empty iVo.endDate && today > fn:substring(iVo.endDate,0,10)}">
							<a href="#" class="badge delete">종료</a>
						</c:if>
					</td>
					<td>관리자</td>
					<td>${iVo.date_diff == 0 ? fn:substring(iVo.writeDate,11,19) : fn:substring(iVo.writeDate,0,10)}</td>
					<td>
						<input type="button" onclick="deleteCheck('${iVo.idx}')" class="btn btn-main-3 btn-icon-sm" value="삭제하기" />
					</td>
				</tr>
			</c:forEach>
			<c:set var="curScrStartNo" value="${pageVO.curScrStartNo}"/>
			<c:forEach var="vo" items="${vos}" varStatus="st">
				<tr>
					<td>${curScrStartNo}</td>
					<td>
						${vo.part=='events' ? '이벤트' : ''}
						${vo.part=='notices' ? '일반공지' : ''}
					</td>
					<td class="text-left">
						<a href="noticeContent?idx=${vo.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}">${vo.title}</a>
						<c:if test="${!empty vo.endDate && today > fn:substring(vo.endDate,0,10)}">
							<a href="#" class="badge delete ml-2">종료됨</a>
						</c:if>
					</td>
					<td>관리자</td>
					<td>${vo.date_diff == 0 ? fn:substring(vo.writeDate,11,19) : fn:substring(vo.writeDate,0,10)}</td>
					<td>
						<input type="button" onclick="deleteCheck('${vo.idx}')" class="btn btn-main-3 btn-icon-sm" value="삭제하기" />
					</td>
				</tr>
				<c:set var="curScrStartNo" value="${curScrStartNo-1}"/>
			</c:forEach>
			<tr><td colspan="6" class="m-0 p-0"></td></tr>
		</table>
	</div>
	<!-- 블록페이지 시작(목록 아래 딱 붙어 나오도록) -->	
  <div class="row mt-5 align-items-center">
    <div class="col-lg-9">
      <nav class="pagination py-2 d-inline-block">
        <div class="nav-links">
          <c:if test="${pageVO.pag > 1}"><a class="page-numbers" href="noticeList?pag=1&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-left"></i></a></c:if>
          <c:if test="${pageVO.curBlock > 0}"><a class="page-numbers" href="noticeList?pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-left"></i></a></c:if>
					<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
						<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><span aria-current="page" class="page-numbers current">${i}</span></c:if>
						<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><a class="page-numbers" href="noticeList?pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></c:if>
					</c:forEach>
					<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><a class="page-numbers" href="noticeList?pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-right"></i></a></c:if>
					<c:if test="${pageVO.pag < pageVO.totPage}"><a class="page-numbers" href="noticeList?pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-right"></i></a></c:if>
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