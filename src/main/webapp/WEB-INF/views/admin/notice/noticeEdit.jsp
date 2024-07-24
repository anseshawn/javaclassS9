<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>공지사항 수정</title>
  <script src="${ctp}/ckeditor/ckeditor.js"></script>
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<link rel="stylesheet" href="${ctp}/css/bootstrap-datepicker.css">
   <style>
      .input-group {
          align-items: center;
      }
      .form-check {
          display: flex;
          align-items: center;
          margin-left: 10px;
      }
      .form-check-input {
          margin-top: 0;
      }
  </style>
	<script>
		'use strict';
		
		$(function() {	
			if('${vo.important}'=='OK') $("#important").prop("checked",true);
			if('${vo.popup}'=='OK') $("#popup").prop("checked",true);
			
			$('#endDate').datepicker({
			    format: "yyyy-mm-dd",	//데이터 포맷 형식(yyyy : 년 mm : 월 dd : 일 )
			    startDate: '-0d',	//달력에서 선택 할 수 있는 가장 빠른 날짜. 이전으로는 선택 불가능 ( d : 일 m : 달 y : 년 w : 주)
			    endDate: '+1y',	//달력에서 선택 할 수 있는 가장 느린 날짜. 이후로 선택 불가 ( d : 일 m : 달 y : 년 w : 주)
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
		});
		
		function noticeValue(){
			if($("#part").val()=='events') {
				$("#datePick").show();
			}
			else {
				$("#datePick").hide();
			}
		}
		
		function fCheck(){
			let part = $("#part").val();
			let title = $("#title").val();
			
			if(part.trim()=="") {
				alert("공지 카테고리를 선택하세요.");
				return false;
			}
			else if(title.trim()=="") {
				alert("제목을 입력하세요.");
				myform.title.focus();
				return false;
			}
			
			myform.submit();
		}
		
		// 팝업 띄운 다른 창이 있나 체크
		function popupCheck() {
			let checked = $("#popup").is(':checked');
			if(checked){
				let ans = confirm("해당 공지를 팝업에서 제거하시겠습니까?");
				if(!ans) return false;
				else popupChange();
			}
			else {
				$.ajax({
					url: "${ctp}/admin/notice/popupCheck",
					type: "post",
					success: function(res) {
						console.log("체크중...");
						if(res != 0) {
							let ans = confirm("이미 팝업으로 띄우는 공지가 존재합니다.\n해당 공지를 대체하겠습니까?");
							if(!ans) {
								$("#popup").prop("checked",false);
							}
							else {
								popupChange();
							}
						}
					},
					error: function() {
						alert("전송 오류");
					}
				});
			}
		}
		
		// 기존에 있는 팝업창 삭제하기
		function popupChange() {
			$.ajax({
				url: "${ctp}/admin/notice/popupChange",
				type: "post",
				success: function(res) {
					if(res != 0) {
						$("#popup").prop("checked",true);
					}
					else {
						alert("기존의 팝업 공지를 내리는데 실패했습니다. 다시 시도하세요.");
					}
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
	</script>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
<div class="text-center"><h2>공지사항 수정</h2></div>
<div class="divider2 mx-auto my-4" style="width:70%;"></div>
<form name="myform" method="post">
	<div class="row justify-content-center mb-2">
		<div class="col-md-8">
			<div class="form-group">
				<select class="form-control" name="part" id="part" onchange="noticeValue()" style="height:45px;">
					<option>분류</option>
					<option value="notices" ${vo.part=='notices' ? 'selected' : ''}>공지</option>
					<option value="events" ${vo.part=='events' ? 'selected' : ''}>이벤트</option>
				</select>
			</div>
		</div>
	</div>
	<div class="row justify-content-center mb-3" id="datePick" style="display:none;">
		<div class="col-md-8 col-md-offset-2"><h4>이벤트 마감일</h4>
			<input type="text" id="endDate" name="endDate" class="form-control" value="${!empty vo.endDate ? 'vo.endDate' : today}">
		</div>
	</div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-8 col-md-offset-2"><h4>제목</h4>
			<div class="input-group">
				<input type="text" name="title" id="title" class="form-control mt-2" value="${vo.title}" placeholder="제목을 입력하세요" required/>
				<div class="form-check">
				  <input class="form-check-input" type="checkbox" value="OK" name="important" id="important"/>
				  <label class="form-check-label" for="important">
				    주요 공지 등록
				  </label>
				</div>
			</div>
		</div>
	</div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-8 col-md-offset-2"><h4>내용</h4>
			<textarea name="content" id="CKEDITOR" rows="5" class="form-control">${vo.content}</textarea>
			<script>
				CKEDITOR.replace("content",{
					height:450,
					filebrowserUploadUrl: "${ctp}/imageUpload",	/* 파일(이미지)를 업로드 시키기 위한 매핑경로(메소드) */
					uploadUrl: "${ctp}/imageUpload"	/* uploadUrl : 여러개의 그림파일을 드래그&드롭해서 올릴 수 있다. */
				});
			</script>
		</div>
	</div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-8 col-md-offset-2 text-right">
		<div class="form-check">
		  <input class="form-check-input" type="checkbox" value="OK" name="popup" id="popup" onclick="popupCheck()"/>
		  <label class="form-check-label" for="popup">
		    팝업으로 띄우기
		  </label>
		</div>
		</div>
	</div>
	<div class="divider2 mx-auto my-4" style="width:70%;"></div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-8 col-md-offset-2 text-right">
			<input type="button" value="수정하기" onclick="fCheck()" class="btn btn-main-2 btn-icon btn-round-full" />
			<a href="${ctp}/admin/notice/noticeList?pag=${pageVO.pag}&pageSize=${pageVO.pageSize}" class="btn btn-main btn-icon btn-round-full">취소</a>
		</div>
	</div>
	<input type="hidden" name="idx" value="${vo.idx}"/>
</form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.js"></script>
<script src="${ctp}/js/bootstrap-datepicker.ko.js"></script>
</body>
</html>