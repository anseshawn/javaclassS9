<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 로그인</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
	'use strict';
	
	window.onload = function(){
    	if("${mid}" != null) {
    		$('#idSave').attr('checked',true);
    	}
    	else {
    		$("#idSave").removeAttr('checked');
    	}
  }
</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<p><br/></p>
<div class="container">
	<!-- Start Account Sign In Area -->
  <div class="account-login section">
		<div class="row">
		  <div class="col-lg-6 offset-lg-3 col-md-10 offset-md-1 col-12">
		   <form name="myform" class="login-form inner-content" method="post">
		     <div class="card-body">
		       <div class="title">
		         <h3>Login</h3>
		       </div>
		       <div class="input-head">
		         <div class="form-group input-group">
		           <!-- <label><i class="fa-solid fa-user"></i>&nbsp;</label> -->
		           <input class="form-control" type="text" id="mid" name="mid" value="${mid}" placeholder="아이디를 입력해주세요" required/>
		         </div>
		         <div class="form-group input-group">
		           <!-- <label><i class="fa-solid fa-lock"></i>&nbsp;</label> -->
		           <input class="form-control" type="password" id="pwd" name="pwd" placeholder="비밀번호를 입력해주세요" required/>
		         </div>
		       </div>
		       <div class="d-flex flex-wrap justify-content-between bottom-content">
		         <div class="form-check">
		           <input type="checkbox" class="form-check-input width-auto" id="idSave" name="idSave" />
		           <label class="form-check-label">아이디 저장하기</label>
		         </div>
		         <div>
		         <a href="${ctp}/member/midSearch">아이디 찾기</a> │ <a href="${ctp}/member/pwdSearch">비밀번호 찾기</a>
		         </div>
		       </div>
		       <hr/>
		       <div class="button text-center">
		         <input type="submit" class="btn btn-main-2 mr-2" value="로그인" />
		         <a class="btn btn-main mr-2" href="${ctp}/member/memberJoin">회원가입</a>
		         <a href="">카카오 로그인</a>
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
</body>
</html>