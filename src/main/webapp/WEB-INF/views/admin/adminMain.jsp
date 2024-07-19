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
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	<script>
		'use strict';
	   /* full calender */
    (function(){
       $(function(){
         // calendar element 취득
         var calendarEl = $('#calendar')[0];
         // full-calendar 생성하기
         var calendar = new FullCalendar.Calendar(calendarEl, {
           height: '700px', // calendar 높이 설정
           expandRows: true, // 화면에 맞게 높이 재설정
           slotMinTime: '00:00', // Day 캘린더에서 시작 시간
           slotMaxTime: '24:00', // Day 캘린더에서 종료 시간
           // 해더에 표시할 툴바
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
                  data.forEach(function(vo) {
                    calendar.addEvent({
                      idx: vo.idx, // 이벤트의 고유 ID
                      title: vo.engineerName+"-"+vo.title,
                      start: vo.startTime,
                      end: vo.endTime,
                      allDay: vo.allDay
                    });
                  });
                  successCallback([]);
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
	   
	  // 가입자 / 탈퇴자 수 차트
	  google.charts.load('current', {'packages':['line']});
    google.charts.setOnLoadCallback(drawChart);

	  function drawChart() {
	
	    var data = new google.visualization.DataTable();
	    data.addColumn('number', 'Day');
	    data.addColumn('number', 'Guardians of the Galaxy');
	    data.addColumn('number', 'The Avengers');
	    data.addColumn('number', 'Transformers: Age of Extinction');
	
	    data.addRows([
	      [1,  37.8, 80.8, 41.8],
	      [2,  30.9, 69.5, 32.4],
	      [3,  25.4,   57, 25.7],
	      [4,  11.7, 18.8, 10.5],
	      [5,  11.9, 17.6, 10.4],
	      [6,   8.8, 13.6,  7.7],
	      [7,   7.6, 12.3,  9.6],
	      [8,  12.3, 29.2, 10.6],
	      [9,  16.9, 42.9, 14.8],
	      [10, 12.8, 30.9, 11.6],
	      [11,  5.3,  7.9,  4.7],
	      [12,  6.6,  8.4,  5.2],
	      [13,  4.8,  6.3,  3.6],
	      [14,  4.2,  6.2,  3.4]
	    ]);
	
	    var options = {
	      chart: {
	        title: 'Box Office Earnings in First Two Weeks of Opening',
	        subtitle: 'in millions of dollars (USD)'
	      },
	      width: 900,
	      height: 500,
	      axes: {
	        x: {
	          0: {side: 'bottom'}
	        }
	      }
	    };
	
	    var chart = new google.charts.Line(document.getElementById('line_top_x'));
	    chart.draw(data, google.charts.Line.convertOptions(options));
	  }
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<div class="container">
  <h4 class="my-4">Dashboard</h4>
  <div class="row">
    <div class="col-lg-3">
      <div class="card monthly">
        <div class="card-body d-flex justify-content-between">
          <div>
            <p class="card-text mb-2">Earnings (Monthly)</p>
            <h4>$400,000</h4>
          </div>
          <i
            class="fas fa-calendar"
            style="font-size: 30px; margin-top: 20px; color: #6c757d"
          ></i>
        </div>
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
        <div class="card-body d-flex justify-content-between">
          <div>
            <p class="card-text mb-2">새로운 문의 내용</p>
            <h4>26</h4>
            </div>
            <i
              class="fa-solid fa-comments"
              style="font-size: 30px; margin-top: 20px; color: #6c757d"
            ></i>
          </div>
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
    <!-- 그래프 요약 추가하기 -->
    <div class="row">
    	<div class="col">
		    <div id="line_top_x"></div>
    	</div>
    </div>
    
  </div>
<p><br/></p>
</body>
</html>