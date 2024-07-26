<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>비밀번호 변경</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
	<script>
		'use strict';
		
		function pwdCheck(){
			let pwd = $("#pwd").val();
			let pwdNew = $("#pwdNew").val();
			let pwdNewRe = $("#pwdNewRe").val();
			
			let regPwd = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[\W_]).{4,20}$/;
			
			if(pwd.trim()=="") {
				alert("현재 비밀번호를 입력하세요.");
				$("#pwd").focus();
				return false;
			}
			else if(pwdNew.trim()=="" || pwdNewRe.trim()=="") {
				alert("변경할 비밀번호를 입력하세요.");
				$("#pwdNew").focus();
				return false;
			}
			else if(pwdNew.trim() != pwdNewRe.trim()) {
				alert("변경할 비밀번호가 일치하지 않습니다.");
				$("#pwdNewRe").focus();
				return false;
			}
			/*
			else if(!regPwd.test(pwdNew)) {
   		 alert("비밀번호는 영문 대/소문자와 숫자, 특수문자를 포함하여 4~20자까지 가능합니다. 특수문자를 꼭 1개 이상 포함해주세요.");
   		 document.getElementById("pwdNew").focus();
   		 return false;
   		}
   	  */
			else {
				myform.submit();
			}
			
		}
	</script>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
	<!-- Start Account Sign In Area -->
	<div class="account-login section">
	<div class="row">
	  <div class="col-lg-6 offset-lg-3">
	   <form name="myform" class="inner-content" method="post">
	     <div class="card-body">
	       <div class="title">
	         <h3>관리자 비밀번호 변경</h3>
	       </div>
	       <hr/>
	       <div class="input-head">
	         <div class="form-group input-group">
	           <input class="form-control" type="password" id="pwd" name="pwd" placeholder="현재 비밀번호" required/>
	         </div>
	         <div class="form-group input-group">
	           <input class="form-control" type="password" id="pwdNew" name="pwdNew" placeholder="변경할 비밀번호" required/>
	         </div>
	         <div class="form-group input-group">
	           <input class="form-control" type="password" id="pwdNewRe" name="pwdNewRe" placeholder="변경할 비밀번호 확인" required/>
	         </div>
	       </div>
	       <div class="d-flex flex-wrap justify-content-between bottom-content">
	         <div></div>
	         <a href="${ctp}/member/pwdSearch">비밀번호를 잊으셨습니까?</a>
	       </div>
	       <hr/>
	       <div class="button text-center">
	         <input type="button" onclick="pwdCheck()" class="btn btn-main-2 mr-2" value="비밀번호 변경" />
	         <a class="btn btn-main" href="${ctp}/">취소</a>
	       </div>
	      </div>
	      <input type="hidden" name="mid" value="${sMid}"/>
	    </form>
	  </div>
	</div>
	</div>
	<!-- End Account Sign In Area -->
</div>
<p><br/></p>
</body>
</html>