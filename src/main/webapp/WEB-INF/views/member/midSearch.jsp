<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>아이디 찾기</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<script>
		'use strict';
		
		function fCheck(){
			let name = $("#name").val();
			let email = $("#email").val();
			
			if(name.trim()=="") {
				alert("이름을 입력하세요.");
				$("#name").focus();
				return false;
			}
			else if(email.trim()=="") {
				alert("이메일을 입력하세요.");
				$("#email").focus();
				return false;
			}
			else {
				myform.submit();
			}
		}
	</script>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<p><br/></p>
<div class="container">
	<!-- Start Account Sign In Area -->
	<div class="account-login section">
	<div class="row">
	  <div class="col-lg-6 offset-lg-3">
	   <form name="myform" class="inner-content" method="post">
	     <div class="card-body">
	       <div class="title">
	         <h3>아이디 찾기</h3>
	       </div>
	       <hr/>
	       <div class="mb-3">회원가입 시 이용했던 이름과 이메일을 입력해주세요.</div>
	       <div class="input-head">
	         <div class="form-group input-group">
	           <input class="form-control" type="text" id="name" name="name" placeholder="이름을 입력하세요" required/>
	         </div>
	         <div class="form-group input-group">
	           <input class="form-control" type="email" id="email" name="email" placeholder="이메일 주소를 입력하세요" required/>
	         </div>
	       </div>
	       <div class="d-flex flex-wrap justify-content-between bottom-content">
	         <div></div>
	         <div><a href="${ctp}/member/pwdSearch">비밀번호 찾기</a></div>
	       </div>
	       <hr/>
	       <div class="button text-center">
	         <input type="button" onclick="fCheck()" class="btn btn-main-2 mr-3" value="아이디 찾기" />
	         <a class="btn btn-main" href="${ctp}/member/memberJoin">회원가입</a>
	       </div>
	      </div>
	    </form>
	  </div>
	</div>
	</div>
	<!-- End Account Sign In Area -->
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<!--<jsp:include page="/WEB-INF/views/include/scripts.jsp" />-->
</body>
</html>