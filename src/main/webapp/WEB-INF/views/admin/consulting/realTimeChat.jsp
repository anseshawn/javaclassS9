<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>1:1 문의</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
  <style>
    li {
      list-style: none;
    }
    
    #currentUser {
      width: 30%;
      height: 430px;
      float: left;
      border: 0px solid #ccc;
      padding: 10px;
    }
    #currentMessage {
      width: 70%;
      height: 420px;
      float: left;
      border: 1px solid #ccc;
      padding-left: 10px;
      background-color: #F8F8F8;
      overflow: auto;
    }
    #targetUser {
    	width: 28%;
    	margin: 10px 0px 10px 10px;
    	text-align: center;
    	border: 1px solid #C7C3BB;
    }
    .messageBox {
      clear: both;
      padding-top: 10px;
    }
    .myWord {
      background-color: #CDD7E4;
    }
    .youWord {
      background-color: #E4E4E4;
    }
  </style>
  <script>
	  let socket;
		
	  function startChat() {
		  $("#endChatBtn").show();
		  const username = document.getElementById('username').value;
		  if (username) {
		    //socket = new WebSocket('ws://192.168.50.58:9090/javaclassS9/webSocket/realTimeChat/' + username);
		    //socket = new WebSocket('ws://49.142.157.251:9090/javaclassS9/webSocket/realTimeChat/' + username);
		    socket = new WebSocket('ws://localhost:9090/javaclassS9/webSocket/realTimeChat/' + username);
		
		    // 상대방 유저가 들어오거나 메세지를 날릴때 처리되는 곳
		    socket.onmessage = (event) => {
		    	// 새로 접속한 유저인경우는 'USER_LIST:'문자열을 시작으로 들어온다.
		    	if (event.data.startsWith("USER_LIST:")) {
		        updateUserList(event.data.substring(10));	// USER_LIST이후부터 유저들이 배열(,)로 들어온다.
		      } // 현재 누가 접속했는지 알 수 있는 부분(10바이트 이후부터 들어오는 자료)
		    	else {
		          let dt = new Date();
		          let strToday = dt.getFullYear()+"-"+dt.getMonth()+"-"+dt.getDate()+" "+dt.getHours()+":"+dt.getMinutes();
		          let item = '<div class="d-flex flex-row mr-2"><span class="youWord p-2 m-1" style="font-size:11px">'+strToday+'<br/>';
		          item += '<font color="#8E8E8E">' + event.data.split(":")[0] + ' 로 부터</font><br/><font size="3">' + event.data.split(":")[1] + '</font></span></div>';
		          document.getElementById('messages').innerHTML += item;
		          document.getElementById('messageInput').value = '';
		          document.getElementById('messageInput').focus();
		          $('#currentMessage').scrollTop($('#currentMessage')[0].scrollHeight);	// 스크롤바를 div마지막에 위치..
		    	}
		    };
		    
		    // 웹소켓 접속을 종료할때 처리되는 코드
		    socket.onclose = () => {
		      alert('채팅창에서 접속을 종료합니다.');
		      document.getElementById('chat').style.display = 'none';
		      document.getElementById('username').style.display = 'block';
		      document.querySelector('button[onclick="startChat()"]').style.display = 'block';
		    };
		
		    // 소켓 접속후 기본 아이디를 화면에 출력시켜주고 있다.(접속 종료후도 계속 유지된다.)
		    document.getElementById('chat').style.display = 'block';
		    document.getElementById('username').style.display = 'none';
		    document.querySelector('button[onclick="startChat()"]').style.display = 'none';
		    document.getElementById('currentId').innerHTML = '<font color="#003675"><b>${sMid}</b></font>';
		  }
	  }
	  
	  // 채팅 종료버튼을 클릭하면 소켓을 닫도록 처리한다.
	  function endChat() {
		  location.reload();	// 다시 reload하므로서 새롭게 세션이 생성되기에 기존 세션이 사라져서 접속사용자 아이디도 리스트상에서 제거되게 된다.
		  /* //소켓을 완전히 종료시키려면 아래코드를 추가해도 된다.
		    if (socket) {
		    socket.close();
		    $("#endChatBtn").hide();
		    }
		  */
		}
	  
	  // 사용자가 새롭게 추가되거나 접속종료시에 회원목록을 업데이트 한다.
	  function updateUserList(userList) {
	    const users = userList.split(",");
	    const usersElement = document.getElementById('users');
	    usersElement.innerHTML = '';  // Clear current list
	    users.forEach(user => {
		    const item = document.createElement('option');
		    item.textContent = user;
		    usersElement.appendChild(item);
	    });
		}
	
	  // 폼이 모두 로드되고 나면 아래 루틴을 처리해서 채팅접속자의 아이디를 화면에 출력할수 있게처리한다.
	  // 메세지 보내는 사용자의 메세지 출력폼
	  document.addEventListener('DOMContentLoaded', () => {
		  const form = document.getElementById('form');
		  form.addEventListener('submit', (e) => {	// 전송버튼을 누르면 메세지를 화면에 출력시켜준다.
		    e.preventDefault();		// 이전 스크립트 내용은 무시하고 아래의 내용을 처리하게 한다.
		    const target = document.getElementById('targetUser').value;
		    const messageInput = document.getElementById('messageInput').value;
		    if (target && messageInput) {
		      socket.send(target + ":" + messageInput);
		      let dt = new Date();
		      let strToday = dt.getFullYear()+"-"+dt.getMonth()+"-"+dt.getDate()+" "+dt.getHours()+":"+dt.getMinutes();
		      let item = '<div class="chattingBox d-flex flex-row-reverse mr-2"><span class="myWord p-2 m-1" style="font-size:11px">'+strToday+'<br/>';
		      item += '<font color="#8E8E8E">' + target + ' 에게</font><br/><font size="3">' + messageInput + '</font></span></div>';
		      document.getElementById('messages').innerHTML += item;
		      document.getElementById('messageInput').value = '';
		      document.getElementById('messageInput').focus();
		      $('#currentMessage').scrollTop($('#currentMessage')[0].scrollHeight);	// 스크롤바를 div마지막에 위치..
		    }
		  });
	  });
	  
	  // 메세지 보내기(여러줄 처리하도록 함)
	  $(function(){
		  $('#messageInput').keyup(function(e) {
				e.preventDefault();		// 이전 스크립트 내용은 무시하고 아래의 내용을 처리하게 한다.
		    const target = document.getElementById('targetUser').value;
	   		const messageInput = document.getElementById('messageInput').value;
		  	if (e.keyCode == 13) {
		  		if(!e.shiftKey) {
			  		if(target != '' && $('#messageInput').val().trim() != '') {
				  		let dt = new Date();
		          let strToday = dt.getFullYear()+"-"+dt.getMonth()+"-"+dt.getDate()+" "+dt.getHours()+":"+dt.getMinutes();
		          let item = '<div class="chattingBox d-flex flex-row-reverse mr-2"><span class="myWord p-2 m-1" style="font-size:11px">'+strToday+'<br/>';
		          item += '<font color="#8E8E8E">' + target + ' 에게</font><br/><font size="3">' + messageInput + '</font></span></div>';
		          item = item.replaceAll("\n","<br/>");
		          document.getElementById('messages').innerHTML += item;
		          document.getElementById('messageInput').value = '';
		          document.getElementById('messageInput').focus();
				  		$('#currentMessage').scrollTop($('#currentMessage').prop('scrollHeight'));	// 스크롤바를 div마지막에 위치..
				  		socket.send(target + ":" + messageInput.replaceAll("\n","<br/>"));
			  		}
		  		}
		  	}
		  });
	  });
	  
	  function userChange() {
		  myform.targetUser.value = $("#users").val();
		  myform.messageInput.focus();
	  }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
	<div class="row">
  	<label for="username">접속중인 사용자 : <span id="currentId"></span></label>
  	<input type="text" id="username" value="${sMid}" class="form-control ml-2" readonly style="width:20%"/>
	  <button onclick="startChat()" class="btn btn-main-2 btn-icon-md ml-3">채팅시작</button>
	  <button onclick="endChat()" id="endChatBtn" class="btn btn-main-3 btn-icon-md ml-3" style="display:none;">채팅종료</button> <!-- 채팅 종료 버튼 -->
  </div>
  <hr/>
  <div id="chat" style="display:none;" class="align-items-center">
    <form name="myform" id="form">
	  	<div id="currentUser">
		    <h5>현재 접속중인 회원</h5>
		    <select name="users" id="users" size="18" class="form-control" onchange="userChange()"></select>
	    </div>
	    <div id="currentMessage">
	    	<h5>메세지 출력창</h5>
	    	<div id="messages"></div>
	    </div>
      <!-- <input id="target" autocomplete="off" placeholder="받는회원 아이디" /> -->
      <!-- <select name="target" id="target" onchange="targetUserChange()"></select> -->
      <div class="messageBox input-group">
	      <input type="text" name="targetUser" id="targetUser" autocomplete="off" placeholder="접속회원을 선택하세요" readonly class="input-group-prepend mr-1"/>
	      <!-- <input type="text" name="message" id="message" autocomplete="off" placeholder="메세지를 입력하세요." class="form-control" /> -->	<!-- autocomplete="off" 브라우저의 자동완성기능을 허용하지 않음 -->
	      <textarea name="messageInput" id="messageInput" placeholder="메세지를 입력하세요." class="form-control"></textarea>	<!-- autocomplete="off" 브라우저의 자동완성기능을 허용하지 않음 -->
	      <button class="input-group-append btn btn-main">메세지전송</button>
      </div>
    </form>
  </div>
</div>
<p><br/></p>
</body>
</html>