<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>내 정보 관리</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <style>
  	.title {
  		font-size: 1.6rem;
  		font-family: "Do Hyeon";
  		font-weight: 700;
  		color: black;
  	}
  	.col {
  		text-align: center;
  		font-size: 1.2rem;
  		margin-bottom: 0.5rem;
  		margin-top: 0.5rem;
  	}
    li {
      list-style: none;
    }
    #currentMessage {
    	width: 100%;
      height: 420px;
      float: left;
      border: 1px solid #ccc;
      padding-left: 10px;
      background-color: #F8F8F8;
      overflow: auto;
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
		  let enter=0;
		  $("#endChatBtn").show();
		  const username = document.getElementById('username').value;
		  if (username) {
		    //socket = new WebSocket('ws://192.168.50.58:9090/javaclassS9/webSocket/realTimeChat/' + username);
		    socket = new WebSocket('ws://49.142.157.251:9090/javaclassS9/webSocket/realTimeChat/' + username);
		    //socket = new WebSocket('ws://localhost:9090/javaclassS9/webSocket/realTimeChat/' + username);
		
		    // 상대방 유저가 들어오거나 메세지를 날릴때 처리되는 곳
		    socket.onmessage = (event) => {
	        let dt = new Date();
          let strToday = dt.getFullYear()+"-"+dt.getMonth()+"-"+dt.getDate()+" "+dt.getHours()+":"+dt.getMinutes();
          let item="";
		    	// 새로 접속한 유저인경우는 'USER_LIST:'문자열을 시작으로 들어온다.
		    	//if(event.data.startsWith("USER_LIST:") && enter==0) {
		    		if(!event.data.includes("admin") && enter==0) { // 관리자가 없을 경우 대기 요청 메세지 전송
		          $.ajax({
		        	  url: "${ctp}/member/addChatAlarm",
		        	  type: "post",
		        	  success: function(res) {
		        		  if(res!=0)console.log("알림전송");
		        		  else alert("다시 접속해주세요.");
		        	  },
		        	  error: function(){
		        		  alert("전송오류");
		        	  }
		          });
		          item += '<div class="d-flex flex-row mr-2"><span class="youWord p-2 m-1" style="font-size:11px">'+strToday+'<br/>';
		          item += '<font color="#8E8E8E"> 관리자로부터</font><br/>';
		          item += '<font size="3">관리자에게 대화를 요청했습니다. 잠시만 기다려주세요.</font></span></div>';
		          enter = 1;
		    		}
		      //}
		    	else if(!event.data.startsWith("USER_LIST:")) {
	          item += '<div class="d-flex flex-row mr-2"><span class="youWord p-2 m-1" style="font-size:11px">'+strToday+'<br/>';
	          item += '<font color="#8E8E8E">' + event.data.split(":")[0] + ' 로 부터</font><br/><font size="3">' + event.data.split(":")[1] + '</font></span></div>';
		    	}
          document.getElementById('messages').innerHTML += item;
          document.getElementById('message').value = '';
          document.getElementById('message').focus();
          $('#currentMessage').scrollTop($('#currentMessage')[0].scrollHeight);	// 스크롤바를 div마지막에 위치..
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
	
	  // 폼이 모두 로드되고 나면 아래 루틴을 처리해서 채팅접속자의 아이디를 화면에 출력할수 있게처리한다.
	  // 메세지 보내는 사용자의 메세지 출력폼
	
	  document.addEventListener('DOMContentLoaded', () => {
	  const form = document.getElementById('form');
	  form.addEventListener('submit', (e) => {	// 전송버튼을 누르면 메세지를 화면에 출력시켜준다.
	    e.preventDefault();		// 이전 스크립트 내용은 무시하고 아래의 내용을 처리하게 한다.
	    const target = "admin";
	    const message = document.getElementById('message').value;
	    if (target && message) {
	      socket.send(target + ":" + message);
	      let dt = new Date();
	      let strToday = dt.getFullYear()+"-"+dt.getMonth()+"-"+dt.getDate()+" "+dt.getHours()+":"+dt.getMinutes();
	      let item = '<div class="chattingBox d-flex flex-row-reverse mr-2"><span class="myWord p-2 m-1" style="font-size:11px">'+strToday+'<br/>';
	      item += '<font color="#8E8E8E">' + target + ' 에게</font><br/><font size="3">' + message + '</font></span></div>';
	      document.getElementById('messages').innerHTML += item;
	      document.getElementById('message').value = '';
	      document.getElementById('message').focus();
	      $('#currentMessage').scrollTop($('#currentMessage')[0].scrollHeight);	// 스크롤바를 div마지막에 위치..
	    }
	  });
	  });
	
	  
	  // 메세지 보내기(여러줄 처리하도록 함)
	  $(function(){
		  $('#message').keyup(function(e) {
			  e.preventDefault();		// 이전 스크립트 내용은 무시하고 아래의 내용을 처리하게 한다.
		    const target = "admin";
		    const message = document.getElementById('message').value;
		  	if (e.keyCode == 13) {
		  		if(!e.shiftKey) {
		  			if(target != '' && $('#message').val().trim() != '') {
				  		let dt = new Date();
		          let strToday = dt.getFullYear()+"-"+dt.getMonth()+"-"+dt.getDate()+" "+dt.getHours()+":"+dt.getMinutes();
		          let item = '<div class="chattingBox d-flex flex-row-reverse mr-2"><span class="myWord p-2 m-1" style="font-size:11px">'+strToday+'<br/>';
		          item += '<font color="#8E8E8E">' + target + ' 에게</font><br/><font size="3">' + message + '</font></span></div>';
		          item = item.replaceAll("\n","<br/>");
		          document.getElementById('messages').innerHTML += item;
		          document.getElementById('message').value = '';
		          document.getElementById('message').focus();
				  		$('#currentMessage').scrollTop($('#currentMessage').prop('scrollHeight'));	// 스크롤바를 div마지막에 위치..
				  		socket.send(target + ":" + message.replaceAll("\n","<br/>"));
			  		}
		  		}
		  	}
		  });
	  });
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<p><br/></p>
<div class="container">
	<div class="row">
		<div class="col-lg-3">
			<div class="bodyLeft">
				<jsp:include page="/WEB-INF/views/include/aside.jsp" />
			</div>
		</div>
		<div class="col-lg-9">
			<div class="bodyRight" style="width:70%; margin-left:100px;">
			<p><br/></p>
				<div class="row mb-3">
					<div class="col text-right">
						<h3>1:1 문의</h3>
						<span id="currentId"></span>
						<div>창을 새로고침할 경우 상담내역이 초기화 됩니다.</div>
					</div>
				</div>
				<!-- 채팅창 -->
				<p><br/></p>
			  <div class="input-group">
				  <input type="text" id="username" value="${sMid}" class="form-control" readonly />
				  <button onclick="startChat()" class="btn btn-main-2 btn-icon-md input-group-append">채팅시작</button>
			  </div>
			  <button onclick="endChat()" id="endChatBtn" class="btn btn-main-3 btn-icon-md text-right" style="display:none;">채팅종료</button> <!-- 채팅 종료 버튼 -->
			  <hr/>
			  <div id="chat" style="display:none;" class="align-items-center">
			    <form name="myform" id="form">
				    <div id="currentMessage">
				    	<h5>메세지 출력창</h5>
				    	<div id="messages"></div>
				    </div>
			      <div class="messageBox input-group">
				      <textarea name="message" id="message" placeholder="메세지를 입력하세요." class="form-control"></textarea>	<!-- autocomplete="off" 브라우저의 자동완성기능을 허용하지 않음 -->
				      <button class="input-group-append btn btn-main">메세지전송</button>
			      </div>
			    </form>
			  </div>
			  
			</div>
		</div>
	</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>