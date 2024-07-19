<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>글쓰기 - 질문게시판</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<script>
		'use strict';
		
		function fCheck(){
			let title = $("#title").val();
			let content = $("#content").val();
			if(title.trim()=="") {
				alert("제목을 입력하세요");
				return false;
			}
			else if(content.trim()==""){
				alert("내용을 입력하세요");
				return false;
			}
			myform.submit();
		}
	</script>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<p><br/></p>
<div class="container">
<form name="myform" method="post" action="QuestionBoardInputOk.do">
	<div class="row justify-content-center mb-3">
		<div class="col-md-4 col-md-offset-2">
			<div class="form-group">
				<input type="text" name="board" id="board" class="form-control" value="질문게시판" readonly />
			</div>
		</div>
		<div class="col-md-4 col-md-offset-2">
			<div class="form-group">
				<select class="form-control" name="part" id="part" style="height:45px;">
					<option ${part=="실험방법" ? "selected" : "" }>실험방법</option>
					<option ${part=="실험장비" ? "selected" : "" }>실험장비</option>
					<option ${part=="법규" ? "selected" : "" }>법규</option>
					<option ${part=="기타" ? "selected" : "" }>기타</option>
				</select>
			</div>
		</div>
		<div class="col-md-8 col-md-offset-2">
			<input type="text" name="writer" id="writer" class="form-control mt-2" value="${sNickName} (${sMid})" readonly />		
		</div>
	</div>
	<div class="divider2 mx-auto my-4"></div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-8 col-md-offset-2"><h4 style="font-family:Gowun Dodum;">제목</h4>
			<input type="text" name="title" id="title" class="form-control mt-2" placeholder="제목을 입력하세요" required/>
		</div>
	</div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-8 col-md-offset-2"><h4 style="font-family:Gowun Dodum;">내용</h4>
			<textarea name="content" id="content" rows="10" class="form-control"></textarea>
		</div>
	</div>
	<div class="divider2 mx-auto my-4"></div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-8 col-md-offset-2 text-right">
			<input type="button" value="등록하기" onclick="fCheck()" class="btn btn-main-2 btn-icon btn-round-full" />
			<input type="button" value="취소" onclick="location.href='questionBoardList';" class="btn btn-main btn-icon btn-round-full" />
		</div>
	</div>
	<input type="hidden" name="mid" value="${sMid}"/>
	<input type="hidden" name="nickName" value="${sNickName}"/>
	<input type="hidden" name="hostIp" value="${pageContext.request.remoteAddr}"/>
</form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>