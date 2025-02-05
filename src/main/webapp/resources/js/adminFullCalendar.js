	   /* full calender */
    (function(){
       $(function(){
         // calendar element 취득
         var calendarEl = $('#calendar')[0];
         // full-calendar 생성하기
         var calendar = new FullCalendar.Calendar(calendarEl, {
           height: '600px', // calendar 높이 설정
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
           editable: true, // 수정 가능?
           selectable: true, // 달력 일자 드래그 설정가능
           nowIndicator: true, // 현재 시간 마크
           dayMaxEvents: true, // 이벤트가 오버되면 높이 제한 (+ 몇 개식으로 표현)
           locale: 'ko', // 한국어 설정
           eventAdd: function(obj) { // 이벤트가 추가되면 발생하는 이벤트  
               //console.log(obj);
           },
           eventChange: function(info) { // 이벤트가 수정되면 발생하는 이벤트
              var idx = info.event.extendedProps.idx; 
              var title = info.event.title;
              var start = info.event.start;
              var end = info.event.end;
              var allDay = info.event.allDay;
              // 서버로 수정된 일정 정보를 전송
              $.ajax({
                type: "POST",
                url: "${ctp}/admin/schedule/scheduleUpdate", // 서버 측 스크립트의 URL
                data: {
                  idx : idx,
                  title: title,
                  start: start,
                  end: end,
                  allDay: allDay
                },
                success: function(res) {
                  if (res != "0") {
                      alert("일정이 수정되었습니다.");
                      location.reload();
                  } else {
                      alert("일정 수정 실패");
                  }
                },
                error: function() {
                  alert("연결오류~");
                }
              });
           },
           eventRemove: function(obj){ // 이벤트가 삭제되면 발생하는 이벤트
             //console.log(obj);
           },
           select: function(arg) { // 캘린더에서 드래그로 이벤트를 생성할 수 있다.
             var title = prompt('일정을 부여할 이름(예:관리자)-일정제목 으로 입력하세요:');
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
            },
           eventClick: function(info) {
        	   let ans = confirm("정말로 이 일정을 삭제하시겠습니까?");
             if(ans) {
               info.event.remove(); // 이벤트 삭제
               
   						 // 이벤트 속성 값 가져오기
               var title = info.event.title;
               // 한국 표준시(KST)로 변환
               var options = { timeZone: 'Asia/Seoul', year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', second: '2-digit' };
               var start = new Date(info.event.start).toLocaleString('ko-KR', options).replace(/\. /g, '-').replace('.', '');
               var end = info.event.end ? new Date(info.event.end).toLocaleString('ko-KR', options).replace(/\. /g, '-').replace('.', '') : null;
               var allDay = info.event.allDay;
               
               $.ajax({
                   type: "POST",
                   url: "${ctp}/admin/schedule/scheduleDelete", // 서버 측 스크립트의 URL
                   data: {
                     title: title,
                     start: start,
                     end: end,
                     allDay: allDay
                   },
                   success: function(res) {
                     if (res != "0" ){
                         alert("일정이 삭제되었습니다.");
                           location.reload();
                     } else  {
                        alert("일정 삭제 실패");
                     }
                   },
                   error: function() {
                     alert("연결오류~");
                 	 }
               });
               
             }
           }

         });
         // 캘린더 랜더링
         calendar.render();
       });
     })();