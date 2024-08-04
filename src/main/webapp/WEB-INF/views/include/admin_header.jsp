<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<style>
	.nav-container {
	 background-color: white;
	 width: 100%;
	 height: 60px;
	 box-shadow: 0px 2px 2px 2px #eee;
	 display: flex;
	 justify-content: space-between;
	}
	
	.search-box {
	 display: inline-flex;
	 align-items: center;
	 margin-left: 100px;
	}
	
	.search-box-input {
	 padding: 5px;
	 border-radius: 5px 0px 0px 5px;
	 border: 1px solid lightgrey;
	 width: 150px;
	 transition: width 1s;
	}
	
	.search-box-input:focus {
	 width:300px;
	}
	
	.search-box-btn {
	 background-color: #343940;
	 color: white;
	 border: none;
	 border-radius: 0px 5px 5px 0px;
	 height: 36px;
	 width: 40px;
	}
	
	.notification {
	 display: flex;
	 margin-right: 20px;
	 align-items: center;
	}
	
	.notification-icon {
	 font-size: x-large;
	 margin-left: 60px;
	 color: #808080;
	 margin-bottom: 20px;
	}
	
	.notification-badge {
	 position: relative;
	 left: 15px;
	 top: 16px;
	 background-color: #DC3545;
	 width: 20px;
	 height: 20px;
	 border-radius: 5px;
	 display: flex;
	 justify-content: center;
	 align-items: center;
	 color: white;
	 font-size: small;
	 font-weight: 600;
	}
	
	#notification-name {
	 margin-left: 40px;
	 color: grey;
	}
	
	.menu {
	  display: none; /* 초기에는 메뉴를 숨김 */
	  position: absolute;
	  background-color: white;
	  box-shadow: 0 2px 5px rgba(0,0,0,0.2);
	  z-index: 1000;
	  font-size: medium;
	}
	
	.menu li {
	  list-style-type: none;
	  padding: 8px;
	}
	
	.menu li a {
	  text-decoration: none;
	  color: #333;
	}
	
</style>
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script>
	'use strict'
	$(function(){
	  // 메뉴를 토글하는 함수
	  $('#menuToggle').click(function(e) {
	    e.preventDefault(); // 기본 이벤트 방지
	    $('#messageList').toggle(); // 메뉴 토글
	    $('#alarmList').hide();
	  });
	  $('#alarmToggle').click(function(e) {
	    e.preventDefault();
	    $('#alarmList').toggle();
	    $('#messageList').hide();
	  });

	  // 다른 곳을 클릭했을 때 메뉴를 숨기는 처리
	  $(document).click(function(e) {
	    if (!$(e.target).closest('.notification-icon').length) {
	      // 클릭된 요소가 notification-icon 내부가 아니라면
	      $('#messageList').hide(); // 메뉴 숨기기
	      $('#alarmList').hide();
	    }
	  });
	  // notificationMenu 클릭 시 상위 이벤트 전파 방지
	  $('#messageList').click(function(e) {
	    e.stopPropagation();
	  });
	  $('#alarmList').click(function(e) {
	    e.stopPropagation(); // 이벤트 전파 방지
	  });
	  
		if('${sMid}'){
			let total = 0;
			$.ajax({
				url: "${ctp}/admin/adminHeaderAlarm",
				type: "post",
				success: function(res) {
					let tot = res[0]+res[1]+res[2]+res[3];
					$("#mNew").text(res[0]);
					$("#eNew").text(res[1]);
					$("#pNew").text(res[2]);
					$("#cNew").text(res[3]);
					$("#alarmIcon").text(tot);
				},
				error: function() {
					alert("헤더 알림 전송 오류");
				}
			});
			$.ajax({
				url: "${ctp}/admin/adminMessage",
				type: "post",
				success: function(res) {
					$("#newMessage").text(res);
					total += res;
					$("#messageIcon").text(total);
				},
				error: function() {
					alert("메세지 알림 전송 오류");
				}
			});
			$.ajax({
				url: "${ctp}/admin/adminNewChat",
				type: "post",
				success: function(res) {
					$("#newChat").text(res);
					total += res;
					$("#messageIcon").text(total);
				},
				error: function() {
					alert("채팅 알림 전송 오류");
				}
			});
		}
		else {
			location.href="${ctp}/";
		}
		
	});
	
	function chatAlarmCheck() {
		$.ajax({
			url: "${ctp}/admin/chatAlarmCheck",
			type: "post",
			success: function(res) {
				if(res != 0) {
					location.href="${ctp}/admin/consulting/realTimeChat";
				}
				else {
					alert("알림 확인을 다시 시도해주세요.");
					location.reload();
				}
			},
			error: function(){
				alert("전송오류");
			}
		});
	}
</script>
<nav class="nav-container">

  <div class="search-box">
  	<!-- 
	  <input type="text" class="search-box-input" placeholder="Search" />
	  <button class="search-box-btn">
	    <i class="fa-solid fa-magnifying-glass"></i>
	  </button>
	  -->
  </div>

  <div class="notification">
    <div class="notification-icon">
	    <a href="#" id="alarmToggle">
	      <span class="notification-badge" id="alarmIcon"></span>
	      <i class="fa-solid fa-bell"></i>
      </a>
      <ul class="menu" id="alarmList">
      	<li>
      		<a href="${ctp}/admin/member/memberList">회원 인증 : 총 <span id="mNew" style="color:#E71825;font-weight:bold;"></span> 건</a>
      	</li>
      	<li><a href="${ctp}/admin/product/productEstimate">견적 요청 : 총 <span id="eNew" style="color:#E71825;font-weight:bold;"></span> 건</a></li>
      	<li><a href="${ctp}/admin/engineer/asRequestList">입금 확인 : 총 <span id="pNew" style="color:#E71825;font-weight:bold;"></span> 건</a></li>
      	<li><a href="${ctp}/admin/consulting/consultingList">새로운 문의 : 총 <span id="cNew" style="color:#E71825;font-weight:bold;"></span> 건</a></li>
      </ul>
    </div>
    <div class="notification-icon">
    	<a href="#" id="menuToggle">
	      <span class="notification-badge" id="messageIcon"></span>
	      <i class="fa-solid fa-envelope"></i>
      </a>
      <ul class="menu" id="messageList">
      	<li>
      		<a href="${ctp}/admin/setting/messageList">총 <span id="newMessage" style="color:#E71825;font-weight:bold;"></span> 건의 메세지가 있습니다.</a>
      	</li>
      	<li><a href="javascript:chatAlarmCheck()">총 <span id="newChat" style="color:#E71825;font-weight:bold;"></span> 건의 1:1 요청이 있습니다.</a></li>
      </ul>
    </div>
    <span id="notification-name"><a href="${ctp}/admin/setting/changeAdminPwd">관리자</a></span>
    <span id="notification-name"><a href="${ctp}/"><i class="fa-solid fa-door-open"></i>나가기</a></span>
  </div>
</nav>