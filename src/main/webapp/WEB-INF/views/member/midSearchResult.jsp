<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>아이디 찾기 결과</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<style>
		ul {
		  display: block;
		  list-style-type: none;
		  margin-block-start: 1em;
		  margin-block-end: 1em;
		  margin-inline-start: 0px;
		  margin-inline-end: 0px;
		  padding-inline-start: 40px;
		  padding-inline-end: 20px;
		}
	</style>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<p><br/></p>
<div class="container">
<div class="row justify-content-center mb-3">
	<div class="col-lg-8">
		<h2>아이디 찾기</h2>
	</div>
</div>
<div class="divider2 mx-auto my-4" style="width:80%;"></div>
<div class="row justify-content-center mt-5 mb-5">
	<div class="col-lg-8 col-lg-offset-2" style="border:1px solid #eee; color:black;">
		<ul>
			<c:if test="${empty mid}">
				<li class="mb-4 mt-4 text-center" style="font-size:1.2rem;">
					찾으시는 회원 정보가 없습니다. 이름 혹은 이메일을 다시 확인해주세요.
				</li>
				<div class="text-center mt-5">
					<a href="${ctp}/member/midSearch" class="btn btn-main-2 btn-icon btn-round-full mr-2">다시입력</a>
					<a href="${ctp}/member/memberJoin" class="btn btn-main btn-icon btn-round-full">회원가입</a>
				</div>
			</c:if>
			<c:if test="${!empty mid}">
				<li class="mb-4 mt-4 text-center" style="font-size:1.2rem;">
					회원님의 아이디는 ${mid} 입니다.
				</li>
				<div class="text-center mt-5">
					<a href="${ctp}/member/memberLogin/main" class="btn btn-main-2 btn-icon btn-round-full mr-2">로그인하기</a>
					<a href="${ctp}/" class="btn btn-main btn-icon btn-round-full">메인으로</a>
				</div>
			</c:if>
		</ul>
	</div>
</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>