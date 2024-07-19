<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>쪽지 보내기</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<script>
		'use strict';
		
		function fCheck(){
			let content = $("#content").val();
			let receiveMid = $("#receiveMid").val();
			if(content.trim()=="") {
				alert("제목을 입력하세요");
				return false;
			}
			let query = {
					sendMid : "${sMid}",
					receiveMid : receiveMid,
					content : content
			}
			$.ajax({
				url: "${ctp}/member/sendMessage",
				type: "post",
				data: query,
				success: function(res) {
					if(res != "0") {
						alert("해당 사용자에게 쪽지를 전송했습니다.");
						window.close();
					}
					else alert("쪽지 전송 실패");
				},
				error: function() {
					alert("전송오류");
				}
			});
		}
		
		function wClose(){
			window.close();
		}
	</script>
</head>
<body id="top">
<p><br/></p>
<div class="container">
<form name="myform" method="post">
	<div class="row justify-content-center mb-3">
		<div class="col-md-6 offset-md-2 col-sm-6 col-sm-offset-2">
			<input type="text" name="writer" id="writer" class="form-control mt-2" value="${sNickName} (${sMid})" readonly />		
		</div>
	</div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-6 offset-md-2 col-sm-6 col-sm-offset-2">
			<input type="text" name="receiveMid" id="receiveMid" value="${receiveMid}" class="form-control mt-2" placeholder="아이디를 입력하세요" required/>
		</div>
	</div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-6 offset-md-2 col-sm-6 col-sm-offset-2"><h4>내용</h4>
			<textarea name="content" id="content" rows="6" class="form-control"></textarea>
		</div>
	</div>
	<div class="divider2 mx-auto my-4" style="width:100%;"></div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-6 offset-md-2 col-sm-6 col-sm-offset-2 text-center">
			<input type="button" value="보내기" onclick="fCheck()" class="btn btn-main-2 btn-icon-md btn-round-full" />
			<input type="button" value="취소" onclick="wClose()" class="btn btn-main btn-icon-md btn-round-full" />
		</div>
	</div>
	<input type="hidden" name="sendMid" value="${sMid}"/>
</form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
</body>
</html>