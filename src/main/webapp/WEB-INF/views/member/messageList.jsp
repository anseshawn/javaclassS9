<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>받은 메세지</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <jsp:include page="/WEB-INF/views/include/scripts.jsp" />
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
  	
		.message-list {
	    max-height: 500px;
	    overflow-y: auto;
		}
		
		.receiveMessage-item, .sendMessage-item {
	    padding: 10px;
	    border-bottom: 1px solid #eee;
	    position: relative;
	    cursor: pointer;
		}
		
		.receiveMessage-item:hover, .sendMessage-item:hover {
	    background-color: #f9f9f9;
		}
		
		.message-sender {
	    font-weight: bold;
		}
		
		.message-snippet {
	    color: #555;
	    white-space: nowrap;
	    overflow: hidden;
	    text-overflow: ellipsis;
		}
		
		.message-time {
			position: absolute;
			right: 10px;
			top: 10px;
	    float: right;
	    color: #999;
		}
		
		.new-indicator {
	    background-color: red;
	    color: white;
	    border-radius: 30%;
	    padding: 1px 4px;
	    margin-left: 5px;
	    font-size: 10px;
	    font-weight: bold;
	    animation: blink 2s ease-in-out infinite;
		}
    @keyframes blink {
	    0%, 100% { opacity: 1; }
	    50% { opacity: 0; }
		}
		
  </style>
  <script>
  	'use strict';
  	
  	$(function(){
	    $('.receiveMessage-item').on('click', function () {
	    	let idx = $(this).data("index");
        $(this).find('.message-full-content').slideToggle(function(){
        	$.ajax({
        		url: "${ctp}/member/messageCheck",
        		type: "post",
        		data: {idx : idx}
        	});
        });
        $(this).find('.message-snippet').toggle();
	    });
	    $('.sendMessage-item').on('click', function () {
        $(this).find('.message-full-content').slideToggle();
        $(this).find('.message-snippet').toggle();
	    });
  	});
  	
		function sendMessage(mid){
			let url = "${ctp}/member/sendMessage?receiveMid="+mid;
			let widthSize= 450;
			let heightSize = 500;
			let leftCenter = Math.ceil((window.screen.width - widthSize)/2);
			let topCenter = Math.ceil((window.screen.height - heightSize)/2);
			window.open(
				url, // url
				'쪽지 보내기', // title
				'width='+widthSize+', height='+heightSize+', top='+topCenter+', left='+leftCenter // 설정
			);
		}
		
		function deleteMessage(idx) {
			let ans = confirm("쪽지를 삭제하겠습니까?");
			if(!ans) return false;
			
			$.ajax({
				
			});
		}
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
		<div class="col-lg-9 container-fluid">
		<p><br/></p>
			<div class="bodyRight">
      	<div class="card">
          <div class="card-header">
            <ul class="nav nav-tabs card-header-tabs" id="messageTabs" role="tablist">
              <li class="nav-item">
                <a class="nav-link active" id="inbox-tab" data-toggle="tab" href="#receiveMessage" role="tab" aria-controls="inbox" aria-selected="true">
                	받은 메세지
                	<c:if test="${!empty newMsg}"><span class="new-indicator">N</span></c:if>
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" id="sent-tab" data-toggle="tab" href="#sendMessage" role="tab" aria-controls="sent" aria-selected="false">보낸 메세지</a>
              </li>
            </ul>
          </div>
          <div class="card-body tab-content" id="messageTabsContent">
            <div class="tab-pane fade show active" id="receiveMessage" role="tabpanel" aria-labelledby="inbox-tab">
              <div class="message-list">
              	<c:forEach var="rVO" items="${receiveVOS}" varStatus="st">
	                <!-- 메시지 목록 아이템 -->
	                <div class="receiveMessage-item" data-index="${rVO.idx}">
	                  <div class="message-sender">${rVO.sendMid}</div>
	                  <div class="message-snippet">${fn:substring(rVO.content,0,10)}......</div>
	                  <div class="message-time">${fn:substring(rVO.receiveDate,0,19)}</div>
                    <div class="message-full-content" style="display: none;">
                      ${fn:replace(rVO.content, newLine, '<br/>')}
                      <div class="message-actions text-right">
                        <a href="javascript:sendMessage('${rVO.sendMid}')" class="btn btn-main btn-icon-md">답장</a>
                        <a href="javascript:deleteMessage('${rVO.idx}')" class="btn btn-main-3 btn-icon-md">삭제</a>
                      </div>
                    </div>
	                </div>
	                <!-- 반복되는 메시지 아이템 -->
                </c:forEach>
              </div>
            </div>
            <div class="tab-pane fade" id="sendMessage" role="tabpanel" aria-labelledby="sent-tab">
              <div class="message-list">
              	<c:forEach var="sVO" items="${sendVOS}" varStatus="st">
	                <!-- 보낸 메시지 목록 아이템 -->
	                <div class="sendMessage-item" data-index="${sVO.idx}">
	                  <div class="message-sender">${sVO.receiveMid}</div>
	                  <div class="message-snippet">${fn:substring(sVO.content,0,10)}......</div>
	                  <div class="message-time">${fn:substring(sVO.sendDate,0,19)}</div>
                    <div class="message-full-content" style="display: none;">
                      ${fn:replace(sVO.content, newLine, '<br/>')}
                      <div class="message-actions text-right">
                        <a href="javascript:deleteMessage('${sVO.idx}')" class="btn btn-main-3 btn-icon-md">삭제</a>
                      </div>
                    </div>	                  
	                </div>
	                <!-- 반복되는 보낸 메시지 아이템 -->
                </c:forEach>
              </div>
            </div>
          </div>
        </div>
			</div>
		</div>
	</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>