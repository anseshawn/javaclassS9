<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 이메일 보내기</title>
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
	<style>
		#spinner {
		  position: absolute;
		  left: 50%;
		  top: 50%;
		  z-index: 1;
		}
    .place, .instrument {
      padding: 10px 20px;
      border: none;
      background-color: #C7C3BB;
      cursor: pointer;
    }

    .place.act, .instrument.act {
      background-color: #0E2B5E;
      color: white;
    }
	</style>
	<script>
		'use strict';
		
		window.onload = function(){
			document.getElementById("demoImg").src = "${ctp}/images/noimage.jpg";
			mid.addEventListener('click',function(){
			 idCheckSw = 0;
			 $("#midBtn").removeAttr("disabled");
			});
		}
		
    function toggleAct(button) {
    	button.classList.toggle("act");
    }
		// 사진 선택시 미리보기
    function imgCheck(e) {
    	if(e.files && e.files[0]) {
    		let reader = new FileReader();
    		reader.onload = function(e) {
    			document.getElementById("demoImg").src = e.target.result;
    		}
    		reader.readAsDataURL(e.files[0]);
    	}
    }
		
    let idCheckSw = 0;
		function fCheck() {
			let mid = document.getElementById("mid").value.trim();
			let pwd = document.getElementById("pwd").value.trim();
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
			else if(email1 == "") {
				alert("이메일을 입력하세요");
				myform.email1.focus();
				return false;
			}
			
			let regPwd = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[\W_]).{4,20}$/; 
			let regName = /^[a-zA-Z가-힣]{2,10}$/; 
			let regEmail = /^[a-zA-Z0-9]([-_]?[a-zA-Z0-9])*$/i;
			let regTel = /\d{2,3}-\d{3,4}-\d{4}$/;
			
			/*
			if(!regPwd.test(pwd)) {
				alert("비밀번호는 영문 대/소문자와 숫자, 특수문자를 포함하여 4~20자까지 가능합니다. 특수문자를 꼭 1개 이상 포함해주세요.");
				document.getElementById("pwd").focus();
				return false;
			}
			*/
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
						
			let email2 = myform.email2.value;
			let email = email1+"@"+email2;
			let tel1 = myform.tel1.value;
			let tel2 = myform.tel2.value.trim();
			let tel3 = myform.tel3.value.trim();
			let tel = tel1+"-"+tel2+"-"+tel3;
			
			if(!regTel.test(tel)) {
				alert("연락처를 형식(000-0000-0000)에 맞도록 작성해주세요.");
				myform.tel2.focus();
				return false;
	    }
			
			// 선택된 버튼 값 모으기
			let places = document.querySelectorAll('.place.act');
			let placeValues = Array.from(places).map(button => button.value);
			//alert(placeValues);
			// hidden input 값 갱신
      let placeInput = document.getElementById('place');
      placeInput.value = placeValues.join(',');
      
			let instruments = document.querySelectorAll('.instrument.act');
			let instrumentValues = Array.from(instruments).map(button => button.value);
			//alert(instrumentValues);
			// hidden input 값 갱신
      let instrumentInput = document.getElementById('instrument');
      instrumentInput.value = instrumentValues.join(',');
      
      if(placeInput.value.trim()=="" || instrumentInput.value.trim()==""){
    	  alert("담당 지역 및 기기는 필수 입력값입니다.");
    	  return false;
      }
			
    	// 이미지 등록 시키기(파일에 관련된 사항들 체크)
    	let fName = document.getElementById("file").value;
    	if(fName.trim() != null && fName.trim() != "") {
	    	let ext = fName.substring(fName.lastIndexOf(".")+1).toLowerCase();
	    	let maxSize = 1024 * 1024 * 2;
	    	let fileSize = document.getElementById("file").files[0].size;
    		
	    	if(ext != 'jpg' && ext != 'png' && ext != 'gif' && ext != 'jpeg') {
	    		alert("사진 파일(jpg/png/gif/jpeg)만 등록 가능합니다.");
	    		return false;
	    	}
	    	else if(fileSize > maxSize) {
	    		alert("사진의 최대 용량은 2MByte 입니다.");
	    		return false;
	    	}
    	}
    	
			if(idCheckSw == 0){
			 alert("아이디 중복 체크를 수행해주세요.");
			 document.getElementById("midBtn").focus();
			}
			else {
				myform.email.value = email; // email 결합
				myform.tel.value = tel;
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
   			 url: "${ctp}/admin/engineer/engineerIdCheck",
   			 type: "post",
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
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
<div class="spinner-border text-muted" id="spinner" style="display:none;"></div>
	<div class="text-center"><h2>엔지니어 등록</h2></div>
	<div class="divider2 mx-auto my-4 text-center" style="width:70%;"></div>
	<form name="myform" method="post" class="was-validated" enctype="multipart/form-data">
		<div class="row justify-content-center mb-3">
			<div class="col-md-3 col-md-offset-2">
				<div><img id="demoImg" width="200px"/></div>
				<input type="file" name="fName" id="file" onchange="imgCheck(this)" class="form-control-file borderless mt-3"/>
			</div>
			<div class="col-md-5 text-center">
				<div class="row mb-3">
					<div class="col-md-10 offset-md-2">
						<h4 class="text-left">이름</h4>
						<input type="text" name="name" id="name" class="form-control" placeholder="이름을 입력하세요" required/>
					</div>
				</div>
				<div class="row mb-3">
					<div class="col-md-10 offset-md-2">
						<div class="input-group mb-2">
							<h4 class="text-left">아이디</h4>&nbsp;
							<input type="button" value="아이디 중복체크" id="midBtn" class="btn btn-main-2 btn-round-full btn-icon-sm" style="padding: 1px 0.2rem;" onclick="idCheck()"/>
						</div>
						<input type="text" name="mid" id="mid" class="form-control" placeholder="아이디를 입력하세요" required/>
					</div>
				</div>
				<div class="row">
					<div class="col-md-10 offset-md-2">
						<h4 class="text-left">비밀번호</h4>
						<input type="text" name="pwd" id="pwd" class="form-control" placeholder="초기 비밀번호: 1234" required/>
					</div>
				</div>
			</div>
		</div>
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2"><h4>연락처</h4>
				<div class="input-group mb-3">
	        <input type="text" name="tel1" value="010" class="form-control" readonly>-
	        <input type="text" name="tel2" size=4 maxlength=4 class="form-control" required/>-
	        <input type="text" name="tel3" size=4 maxlength=4 class="form-control" required/>
	      </div>
			</div>
		</div>
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2"><h4>이메일</h4>
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
		</div>
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2"><h4>출장 가능 지역</h4>
				<div id="comment" class="text-left" style="font-size:13px">출장 가능한 지역을 모두 선택해주세요.</div>
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="서울" onclick="toggleAct(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="인천" onclick="toggleAct(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="부산" onclick="toggleAct(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="대구" onclick="toggleAct(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="광주" onclick="toggleAct(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="대전" onclick="toggleAct(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="울산" onclick="toggleAct(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="세종" onclick="toggleAct(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="경기" onclick="toggleAct(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="강원" onclick="toggleAct(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="충북" onclick="toggleAct(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="충남" onclick="toggleAct(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="전북" onclick="toggleAct(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="전남" onclick="toggleAct(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="경북" onclick="toggleAct(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="경남" onclick="toggleAct(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" value="제주" onclick="toggleAct(this)">
			</div>
		</div>
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2"><h4>담당기기</h4>
				<input type="button" class="instrument btn btn-main btn-icon-md btn-round-full mr-2" name="instrument" value="UV" onclick="toggleAct(this)"/>
				<input type="button" class="instrument btn btn-main btn-icon-md btn-round-full mr-2" name="instrument" value="AAs" onclick="toggleAct(this)"/>
				<input type="button" class="instrument btn btn-main btn-icon-md btn-round-full mr-2" name="instrument" value="ICP" onclick="toggleAct(this)"/>
				<input type="button" class="instrument btn btn-main btn-icon-md btn-round-full mr-2" name="instrument" value="GC" onclick="toggleAct(this)"/>
				<input type="button" class="instrument btn btn-main btn-icon-md btn-round-full mr-2" name="instrument" value="LC" onclick="toggleAct(this)"/>
				<input type="button" class="instrument btn btn-main btn-icon-md btn-round-full mr-2" name="instrument" value="etc" onclick="toggleAct(this)"/>
			</div>
		</div>
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2"><h4>입사일</h4>
				<input type="date" name="joinDate" value="<%=java.time.LocalDate.now() %>" class="form-control"/>
			</div>
		</div>
		<div class="divider2 mx-auto my-4 text-center" style="width:70%;"></div>
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2 text-center">
				<input type="button" value="등록하기" onclick="fCheck()" class="btn btn-main-2 btn-icon btn-round-full mr-3" />
				<input type="button" value="취소" onclick="location.href='${ctp}/admin/adminMain';" class="btn btn-main btn-icon btn-round-full" />
			</div>
		</div>
		<input type="hidden" name="email" />
		<input type="hidden" name="tel" />
		<input type="hidden" name="place" id="place">
		<input type="hidden" name="instrument" id="instrument">
	</form>
</div>

</body>
</html>