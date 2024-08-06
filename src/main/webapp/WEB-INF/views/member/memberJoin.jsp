<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <script src="${ctp}/js/woo.js"></script>
	<script>
  	'use strict';
  	// 개인 / 재직자에 따라 회사 정보 입력창 보이기/감추기
  	$(function(){
  		$("#company").hide();
  	});
  	function companyShow(){
  		$("#company").show(); 		
  		$("#personMent").hide(); 		
  	}
  	function companyHide(){
  		$("#company").hide(); 		
  		$("#personMent").show(); 		
  	}
  	
  	let idCheckSw = 0;
    let nickCheckSw = 0;
     
    function fCheck() {
   	 // 필수항목 입력여부 확인 
   	 let mid = document.getElementById("mid").value.trim();
   	 let pwd = document.getElementById("pwd").value.trim();
   	 let nickName = document.getElementById("nickName").value.trim();
   	 let name = document.getElementById("name").value.trim();
   	 let email1 = myform.email1.value.trim();
   	
   	
   	 if(name == "") {
   		 alert("이름을 입력하세요");
   		 myform.name.focus();
   		 return false;
   	 }
   	 else if(mid == "") {
   		 alert("아이디를 입력하세요");
   		 myform.mid.focus();
   		 return false;
   	 }
   	 else if(pwd == "") {
   		 alert("비밀번호를 입력하세요");
   		 myform.pwd.focus();
   		 return false;
   	 }
   	 else if(nickName == "") {
   		 alert("닉네임을 입력하세요");
   		 myform.nickName.focus();
   		 return false;
   	 }
   	 else if(email1 == "") {
   		 alert("이메일을 입력하세요");
   		 myform.email1.focus();
   		 return false;
   	 }
   	
   	 // 1.정규식을 이용한 유효성 검사처리
   	 // 아이디와 닉네임은 중복체크 검사시에 수행...
   	 let regPwd = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[\W_]).{4,20}$/; 
   	 let regName = /^[a-zA-Z가-힣]{2,10}$/; 
   	 let regEmail = /^[a-zA-Z0-9]([-_]?[a-zA-Z0-9])*$/i;
   	 let regTel = /\d{2,3}-\d{3,4}-\d{4}$/;
   	 
   	 if(!regPwd.test(pwd)) {
   		 alert("비밀번호는 영문 대/소문자와 숫자, 특수문자를 포함하여 4~20자까지 가능합니다. 특수문자를 꼭 1개 이상 포함해주세요.");
   		 document.getElementById("pwd").focus();
   		 return false;
   	 }
   	 if(!regName.test(name)) {
   		 alert("이름은 영문과 한글만 사용하여 2~10자까지 가능합니다.");
   		 document.getElementById("name").focus();
   		 return false;
   	 }
   	 if(!regEmail.test(email1)) {
   		 alert("이메일 형식에 맞도록 작성해주세요.");
   		 myform.email1.focus();
   		 return false;
   	 }    	
   	
   	 // 2.검사 후 필요한 내용들을 변수에 담아 회원가입 처리한다.
   	
   	 let email2 = myform.email2.value;
		 let email = email1+"@"+email2;
		 // 개인 연락처
		 let tel1 = myform.tel1.value;
		 let tel2 = myform.tel2.value.trim();
		 let tel3 = myform.tel3.value.trim();
   	 let tel = tel1+"-"+tel2+"-"+tel3;
   	 // 회사 연락처
		 let tel4 = myform.tel4.value;
		 let tel5 = myform.tel5.value.trim();
		 let tel6 = myform.tel6.value.trim();
   	 let co_tel = tel4+"-"+tel5+"-"+tel6;
   	 if(tel2 != "" || tel3 != ""){
    	 if(!regTel.test(tel)) {
    		 alert("연락처를 형식(000-0000-0000)에 맞도록 작성해주세요.");
    		 myform.tel2.focus();
    		 return false;
    	 }
   	 }
   	 else {
   		 tel2 = " ";
   		 tel3 = " ";
			 tel = tel1+"-"+tel2+"-"+tel3;
   	 }
   	 if(tel5 != "" || tel6 != ""){
    	 if(!regTel.test(co_tel)) {
    		 alert("회사 연락처를 형식(000-0000-0000)에 맞도록 작성해주세요.");
    		 myform.tel5.focus();
    		 return false;
    	 }
   	 }
   	 else {
   		 tel5 = " ";
   		 tel6 = " ";
   		 co_tel = tel4+"-"+tel5+"-"+tel6;
   	 }
   	
   	 // 개인 주소
   	 let postcode = myform.postcode.value + " ";
   	 let roadAddress = myform.roadAddress.value + " ";
   	 let detailAddress = myform.detailAddress.value + " ";
   	 let extraAddress = myform.extraAddress.value + " ";
   	 let address = postcode+"/"+roadAddress+"/"+detailAddress+"/"+extraAddress;
   	
   	 // 회사 주소
   	 let co_postcode = myform.co_postcode.value + " ";
   	 let co_roadAddress = myform.co_roadAddress.value + " ";
   	 let co_detailAddress = myform.co_detailAddress.value + " ";
   	 let co_extraAddress = myform.co_extraAddress.value + " ";
   	 let co_address = co_postcode+"/"+co_roadAddress+"/"+co_detailAddress+"/"+co_extraAddress;
   	
   	 // 뉴스레터 구독여부 확인
   	 let emailNewsCheck = $('input[id=emailNews]').is(':checked');
   	 if(!emailNewsCheck) myform.emailNews.value = 'NO';
   	 
   	 // 회원 가입 전 체크
   	 if(idCheckSw == 0){
   		 alert("아이디 중복 체크를 수행해주세요.");
   		 document.getElementById("midBtn").focus();
   	 }
   	 else if(nickCheckSw == 0) {
   		 alert("닉네임 중복 체크를 수행해주세요.");
   		 document.getElementById("nickNameBtn").focus();
   	 }
   	 else {
   		 myform.email.value = email; // email 결합
   		 myform.tel.value = tel;
   		 myform.co_tel.value = co_tel;
   		 myform.address.value = address;
   		 myform.co_address.value = co_address;
   		
   		/* 값 넘어왔는지 확인하는 과정
   		let su = "";
   		let checkedValues = [];
   		let checkboxes = document.getElementsByName("purpose");
			alert(checkboxes);
   		for (let i = 0; i < checkboxes.length; i++) {
   		    if (checkboxes[i].checked) {
   		        su += checkboxes[i].value; // value를 숫자로 변환하여 더하기
   		        checkedValues.push(checkboxes[i].value); // 체크된 값들을 배열에 추가
   		    }
   		}

   		alert("su: " + su);
   		alert("Checked values: " + checkedValues.join(", "));
   		*/
   		
   		myform.submit();
   	 }
    }
   
    // 아이디 중복체크
    function idCheck() {
   	 let regMid = /^[a-zA-Z0-9_]{4,20}$/;
   	 let mid = myform.mid.value;
   	 if(mid.trim() == "") {
   		 alert("아이디를 입력하세요.");
   		 myform.mid.focus();
   	 }
   	 else if(!regMid.test(mid)){
   		 alert("아이디는 영문 대/소문자와 숫자, 밑줄을 포함하여 4~20자까지 가능합니다.");
   		 document.getElementById("mid").focus();
   	 }
   	 else {
   		 idCheckSw = 1;
   		 $.ajax({
   			 url: "${ctp}/member/memberIdCheck",
   			 type: "get",
   			 data: {mid:mid},
   			 success: function(res) {
   				 if(res != "0") {
   					 alert("이미 사용중인 아이디 입니다. 다시 입력하세요.");
   					 idCheckSw = 0;
   					 myform.mid.focus();
   				 }
   				 else {
   					 alert("사용 가능한 아이디 입니다.");
   					 $("#midBtn").attr("disabled",true);
   				 }
   			 },
   			 error : function() {
   				 alert("전송 오류");
   			 }
   		 });
   	 }
    }
   
    // 닉네임 중복체크
    function nickCheck() {
   	 let nickName = document.getElementById("nickName").value.trim();
   	 let regNickName = /^[a-zA-Z0-9가-힣]{2,10}$/;
   	 if(nickName.trim() == "") {
   		 alert("닉네임을 입력하세요.");
   		 myform.nickName.focus();
   	 }
   	 else if(!regNickName.test(nickName)){
   		 alert("닉네임은 영문과 한글, 숫자만 사용하여 2~10자까지 가능합니다.");
   		 document.getElementById("nickName").focus();
   	 }
   	 else {
   		 nickCheckSw = 1;
   		 $.ajax({
   			 url: "${ctp}/member/memberNickCheck",
   			 type: "get",
   			 data: {nickName:nickName},
   			 success: function(res) {
   				 if(res != "0") {
   					 alert("이미 사용중인 닉네임 입니다. 다시 입력하세요.");
   					 nickCheckSw = 0;
   					 myform.nickName.focus();
   				 }
   				 else {
   					 alert("사용 가능한 닉네임 입니다.");
   					 $("#nickNameBtn").attr("disabled",true);
   				 }
   			 },
   			 error : function() {
   				 alert("전송 오류");
   			 }
   		 });
   	 }
    }
   
    // 입력창 누르면 스위치 리셋...?
    window.onload = function(){
   	 mid.addEventListener('click',function(){
   		 idCheckSw = 0;
   		 $("#midBtn").removeAttr("disabled");
   	 });
   	 nickName.addEventListener('click',function(){
   		 nickCheckSw = 0;
   		 $("#nickNameBtn").removeAttr("disabled");
   	 });
    }
	</script>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<p><br/></p>
<div class="container">
<div class="row justify-content-center">
<div class="col-xl-6 col-lg-8">
	<form name="myform" method="post" class="was-validated">
    <h2 class="text-center">회 원 가 입</h2>
    <br/>
    <div class="form-group">
      <label for="name">이름 :</label>
      <input type="text" class="form-control" id="name" placeholder="이름을 입력하세요." name="name" required autofocus />
    </div>
    <div class="form-group">
      <label for="mid">아이디 : &nbsp; &nbsp;<input type="button" value="아이디 중복체크" id="midBtn" class="btn btn-main-2 btn-round-full btn-icon-sm" onclick="idCheck()"/></label>
      <input type="text" class="form-control text-sm" name="mid" id="mid" placeholder="아이디를 입력하세요." required />
    </div>
    <div class="form-group">
      <label for="pwd">비밀번호 :</label>
      <input type="password" class="form-control" id="pwd" placeholder="비밀번호를 입력하세요." name="pwd" required />
    </div>
    <div class="form-group">
      <label for="mid">닉네임 : &nbsp; &nbsp;<input type="button" value="닉네임 중복체크" id="nickNameBtn" class="btn btn-main-2 btn-round-full btn-icon-sm" onclick="nickCheck()"/></label>
      <input type="text" class="form-control text-sm" name="nickName" id="nickName" placeholder="닉네임을 입력하세요." required />
    </div>
    <div class="form-group">
      <label for="email1">E-mail address: &nbsp;&nbsp;</label>
        <div class="form-check-inline">
	        <label class="form-check-label" style="font-size:13px">
	          <input type="checkbox" class="form-check-input" value="OK" name="emailNews" id="emailNews" checked/>뉴스레터 구독하기
	        </label>
      	</div>
        <div class="input-group mb-3">
          <input type="text" class="form-control" placeholder="E-mail을 입력하세요." id="email1" name="email1" required />
          <select name="email2" class="form-control" style="height:auto">
            <option value="naver.com" selected>naver.com</option>
            <option value="gmail.com">gmail.com</option>
            <option value="hanmail.net">hanmail.net</option>
            <option value="daum.net">daum.net</option>
            <option value="nate.com">nate.com</option>
            <option value="yahoo.com">yahoo.com</option>
            <option value="korea.com">korea.com</option>
          </select>
        </div>
    </div>
    <div class="form-group">
      <label for="birthday">생일</label>
      <input type="date" name="birthday" value="<%=java.time.LocalDate.now() %>" class="form-control"/>
    </div>
    <div class="form-group-2">
      <div class="input-group mb-3">
        <div class="input-group-prepend">
          <span class="input-group-text">전화번호 :</span> &nbsp;&nbsp;
            <select name="tel1" class="custom-select" style="height:auto">
              <option value="010" selected>010</option>
              <option value="02">02</option>
              <option value="031">031</option>
              <option value="032">032</option>
              <option value="041">041</option>
              <option value="042">042</option>
              <option value="043">043</option>
              <option value="051">051</option>
              <option value="052">052</option>
              <option value="061">061</option>
              <option value="062">062</option>
            </select>-
        </div>
        <input type="text" name="tel2" size=4 maxlength=4 class="form-control"/>-
        <input type="text" name="tel3" size=4 maxlength=4 class="form-control"/>
      </div>
    </div>
    <div class="form-group">
      <label for="address">주소</label>
      <div class="input-group mb-1">
        <input type="text" name="postcode" id="sample6_postcode" placeholder="우편번호" class="form-control">
        <div class="input-group-append">
          <input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기" class="btn btn-main-2 btn-round btn-icon-sm">
        </div>
      </div>
      <input type="text" name="roadAddress" id="sample6_address" size="50" placeholder="주소" class="form-control mb-1">
      <div class="input-group mb-1">
        <input type="text" name="detailAddress" id="sample6_detailAddress" placeholder="상세주소" class="form-control"> &nbsp;&nbsp;
        <div class="input-group-append">
          <input type="text" name="extraAddress" id="sample6_extraAddress" placeholder="참고항목" class="form-control">
        </div>
      </div>
    </div>
    <div class="form-group">
      <div class="form-check-inline">
        <span class="input-group-text">분류 :</span> &nbsp; &nbsp;
        <label class="form-check-label">
          <input type="radio" class="form-check-input" name="m_group" value="개인" onclick="companyHide()" checked>개인
        </label>
      </div>
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="radio" class="form-check-input" name="m_group" onclick="companyShow()" value="재직자">재직자
        </label>
      </div>
      <div id="personMent" class="text-center" style="font-size:13px">개인 고객의 경우 일부 물품 구매가 제한될 수 있습니다.</div>
    </div>
    <div id="company">
	    <div class="form-group">
	      <label for="co_name">회사명</label>
	      <input type="text" class="form-control" name="co_name" placeholder="재직 중인 회사명을 입력하세요." id="co_name"/>
	    </div>
	    <div class="form-group">
	      <label for="name">업종을 선택하세요.</label>
	      <select class="form-control" id="co_category" name="co_category">
	        <option>바이오 및 제약</option>
	        <option>에너지 및 화학</option>
	        <option>식품 및 음료</option>
	        <option>환경</option>
	        <option>임상 진단</option>
	        <option>재료연구</option>
	        <option>세포분석</option>
	        <option>학교 연구실</option>
	        <option selected>기타</option>
	      </select>
	    </div>
	    <div class="form-group">
	      <label for="co_address">회사 소재지</label>
	      <div class="input-group mb-1">
	        <input type="text" name="co_postcode" id="sample6_postcode2" placeholder="우편번호" class="form-control">
	        <div class="input-group-append">
	          <input type="button" onclick="sample6_execDaumPostcode2()" value="우편번호 찾기" class="btn btn-main-2 btn-round btn-icon-sm">
	        </div>
	      </div>
	      <input type="text" name="co_roadAddress" id="sample6_address2" size="50" placeholder="주소" class="form-control mb-1">
	      <div class="input-group mb-1">
	        <input type="text" name="co_detailAddress" id="sample6_detailAddress2" placeholder="상세주소" class="form-control"> &nbsp;&nbsp;
	        <div class="input-group-append">
	          <input type="text" name="co_extraAddress" id="sample6_extraAddress2" placeholder="참고항목" class="form-control">
	        </div>
	      </div>
	    </div>
	    <div class="form-group">
	      <div class="input-group mb-3">
	        <div class="input-group-prepend">
	          <span class="input-group-text">회사연락처 :</span> &nbsp;&nbsp;
	            <select name="tel4" class="custom-select" style="height:auto">
	              <option value="010" selected>010</option>
	              <option value="02">02</option>
	              <option value="031">031</option>
	              <option value="032">032</option>
	              <option value="041">041</option>
	              <option value="042">042</option>
	              <option value="043">043</option>
	              <option value="051">051</option>
	              <option value="052">052</option>
	              <option value="061">061</option>
	              <option value="062">062</option>
	              <option value="070">070</option>
	            </select>-
	        </div>
	        <input type="text" name="tel5" size=4 maxlength=4 class="form-control"/>-
	        <input type="text" name="tel6" size=4 maxlength=4 class="form-control"/>
	      </div>
	    </div>
    </div>
    <div class="form-group">
      <div class="form-check-inline">
        <span class="input-group-text">가입 목적</span> &nbsp;
        <label class="form-check-label">
          <input type="checkbox" class="form-check-input" value="실험정보" name="purpose"/>실험정보
        </label>
      </div>
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="checkbox" class="form-check-input" value="기기구매" name="purpose"/>기기구매
        </label>
      </div>
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="checkbox" class="form-check-input" value="AS신청" name="purpose"/>AS신청
        </label>
      </div>
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="checkbox" class="form-check-input" value="채용공고" name="purpose"/>채용공고
        </label>
      </div>
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="checkbox" class="form-check-input" value="기타" name="purpose" checked/>기타
        </label>
      </div>
    </div>
    <hr/>
    <div class="text-center">
	    <button type="button" class="btn btn-main-2 btn-round-full btn-icon" onclick="fCheck()">회원가입</button> &nbsp;
	    <button type="reset" class="btn btn-main btn-round-full btn-icon">다시작성</button> &nbsp;
	    <button type="button" class="btn btn-main btn-round-full btn-icon" onclick="location.href='${ctp}/';">돌아가기</button>
    </div>
    <input type="hidden" name="email" />
    <input type="hidden" name="tel" />
    <input type="hidden" name="address" />
    <input type="hidden" name="co_tel" />
    <input type="hidden" name="co_address" />
  </form>
</div>
</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<!--<jsp:include page="/WEB-INF/views/include/scripts.jsp" />-->
</body>
</html>