<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>신청내용 확인</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<link rel="stylesheet" href="${ctp}/css/bootstrap-datepicker.css">
	<style>
		.content th {
			background-color: #0E2B5E; 
			color: #fff;
		}
	</style>
	<script>
		'use strict';
		
		let message = "";
		let icon = "";
		
		$(function() {
			$('#datePicker').datepicker({
			    format: "yyyy-mm-dd",	//데이터 포맷 형식(yyyy : 년 mm : 월 dd : 일 )
			    startDate: '-0d',	//달력에서 선택 할 수 있는 가장 빠른 날짜. 이전으로는 선택 불가능 ( d : 일 m : 달 y : 년 w : 주)
			    endDate: '+10m',	//달력에서 선택 할 수 있는 가장 느린 날짜. 이후로 선택 불가 ( d : 일 m : 달 y : 년 w : 주)
			    autoclose : true,	//사용자가 날짜를 클릭하면 자동 캘린더가 닫히는 옵션
			    //clearBtn : false, //날짜 선택한 값 초기화 해주는 버튼 보여주는 옵션 기본값 false 보여주려면 true
			    disableTouchKeyboard : false,	//모바일에서 플러그인 작동 여부 기본값 false 가 작동 true가 작동 안함.
			    immediateUpdates: true,	//사용자가 보는 화면으로 바로바로 날짜를 변경할지 여부 기본값 :false 
			    multidate : false, 
			    multidateSeparator :"~",
			    templates : {
			        leftArrow: '&laquo;',
			        rightArrow: '&raquo;'
			    },
			    showWeekDays : true,
			    todayHighlight : true ,
			    toggleActive : false,
			    weekStart : 0 ,
			    language : "ko"
			});
		});
		
		function modalView(mid) {
			let str = '<div class="border portfolio-gallery">';
			$.ajax({
				url: "${ctp}/engineer/getMemberContent",
				type: "post",
				data: {mid:mid},
				success: function(mVo) {
					console.log(mVo);
					str += '<table class="table table-borderless text-center">';
					str += '<tr>';
					str += '<td colspan="2"><b>${vo.asName}</b></td>';
					str += '<th>담당자 이름</th><td>'+mVo.name+'</td>';
					str += '</tr>';
					str += '<tr class="text-center">';
					str += '<th>이메일</th>';
					str += '<td>'+mVo.email+'</td>';
					if(mVo.m_group=="재직자"){
						str += '<th>연락처</th>';
						str += '<td>'+mVo.co_tel+'</td>';
						str += '</tr>';
					}
					else {
						str += '<th>연락처</th>';
						str += '<td>'+mVo.tel+'</td>';
					}
					str += '</tr></table></div>';
					$("#content").html(str);
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
		
		function asRequestDateFixed() {
			Swal.fire({
        html : "<h3>해당 날짜로 일정을 고정하겠습니까?</h3>",
        confirmButtonText : '확인',
        showCancelButton: true,
        confirmButtonColor : '#003675',
        customClass: {
          popup : 'custom-swal-popup',
          htmlContainer : 'custom-swal-text'
        }
			}).then((result)=>{
				if(result.isConfirmed) {
					$.ajax({ // 날짜 변경, 상태를 접수완료로 변경 후
						url: "${ctp}/engineer/asRequestDateFixed",
						type: "post",
						data: {
							idx : ${vo.idx},
							asDate: '${vo.asDate}',
							progress : 'ACCEPT'
						},
						success:function(res) {
							if(res != "0") message = "진행일이 확정되었습니다.";
							else message = "진행일 설정에 실패했습니다.";
							Swal.fire({
								html: message,
								confirmButtonText: '확인',
								customClass: {
				        	confirmButton : 'swal2-confirm‎',
				          popup : 'custom-swal-popup',
				          htmlContainer : 'custom-swal-text'
								}
							});
						},
						error: function() {
							alert("상태 변경 오류");
						}
					});
					$.ajax({
						url: "${ctp}/engineer/scheduleInput",
						type: "post",
						data: {
							title: '${vo.asName}',
							engineerIdx: ${vo.engineerIdx},
							start: '${vo.asDate}',
							allDay: true,
							sw: "engineerAsRequest"
						},
						success: function(res) {
							if(res != "0") message = "해당 날짜로 일정이 설정 되었습니다.";
							else message = "일정 변경에 실패했습니다.";
							Swal.fire({
								html: message,
								confirmButtonText: '확인',
								customClass: {
				        	confirmButton : 'swal2-confirm‎',
				          popup : 'custom-swal-popup',
				          htmlContainer : 'custom-swal-text'
								}
							}).then(function(){
								$("#datepicker").prop("disabled", true);
								location.reload();
							});
						},
						error: function(){
							alert("스케줄 전송 오류");
						}
					});
				}
			});
		}
		
		function asRequestDateEdit() {
			let start = document.getElementById("datePicker").value;
			$.ajax({ // 날짜 변경, 상태를 접수완료로 변경 후
				url: "${ctp}/engineer/asRequestDateFixed",
				type: "post",
				data: {
					idx : ${vo.idx},
					asDate: start,
					progress : 'ACCEPT'
				},
				success: function(res) {},
				error: function(){
					alert("스케줄 전송 오류");
				}
			});
			$.ajax({
				url: "${ctp}/engineer/scheduleInput",
				type: "post",
				data: {
					title: '${vo.asName}',
					engineerIdx: ${vo.engineerIdx},
					start: start,
					allDay: true,
					sw: "engineerAsRequest"
				},
				success: function(res) {
					if(res != "0") message = "해당 날짜로 출장일이 변경 되었습니다.";
					else message = "일정 변경에 실패했습니다.";
					Swal.fire({
						html: message,
						confirmButtonText: '확인',
						customClass: {
		        	confirmButton : 'swal2-confirm‎',
		          popup : 'custom-swal-popup',
		          htmlContainer : 'custom-swal-text'
						}
					}).then(function(){
						$("#datepicker").prop("disabled", true);
						location.reload();
					});
				},
				error: function(){
					alert("스케줄 전송 오류");
				}
			});
		}
		
		function commentInput() {
			let comment = document.getElementById("comment").value;
			if(comment.trim()=="") {
				alert("A/S 완료 후 코멘트를 적어주세요.");
				return false;
			}
			
			$.ajax({
				url: "${ctp}/engineer/asCommentInput",
				type: "post",
				data: {
					idx: ${vo.idx},
					comment: comment
				},
				success: function(res){
					if(res != "0") message = "엔지니어 코멘트가 등록되었습니다.";
					else message = "코멘트 등록 실패";
					Swal.fire({
						html: message,
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
					alert("전송 오류");
				}
			});
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<div class="container">
<div class="row">
	<div class="col-lg-3">
		<div class="bodyLeft">
			<jsp:include page="/WEB-INF/views/include/engineer_aside.jsp" />
		</div>
	</div>
	<div class="col-lg-9">
	<section class="section blog-wrap">
		<div class="container">
			<table class="table content table-bordered text-center">
				<tr>
					<th>접수번호</th>
					<td>${vo.idx}</td>
					<th>신청자</th>
					<td><a href="#" onclick="modalView('${vo.asMid}')" data-toggle="modal" data-target="#memberInfoModal">${vo.asName}<i class="fa-solid fa-phone ml-2"></i></a></td>
				</tr>
				<tr>
					<th>진행 상황</th>
					<td>
						${vo.progress=="REGIST" ? "신청완료" : ""}
						${vo.progress=="ACCEPT" ? "접수완료" : ""}
						${vo.progress=="PROGRESS" ? "진행중" : ""}
						${vo.progress=="PAYMENT" ? "입금대기" : ""}
						${vo.progress=="COMPLETE" ? "진행완료" : ""}
						<!-- 
						<select name="changeStatement" id="changeStatement" class="custom-select" onchange="changeThisStatement(${vo.idx})">
							<option value="REGIST" ${vo.progress=="REGIST" ? "selected" : ""}>신청완료</option>
							<option value="ACCEPT" ${vo.progress=="ACCEPT" ? "selected" : ""}>접수완료</option>
							<option value="PROGRESS" ${vo.progress=="PROGRESS" ? "selected" : ""}>진행중</option>
							<option value="PAYMENT" ${vo.progress=="PAYMENT" ? "selected" : ""}>입금대기</option>
							<option value="COMPLETE" ${vo.progress=="COMPLETE" ? "selected" : ""}>진행완료</option>
						</select>
						-->
					</td>
					<th>기기명</th>
					<td>${vo.machine}</td>
				</tr>
				<c:set var="asDate" value="${fn:substring(vo.asDate,0,10)}"/>
				<c:if test="${vo.progress!='REGIST'}"> <!-- 접수 완료되어 asDate를 엔지니어가 수정하면 보이게 -->
					<tr>
						<th>출장 진행일</th>
						<td colspan="3">${asDate}</td>
					</tr>
				</c:if>
				<tr>
					<th>요청날짜</th>
					<td colspan="2">
						<input type="text" id="datePicker" name="asDate" class="form-control" value="${asDate}" style="height:my-auto;">
					</td>
					<td>
						<c:if test="${vo.progress=='REGIST'}">
							<input type="button" value="일정확인" onclick="asRequestDateFixed()" class="btn btn-main btn-icon-sm btn-round-full ml-2"/>
							<input type="button" value="수정" onclick="asRequestDateEdit()" class="btn btn-main btn-icon-sm btn-round-full ml-1"/>
						</c:if>
					</td>
				</tr>
				<tr>
					<th>증상</th>
					<td colspan="3"><c:if test="${empty vo.detailNote}">-</c:if><c:if test="${!empty vo.detailNote}">${vo.detailNote}</c:if></td>
				</tr>
				<tr>
					<th>A/S 코멘트</th>
					<td colspan="3">
						<c:if test="${empty vo.comment}">
							<textarea rows="4" name="comment" id="comment" class="form-control"></textarea>
						</c:if>
						<c:if test="${!empty vo.comment}">${fn:replace(vo.comment,newLine,'<br/>')}</c:if>
					</td>
				</tr>
				<tr><td colspan="4" class="m-0 p-0"></td></tr>
			</table>
			<div class="text-right mt-2">
				<a href="javascript:commentInput()" class="btn btn-main btn-icon-md btn-round">코멘트 작성</a>
				<a href="${ctp}/engineer/asRequestList?pag=${pag}&pageSize=${pageSize}" class="btn btn-main btn-icon-md btn-round">목록으로</a>
			</div>
		</div>
	</section>
	</div>
</div>
</div>
<!-- 멤버 정보 모달에 출력하기 -->
<div class="modal fade" id="memberInfoModal">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
    
      <!-- Modal Header -->
      <div class="modal-header text-center">
        <h4 class="modal-title">신청인 상세정보</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
    		<span id="content"></span>
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-main-3" data-dismiss="modal">Close</button>
      </div>
      
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.js"></script>
<script src="${ctp}/js/bootstrap-datepicker.ko.js"></script>
</body>
</html>