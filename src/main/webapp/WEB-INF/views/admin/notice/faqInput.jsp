<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관리자 - FAQ 작성하기</title>
  <script src="${ctp}/ckeditor/ckeditor.js"></script>
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<link rel="stylesheet" href="${ctp}/css/bootstrap-datepicker.css">
   <style>
      .input-group {
          align-items: center;
      }
      .form-check {
          display: flex;
          align-items: center;
          margin-left: 10px;
      }
      .form-check-input {
          margin-top: 0;
      }
  </style>
	<script>
		'use strict';
		
		function addPart(){
			if($("#part").val()=='add') {
				$("#partInput").show();
			}
			else {
				$("#partInput").hide();
			}
		}
		
		function fCheck(){
			let part = $("#part").val();
			let title = $("#title").val();
			let content = $("#content").val();
			let regPart = /^.{2,10}$/;
			
			if(part.trim()=="분류" && part.trim() != "add") {
				alert("공지 카테고리를 선택하세요.");
				return false;
			}
			else if(title.trim()=="") {
				alert("제목을 입력하세요.");
				myform.title.focus();
				return false;
			}
			else if(content.trim()=="") {
				alert("내용을 입력하세요.");
				myform.content.focus();
				return false;
			}
			if(part.trim()=="add") {
				let partInput = $("#addPartInput").val();
				if(!regPart.test(partInput)) {
					alert("분류는 2-10자 이내로 작성해주세요.");
					document.getElementById('partInput').focus();
					return false;
				}
				document.getElementById('newPart').value = partInput;
			}
			myform.submit();
		}
	</script>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
<div class="text-center"><h2>FAQ 등록</h2></div>
<div class="divider2 mx-auto my-4" style="width:70%;"></div>
<form name="myform" method="post">
	<div class="row justify-content-center mb-2">
		<div class="col-md-8">
			<div class="form-group">
				<select class="form-control" name="part" id="part" style="height:45px;" onchange="addPart()">
					<option>분류</option>
					<c:forEach var="part" items="${parts}" varStatus="st">
						<option value="${part}">${part}</option>
					</c:forEach>
					<option value="add">새 분류 추가</option>
				</select>
			</div>
		</div>
	</div>
	<div class="row justify-content-center mb-3" id="partInput" style="display:none;">
		<div class="col-md-8 col-md-offset-2"><h4>새 분류</h4>
			<input type="text" id="addPartInput" name="addPartInput" class="form-control">
		</div>
	</div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-8 col-md-offset-2"><h4>제목</h4>
			<div class="input-group">
				<input type="text" name="title" id="title" class="form-control mt-2" placeholder="제목을 입력하세요" required/>
			</div>
		</div>
	</div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-8 col-md-offset-2"><h4>내용</h4>
			<textarea name="content" id="content" rows="5" class="form-control"></textarea>
		</div>
	</div>
	<div class="divider2 mx-auto my-4" style="width:70%;"></div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-8 col-md-offset-2 text-right">
			<input type="button" value="등록하기" onclick="fCheck()" class="btn btn-main-2 btn-icon btn-round-full" />
			<a href="${ctp}/admin/notice/faqList?pag=${pageVO.pag}&pageSize=${pageVO.pageSize}" class="btn btn-main btn-icon btn-round-full">취소</a>
		</div>
	</div>
	<input type="hidden" name="newPart" id="newPart" />
</form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
</body>
</html>