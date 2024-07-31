<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>유저 채팅방</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
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
  	#list {
			height: 390px;
			padding: 15px;
			overflow: auto;
		}
  </style>
  <script>
	  $(document).ready(function(){
		  
			//채팅 서버 주소
		  //let url = "ws://192.168.50.58:9090/javaclassS/chatserver";
		  let url = "ws://localhost:9090/${ctp}/chatserver";
		     		
		  // 웹 소켓
		  let ws;
		  // 연결버튼을 클릭하면 수행
		  $('#btnConnect').click(function() {
		  	
	     	if ($('#user').val().trim() != '') { // 유저명이 공백이 아니라면(소켓에 접속을 했으면) 웹소켓에 연결한다
	  	   	ws = new WebSocket(url);
	  	   	
	     		// 소켓 이벤트 매핑처리(웹소켓에 연결되면 onopen메소드 수행 처리)
	  	   	ws.onopen = function (evt) {
	  	   		console.log($('#user').val(), '서버 연결 성공');
	  	   		print($('#user').val(), '입장했습니다.');
	  	   				
	  	   		
		  			ws.send('1#' + $('#user').val() + '#');
		  			
		  			$('#chatStatus').html('${sNickName}님 접속중');
	  	   		
		  			$('#user').attr('readonly', true);					
		  			$('#btnConnect').attr('disabled', true);		
		  			$('#btnDisconnect').attr('disabled', false);
		  			$('#msg').attr('disabled', false);	
		  			$('#msg').focus();
		  		};
	        
		  		// 메세지를 보내면 서버에 다녀온 후()getBasicRemote().sendText() 에서 가져온 메세지 처리
	  			ws.onmessage = function (evt) {		
	  				// 서버에 넘어온 값이 '2#user명: 메세지'... '2#use명:메세지@색상'
		  			let index = evt.data.indexOf("#", 2);	// 메세지와 색상코드가 있는지 찾고 있다
		  			let no = evt.data.substring(0, 1);	// 접속자가 1(처음접속자), 2(기존접속자), 3(종료접속자) 인지 판별		
		  			let user = evt.data.substring(2, index);  // 로그인 사용자의 유저명을 가져온다.
		  			
		  			if(index == -1) user = evt.data.substring(evt.data.indexOf("#")+1, evt.data.indexOf(":"));	// 색상코드 없이 바로 넘어온 경우
		  			let txt = evt.data.substring(evt.data.indexOf(":")+1); // 메세지 발췌			
		  	   				
		  			if (no == '1') {	// 최초접속자는 print2() 메소드 호출
		  				print2(user);
		  			} else if (no == '2') {	// 기존 접속자들은 print()에 '유저명','메세지'를 보낸다.
		  				if (txt != '') print(user, txt);
		  			} else if (no == '3') {	// 종료사용자는 print3()으로 보낸다
		  				print3(user);
		  			}
		  			$('#list').scrollTop($('#list').prop('scrollHeight'));	// 스크롤바 가장 아래쪽으로 내리기
		  		};
	  	   	
		  		// 웹소켓 접속 종료될 때 실행 메소드
		  		ws.onclose = function (evt) {
		  			console.log('소켓이 닫힙니다.');
		  		};
	
		  		// 웹소켓 에러 발생시에 실행 메소드
		  		ws.onerror = function (evt) {
		  			console.log(evt.data);
		  		};
		  	} else {
		  		alert('유저명을 입력하세요.');
		  		$('#user').focus();
		  	}
		  });
		
		  // 로그인 사용자가 메세지 전송시 처리(유저명, 내용 보내기)
		  function print(user, txt) {
		  	let temp = '';
		  	
		  	if('${sNickName}'!=user) {	
		  		temp += '<div style="margin-top:15px;margin-bottom:3px;margin-right:100px">';
			  	temp += '<font size="2em" style="margin-top:5px;margin-bottom:5px;padding:5px;">' + user + '</font> ';
		  	}
		  	else {	
		  		temp += '<div style="margin-bottom:3px;margin-left:100px" class="text-right">';
			  	temp += '<font size="1em">' + user + '</font> ';
		  	}
		  	temp += '<span style="font-size:11px;color:#777;">' + new Date().toLocaleTimeString() + '</span><br/>';
		  	if('${sNickName}'!=user) {
		  		temp += '<div style="background-color:#E4E4E4;border:1px solid #000; border-radius:4px; padding:5px; text-align:left;width:auto;">'+txt+'</div>';
		  	}
		  	else {
		  		if(txt.indexOf("입장했습니다.") != -1) {
		  		  temp += '<div style="background-color:#CDD7E4;border:1px solid #000;border-radius:4px;padding:5px;text-align:left;width:auto;">'+user+"님이 " + txt+'</div>';
		  		}
		  		else {
		  		  temp += '<div style="background-color:#CDD7E4;border:1px solid #000;border-radius:4px;padding:5px;text-align:left;width:auto;">'+txt+'</div>';		  			
		  		}
		  	}
		  	temp += '</div>';
			  temp = temp.replace(/\n/gi,"<br/>");	
		  			
		  	$('#list').append(temp);	
		  }
		  		
		  // 다른 클라이언트 사용자가 처음 접속할 때 처리
		  function print2(user) {
		  	let temp = '';
		  	temp += '<div style="margin-bottom:3px; text-align:center;">';
		  	temp += "<font color='red'>'" + user + "'</font> 이(가) <font color='blue'>접속</font>했습니다." ;
		  	temp += ' <span style="font-size:11px;color:#777;">' + new Date().toLocaleTimeString() + '</span>';
		  	temp += '</div>';
		  			
		  	$('#list').append(temp);
		  }
		
		  // 클라이언트가 접속 종료시 처리
		  function print3(user) {
		  	let temp = '';
		  	temp += '<div style="margin-bottom:3px; text-align:center;">';
		  	temp += "<font color='red'>'" + user + "'</font> 이(가) <font color='red'>종료</font>했습니다." ;
		  	temp += ' <span style="font-size:11px;color:#777;">' + new Date().toLocaleTimeString() + '</span>';
		  	temp += '</div>';
		  			
		  	$('#list').append(temp);
		  }
	
		  
		  $('#user').keydown(function() {
		  	if (event.keyCode == 13) {
		  		$('#btnConnect').click();
		  	}
		  });
		  
		  
		  $('#msg').keydown(function() {
		  	if (event.keyCode == 13) {
		  		if(!event.shiftKey) {
			  		if($('#msg').val().trim() == '') return false;
			  		
			  		ws.send('2#' + $('#user').val() + '#' + $(this).val());
			  		print($('#user').val(), '<font color="#000">'+$(this).val()+'</font>');
			  		
			  		event.preventDefault();	
			      $('#msg').val('');  		
			  		$('#msg').focus();
			  		$('#list').scrollTop($('#list').prop('scrollHeight'));	
		  		}
		  	}
		  });
		  		
		  
		  $('#btnDisconnect').click(function() {
		  	ws.send('3#' + $('#user').val() + '#');
		  	ws.close();
		  			
		  	$('#user').attr('readonly', false);
		  	
		    $('#user').val('${sNickName}');
		  	$('#user').attr('disabled', true);
		  	$('#chatStatus').html('${sNickName}님 <font color="red">접속대기</font>상태');
		  	$('#list').append('<span style="text-align:center;"><font color="red">${sNickName}</font>님 접속종료');
		  			
		  	$('#btnConnect').attr('disabled', false);
		  	$('#btnDisconnect').attr('disabled', true);
		  			
		  	$('#msg').val('');
		  	$('#msg').attr('disabled', true);
		  });
		  
	  });
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
	<div class="row">
		<div class="col-lg-8 offset-md-2">
			<div class="bodyRight">
			<p><br/></p>
				<div class="row mb-3">
					<div class="col text-right">
						<h3>유저채팅방</h3>
						<div id="chatStatus"><font color="red">접속대기</font>상태</div>
					</div>
				</div>
				<!-- 채팅창 -->
				<p><br/></p>
				<div class="row">
					<div class="col-7">
					  <input type="text" name="user" value="${sNickName}" id="user" class="form-control m-0" readonly />
					</div>
					<div class="col-5">
					  <input type="button" value="연결하기" id="btnConnect" class="btn btn-main btn-icon-md m-0"/>
					  <input type="button" value="종료" id="btnDisconnect" class="btn btn-main-3 btn-icon-md m-0" disabled />
					</div>
				</div>
				<div style="height:400px;border:1px solid #fff;border-radius:4px;margin:2px 0;background-color:#EDF1F5">
					<div id="list"></div>
				</div>
				<div>
					<div>
					  <textarea name="msg" id="msg" rows="3" placeholder="대화 내용을 입력하세요." class="form-control mb-2" disabled></textarea>
					</div>
				</div>
			  
			</div>
		</div>
	</div>
</div>
<p><br/></p>
</body>
</html>