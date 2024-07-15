<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>견적 요청</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
	<script>
		'use strict';
		
		$(function(){
			if(${!empty sw}) document.getElementById("demoImg").src = "${ctp}/images/noimage2.png";
			else document.getElementById("demoImg").src = "${ctp}/product/${vo.proPhoto}";
			if(${!empty mVo.co_name}) myform.co_name.value = '${mVo.co_name}';
		});
		
		function proNameChange() {
			let idx = myform.productIdx.value;
			if(idx!="") {
				$.ajax({
					url: "${ctp}/product/productEstimate/productImgChange",
					type: "post",
					data: {idx:idx},
					success: function(res) {
						document.getElementById("demoImg").src = "${ctp}/data/product/"+res;
						//$("#demoImg").load(location.href+" #demoImg");
					},
					error: function(){
						alert("전송오류");
					}
				});
			}
		}
		
		function fCheck() {
			let email1 = myform.email1.value.trim();
			let email2 = myform.email2.value;
			let email = email1+"@"+email2;
			let tel1 = myform.tel1.value;
			let tel2 = myform.tel2.value.trim();
			let tel3 = myform.tel3.value.trim();
			let tel = tel1+"-"+tel2+"-"+tel3;
			
			let regEmail = /^[a-zA-Z0-9]([-_]?[a-zA-Z0-9])*$/i;
			let regTel = /\d{2,3}-\d{3,4}-\d{4}$/;
			
			if(tel2 == "" || tel3 == ""){
				alert("연락처를 작성해주세요.");
				return false;
		  }
			if(!regTel.test(tel)) {
			 alert("연락처를 형식(000-0000-0000)에 맞도록 작성해주세요.");
			 myform.tel2.focus();
			 return false;
			}
			if(email1==""){
				alert("견적서를 받으실 이메일을 작성해주세요.");
				return false;
		  }
			if(!regEmail.test(email1)) {
				alert("이메일 형식에 맞도록 작성해주세요.");
				myform.email1.focus();
				return false;
			} 
			
			myform.email.value = email;
			myform.tel.value = tel;
			myform.submit();
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<p><br/></p>
<div class="container">
<div class="spinner-border text-muted" id="spinner" style="display:none;"></div>
	<div class="text-center"><h2>제품 견적요청</h2></div>
	<div class="divider2 mx-auto my-4 text-center" style="width:70%;"></div>
	<form name="myform" method="post">
		<div class="row justify-content-center mb-3">
			<div class="col-md-2 mb-3">
				<div><img id="demoImg" width="200px"/></div>
			</div>
			<div class="col-md-6">
				<div class="row mb-3">
					<div class="col-md-10 offset-md-2">
						<h4 class="text-left">모델명</h4>
						<select name="productIdx" id="productIdx" onchange="proNameChange()" class="form-control">
							<option value="">제품 선택</option> 
							<c:forEach var="pVo" items="${vos}" varStatus="st">
								<option value="${pVo.idx}" ${vo.proName==pVo.proName ? 'selected' : ''} >${pVo.proName}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="row mb-3">
					<div class="col-md-10 offset-md-2">
						<h4 class="text-left">회사명</h4>
						<input type="text" name="co_name" id="co_name" class="form-control" placeholder="발주처를 입력하세요" required/>
					</div>
				</div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-10 offset-md-2"><h4>담당자</h4>
		        <input type="text" name="memberMid" id="memberMid" value="${sMid}" placeholder="아이디를 입력하세요" class="form-control" readonly required />
					</div>
				</div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-10 offset-md-2"><h4>연락처</h4>
						<div class="input-group mb-3">
							<c:set var="memberTel" value="${fn:split(mVo.tel,'-')}"/>
			        <select name="tel1" class="custom-select" style="height:auto">
	              <option value="010" ${memberTel[0]=='010' ? 'selected' : ''}>010</option>
	              <option value="02" ${memberTel[0]=='02' ? 'selected' : ''}>02</option>
	              <option value="031" ${memberTel[0]=='031' ? 'selected' : ''}>031</option>
	              <option value="032" ${memberTel[0]=='032' ? 'selected' : ''}>032</option>
	              <option value="041" ${memberTel[0]=='041' ? 'selected' : ''}>041</option>
	              <option value="042" ${memberTel[0]=='042' ? 'selected' : ''}>042</option>
	              <option value="043" ${memberTel[0]=='043' ? 'selected' : ''}>043</option>
	              <option value="051" ${memberTel[0]=='051' ? 'selected' : ''}>051</option>
	              <option value="052" ${memberTel[0]=='052' ? 'selected' : ''}>052</option>
	              <option value="061" ${memberTel[0]=='061' ? 'selected' : ''}>061</option>
	              <option value="062" ${memberTel[0]=='062' ? 'selected' : ''}>062</option>
            	</select>-
			        <input type="text" name="tel2" size=4 maxlength=4 value="${memberTel[1]}" class="form-control" required/>-
			        <input type="text" name="tel3" size=4 maxlength=4 value="${memberTel[2]}" class="form-control" required/>
			      </div>
					</div>
				</div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-10 offset-md-2"><h4>이메일</h4>
					  <div class="input-group mb-3">
					  	<c:set var="memberEmail" value="${fn:split(mVo.email,'@')}"/>
		          <input type="text" class="form-control" value="${memberEmail[0]}" placeholder="E-mail을 입력하세요." id="email1" name="email1" required />
		          <select name="email2" class="form-control" style="height:auto">
		            <option value="naver.com" ${memberEmail[1]=='naver.com' ? 'selected' : ''}>naver.com</option>
		            <option value="gmail.com" ${memberEmail[1]=='gmail.com' ? 'selected' : ''}>gmail.com</option>
		            <option value="hanmail.net" ${memberEmail[1]=='hanmail.net' ? 'selected' : ''}>hanmail.net</option>
		            <option value="daum.net" ${memberEmail[1]=='daum.net' ? 'selected' : ''}>daum.net</option>
		            <option value="nate.com" ${memberEmail[1]=='nate.com' ? 'selected' : ''}>nate.com</option>
		            <option value="yahoo.com" ${memberEmail[1]=='yahoo.com' ? 'selected' : ''}>yahoo.com</option>
		            <option value="korea.com" ${memberEmail[1]=='korea.com' ? 'selected' : ''}>korea.com</option>
		          </select>
		        </div>
					</div>
				</div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-10 offset-md-2"><h4>상세내용</h4>
						<textarea rows="5" name="etcDetail" id="etcDetail" class="form-control"></textarea>
					</div>
				</div>
			</div>
		</div>

		<div class="divider2 mx-auto my-4 text-center" style="width:70%;"></div>
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2 text-center">
				<input type="button" value="확인" onclick="fCheck()" class="btn btn-main btn-icon btn-round-full mr-2" />
				<input type="button" value="취소" onclick="location.href='${ctp}/product/productSale';" class="btn btn-main-3 btn-icon btn-round-full" />
			</div>
		</div>
		<input type="hidden" name="email">
		<input type="hidden" name="tel">
	</form>
</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>