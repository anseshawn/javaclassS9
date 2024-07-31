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
	<title>관리자 - 받은 메세지</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
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
	    
		  display: flex;
		  justify-content: space-between;
		  align-items: center;
		}
		
		.message-status {
	    margin-left: auto;
	    margin-right: 10px;
	    font-weight: bold;
	    color: #999;
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
        		url: "${ctp}/admin/setting/messageCheck",
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
			let url = "${ctp}/admin/setting/sendMessage?receiveMid="+mid;
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
		
		function deleteMessage(idx, sw) {
			let ans = confirm("쪽지를 삭제하겠습니까?");
			if(!ans) return false;
			
			$.ajax({
				url: "${ctp}/admin/setting/messageDelete",
				type: "post",
				data: {
					idx : idx,
					sw : sw
				},
				success: function(res) {
					if(res != "0") {
						alert("쪽지를 삭제했습니다.");
						location.reload();
					}
					else alert("쪽지 삭제 실패. 다시 시도해주세요.");
				},
				error: function(){
					alert("전송 오류");
				}
			});
		}
		
		function deleteMessageDB(idx) {
			let ans = confirm("발송 취소하시겠습니까?");
			if(!ans) return false;
			
			$.ajax({
				url: "${ctp}/admin/setting/messageDeleteDB",
				type: "post",
				data: {idx : idx},
				success: function(res) {
					if(res != "0") {
						alert("쪽지를 삭제했습니다.");
						location.reload();
					}
					else alert("쪽지 삭제 실패. 다시 시도해주세요.");
				},
				error: function(){
					alert("전송 오류");
				}
			});
		}
		
		function midSearchView() {
			let mid = $("#mid").val();
			if(mid.trim() == "") {
				alert("아이디를 입력하세요.");
				return false;
			}
			let str = "";
			$.ajax({
				url: "${ctp}/admin/midSearch",
				type: "post",
				data: {mid : mid},
				success: function(mVos) {
					for(let i=0; i<mVos.length; i++) {
						str += '<tr>';
						str += '<td>'+mVos[i].name+'</td>';
						str += '<td><a href="javascript:sendMessage(\''+mVos[i].mid+'\')">'+mVos[i].mid+'</a></td>';
						str += '<td>'+mVos[i].nickName+'</td>';
						str += '</tr>';
					}
					$("#memberAll").hide();
					$("#midSearchResult").html(str).show();
				},
				error: function() {
					alert("전송오류");
				}
			});
		}
		
		function allMemberShow() {
			$("#memberAll").show();
			$("#midSearchResult").hide();
		}
 	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
	<div class="row">
		<div class="col-lg-9 container-fluid">
		<p><br/></p>
			<div class="bodyRight">
				<div class="row">
					<div class="col-md-3 text-right offset-md-9">
						<a href="#" id="midSearch" data-toggle="modal" data-target="#myModal" class="btn btn-main btn-icon-md form-control mb-2">회원 검색</a>
					</div>
				</div>
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
	                  <c:set var="rLength" value="${fn:length(rVO.content)}"/>
	                  <div class="message-snippet">
	                  	<c:if test="${rLength >8}">${fn:substring(rVO.content,0,8)}......</c:if>
	                  	<c:if test="${rLength <= 8}">${rVO.content}</c:if>
	                  </div>
	                  <div class="message-time">${fn:substring(rVO.receiveDate,0,19)}</div>
                    <div class="message-full-content" style="display: none;">
                      ${fn:replace(rVO.content, newLine, '<br/>')}
                      <div class="message-actions text-right">
                        <a href="javascript:sendMessage('${rVO.sendMid}')" class="btn btn-main btn-icon-md">답장</a>
                        <a href="javascript:deleteMessage('${rVO.idx}','receiveSw')" class="btn btn-main-3 btn-icon-md">삭제</a>
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
	                  <c:set var="sLength" value="${fn:length(sVO.content)}"/>
	                  <div class="message-snippet">
	                  	<c:if test="${sLength >8}">${fn:substring(sVO.content,0,8)}......</c:if>
	                  	<c:if test="${sLength <= 8}">${sVO.content}</c:if>
	                  	<span class="message-status">${sVO.receiveSw == 'r' ? '읽음' : '읽지 않음'}</span>
	                  </div>
	                  <div class="message-time">${fn:substring(sVO.sendDate,0,19)}</div>
                    <div class="message-full-content" style="display: none;">
                      ${fn:replace(sVO.content, newLine, '<br/>')}
                      <div class="message-actions text-right">
                      	<c:if test="${sVO.receiveSw=='r'}">
                        	<a href="javascript:deleteMessage('${sVO.idx}','sendSw')" class="btn btn-main-3 btn-icon-md">삭제</a>
                        </c:if>
                      	<c:if test="${sVO.receiveSw != 'r'}">
                        	<a href="javascript:deleteMessageDB('${sVO.idx}')" class="btn btn-main-3 btn-icon-md">발송취소</a>
                        </c:if>
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

<div class="modal fade" id="myModal">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
    
      <div class="modal-header text-center">
        <h4 class="modal-title">회원 목록</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      
      <div class="modal-body">
      	<div class="input-group mb-2">
      		<input type="text" name="mid" id="mid" placeholder="검색할 아이디를 입력하세요" class="form-control" />
	        <input type="button" value="아이디 검색" onclick="midSearchView()" id="midSearchBtn" class="btn btn-main btn-icon-md" />
	        <input type="button" value="전체보기" onclick="allMemberShow()" class="btn btn-main-3 btn-icon-md" />
      	</div>
      	<table class="table table-hover text-center">
      		<tr style="background-color:#003675; color:#fff;">
      			<th>이름</th>
      			<th>아이디</th>
      			<th>닉네임</th>
      		</tr>
      		<tbody id="memberAll">
	      		<c:forEach var="vo" items="${mVos}" varStatus="st">
	      			<tr>
	      				<td>${vo.name}</td>
	      				<td><a href="javascript:sendMessage('${vo.mid}')">${vo.mid}</a></td>
	      				<td>${vo.nickName}</td>
	      			</tr>
	      		</c:forEach>
      		</tbody>
      		<tbody id="midSearchResult" style="display:none;"></tbody>
      		<tr><td colspan="3" class="m-0 p-0"></td></tr>
      	</table>
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
      
    </div>
  </div>
</div>
</body>
</html>