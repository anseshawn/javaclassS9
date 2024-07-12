<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>비밀번호 찾기</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<!-- 커스텀 알럿 -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<style>
		#spinner {
		  position: absolute;
		  left: 50%;
		  top: 50%;
		  z-index: 1;
		}
		.swal2-confirm‎ {
	    background-color: #003675 !important;
	    color: #fff !important;
	    border-radius: 0px !important;
	    box-shadow: none !important;
	    font-weight: bold !important;
	    font-size: 18px !important;
	    margin: 0 !important;
		}
		.custom-swal-popup {
	    width: 350px !important;
	    padding-top: 20px !important;
	    border-radius: 0px !important;
		}
		.swal2-confirm‎:hover {
	    background-color: none !important;
		}
	</style>
	<script>
		'use strict';
		
		function fCheck(){
			let mid = $("#mid").val();
			let email = $("#email").val();
			
			if(mid.trim()=="") {
				alert("아이디를 입력하세요.");
				$("#mid").focus();
				return false;
			}
			else if(email.trim()=="") {
				alert("이메일을 입력하세요.");
				$("#email").focus();
				return false;
			}
			let message = "";
			let icon = "";
			document.getElementById("spinner").style.display='block';
			$.ajax({
				url: "${ctp}/engineer/pwdSearchOk",
				type: "post",
				data: {
					mid: mid,
					email: email
				},
				success: function(res){
					if(res != "0") {
						message = "새로운 비밀번호가 입력한 메일로 발송 되었습니다.\n받은 메일함을 확인하세요.";
						icon = "success";
						//alert("새로운 비밀번호가 입력한 메일로 발송 되었습니다.\n받은 메일함을 확인하세요.");
					}
					else {
						message = "입력한 정보가 일치하지 않습니다.\n다시 확인하세요.";
						icon = "warning";
						//alert("입력한 정보가 일치하지 않습니다.\n다시 확인하세요.");
					}
					Swal.fire({
		        html : message,
		        icon : icon,
		        confirmButtonText : '확인',
		        customClass: {
		        	confirmButton : 'swal2-confirm‎',
	            popup : 'custom-swal-popup',
	            htmlContainer : 'custom-swal-text'
		        }
				  });
					document.getElementById("spinner").style.display='none';
				},
				error: function(){
					alert("전송오류");
					document.getElementById("spinner").style.display='none';
				}
			});
		}
		
	</script>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<p><br/></p>
<div class="spinner-border text-muted" id="spinner" style="display:none;"></div>
<div class="container">
	<!-- Start Account Sign In Area -->
	<div class="account-login section">
	<div class="row">
	  <div class="col-lg-6 offset-lg-3">
	   <form name="myform" class="inner-content" method="post">
	     <div class="card-body">
	       <div class="title">
	         <h3>비밀번호 찾기</h3>
	       </div>
	       <hr/>
	       <div class="mb-3">회원가입 시 이용했던 아이디와 이메일을 입력해주세요.</div>
	       <div class="input-head">
	         <div class="form-group input-group">
	           <input class="form-control" type="text" id="mid" name="mid" placeholder="아이디" required/>
	         </div>
	         <div class="form-group input-group">
	           <input class="form-control" type="email" id="email" name="email" placeholder="이메일 주소" required/>
	         </div>
	       </div>
	       <div class="d-flex flex-wrap justify-content-between bottom-content">
	         <div></div>
	         <c:if test="${empty sLevel}">
		         <div><a href="${ctp}/member/midSearch">아이디 찾기</a></div>
	         </c:if>
	       </div>
	       <hr/>
	       <div class="button text-center">
	         <input type="button" onclick="fCheck()" class="btn btn-main-2 mr-3" value="비밀번호 찾기" />
	         <c:if test="${empty sLevel}">
	         	<a class="btn btn-main" href="${ctp}/member/memberJoin">회원가입</a>
	         </c:if>
	         <c:if test="${!empty sLevel}">
	         	<a class="btn btn-main" href="${ctp}/">메인으로</a>
	         </c:if>
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