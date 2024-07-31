<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 메인</title>
	<style>
	  .bodyLeft {
	    float: left;
	    width: 25%;
	  }
	  .bodyMiddle {
	    float: left;
	    width: 75%;
	  }
	</style>
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<!-- fullcalendar CDN -->
	<link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.css' rel='stylesheet' />
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.js'></script>
	<!-- fullcalendar 언어 CDN -->
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/locales-all.min.js'></script>
	<script>
		'use strict';
	   /* full calender */
    (function(){
       $(function(){
         var calendarEl = $('#calendar')[0];
         // full-calendar 생성하기
         var calendar = new FullCalendar.Calendar(calendarEl, {
           height: '700px', // calendar 높이 설정
           expandRows: true, // 화면에 맞게 높이 재설정
           slotMinTime: '00:00', // Day 캘린더에서 시작 시간
           slotMaxTime: '24:00', // Day 캘린더에서 종료 시간
           headerToolbar: {
             left: 'prev,next today',
             center: 'title',
             right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
           },
           initialView: 'dayGridMonth', // 초기 로드 될때 보이는 캘린더 화면(기본 설정: 달)
           // 초기 날짜 설정 (설정하지 않으면 오늘 날짜가 보인다.)
           navLinks: true, // 날짜를 선택하면 Day 캘린더나 Week 캘린더로 링크
           editable: false, // 수정 가능?
           selectable: true, // 달력 일자 드래그 설정가능
           nowIndicator: true, // 현재 시간 마크
           dayMaxEvents: true, // 이벤트가 오버되면 높이 제한 (+ 몇 개식으로 표현)
           locale: 'ko', // 한국어 설정
           select: function(arg) { // 캘린더에서 드래그로 이벤트를 생성할 수 있다.
             var title = prompt('일정을 부여할 이름-일정제목(예: 관리자-교육) 으로 입력하세요:');
             if (title) {
               calendar.addEvent({
                 title: title,
                 start: arg.start,
                 end: arg.end,
                 allDay: arg.allDay
               });
               
               $.ajax({
                   type: "POST",
                   url: "${ctp}/admin/schedule/scheduleInput", // 서버 측 스크립트의 URL
                   data: {
                     title: title,
                     start: arg.start.toISOString(),  
                     end: arg.end.toISOString(),      
                     allDay: arg.allDay
                   },
                   success: function(res) {
                     if (res != "0" ){
                         alert("일정이 저장되었습니다");
                         location.reload();
                    } else  {
                        alert("일정 저장 실패");
                    }
                   },
                   error: function() {
                     alert("연결오류~");
                   }
               });
             }
             calendar.unselect();
           },
           // 이벤트 
           events: function(fetchInfo, successCallback, failureCallback) {
              $.ajax({
                url: "${ctp}/admin/schedule/scheduleListAll",
                type: "POST",
                dataType: "json",
                success: function(data) {
                  var events = data.map(function(vo) {
                    return {
                      id: vo.idx, // 이벤트의 고유 ID
                      title: vo.engineerName+"-"+vo.title,
                      start: vo.startTime,
                      end: vo.endTime,
                      allDay: vo.allDay
                    };
                  });
                  successCallback(events);
                },
                error: function() {
                  failureCallback("연결 오류~");
                }
              });
           }
         });
         calendar.render();
       });
     })();
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<div class="container">
  <h4 class="my-4">Dashboard</h4>
  <div class="row">
    <div class="col-lg-3">
      <div class="card monthly">
      	<a href="${ctp}/admin/engineer/asRequestList">
	        <div class="card-body d-flex justify-content-between">
	          <div>
	            <p class="card-text mb-2">입금 확인 요청</p>
	            <h4>${newPaymentCount} 건</h4>
	          </div>
	          <i class="fas fa-calendar" style="font-size: 30px; margin-top: 20px; color: #6c757d"></i>
	        </div>
        </a>
      </div>
    </div>
    <div class="col-lg-3">
      <div class="card annual">
	      <a href="${ctp}/admin/member/memberList">
	        <div class="card-body d-flex justify-content-between">
	          <div>
	            <p class="card-text mb-2">최근 가입 회원</p>
	            <h4>${joinCount} 명</h4>
	          </div>
	          <i class="fa-solid fa-user-plus" style="font-size: 30px; margin-top: 20px; color: #6c757d"></i>
	        </div>
	       </a>
      </div>
    </div>
    <div class="col-lg-3">
      <div class="card tasks">
      	<a href="${ctp}/admin/product/productEstimate">
	        <div class="card-body d-flex justify-content-between">
	          <div>
	            <p class="card-text mb-2">새로운 견적 요청</p>
	            <h4>${estimateCount} 건</h4>
	          </div>
	          <i class="fa-solid fa-list-check" style="font-size: 30px; margin-top: 20px; color: #6c757d"></i>
	        </div>
        </a>
      </div>
    </div>
    <div class="col-lg-3">
      <div class="card requests">
      	<a href="${ctp}/admin/consulting/consultingList">
	        <div class="card-body d-flex justify-content-between">
	          <div>
	          <p class="card-text mb-2">새로운 문의 내용</p>
	          <h4>${consultingCount} 건</h4>
	          </div>
	          <i class="fa-solid fa-comments" style="font-size: 30px; margin-top: 20px; color: #6c757d"></i>
	        </div>
        </a>
      </div>
    </div>
  </div>
  <hr/>
    <!-- full calendar -->
    <div class="row">
    	<div class="col text-center">
    		<h3>전체 엔지니어 일정 확인</h3>
    		<div style="font-size:13px;">일정 추가만 가능하며 상세한 일정 수정 및 삭제는 일정 관리 탭에서 진행됩니다.
    		<a href="${ctp}/admin/engineer/schedule" class="btn btn-main btn-icon-sm ml-2">일정관리탭으로 이동<i class="fa-solid fa-location-arrow ml-2"></i></a></div>
    		<div class="divider2 mx-auto my-4"></div>
    		<div id='calendar-container'>
					<div id='calendar'></div>
				</div>
    	</div>
    </div>
    <hr/>
    
  </div>
<p><br/></p>
</body>
</html>