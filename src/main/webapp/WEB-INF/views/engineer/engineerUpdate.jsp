<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>내 정보 관리 - 사원</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp" />
  <style>
  	.place, .machine {
      padding: 10px 20px;
      border: none;
      background-color: #C7C3BB;
      cursor: pointer;
    }

    .place.act, .machine.act {
      background-color: #0E2B5E;
      color: white;
    }
    
    .place:disabled, .machine:disabled {
    	border: none;
      background-color: #C7C3BB;
      pointer-events: none;
      cursor: none;
    }
  </style>
	<script>
		'use strict';
		
		window.onload = function(){
			document.getElementById("demoImg").src = "${ctp}/engineer/${vo.photo}";
			for(let i=1; i<=17; i++) {
		  	let engineerPlace = '${vo.place}';
	      if(engineerPlace.includes($("#place"+i).val())){
	    	  $("#place"+i).addClass("act");
	      }
	      else {
	    	  $("#place"+i).removeClass("act");
	    	  $("#place"+i).attr("disabled",true);
	      }
			}
			for(let i=1; i<=6; i++) {
		  	let engineerMachine = '${vo.machine}';
	      if(engineerMachine.includes($("#machine"+i).val())){
	    	  $("#machine"+i).addClass("act");
	      }
	      else {
	    	  $("#machine"+i).removeClass("act");
	    	  $("#machine"+i).attr("disabled",true);
	      }
			}

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
		
		function fCheck() {
			let email1 = myform.email1.value.trim();
			
			if(email1 == "") {
				alert("이메일을 입력하세요");
				myform.email1.focus();
				return false;
			}
			
			let regEmail = /^[a-zA-Z0-9]([-_]?[a-zA-Z0-9])*$/i;
			let regTel = /\d{2,3}-\d{3,4}-\d{4}$/;
			
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
      document.getElementById('place').value = placeValues.join(',');
      
			let machines = document.querySelectorAll('.machine.act');
			let machineValues = Array.from(machines).map(button => button.value);
      document.getElementById('machine').value = machineValues.join(',');
      
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
    	
			myform.email.value = email; // email 결합
			myform.tel.value = tel;
			myform.originPhoto.value = '${vo.photo}';
			myform.submit();
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<p><br/></p>
<div class="container">
	<div class="row">
		<div class="col-lg-3">
			<div class="bodyLeft">
				<jsp:include page="/WEB-INF/views/include/engineer_aside.jsp" />
			</div>
		</div>
		<div class="col-lg-9">
			<div class="text-center"><h2>내 정보 수정</h2></div>
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
								<input type="text" name="name" id="name" value="${vo.name}" class="form-control" readonly required/>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-md-10 offset-md-2">
								<div class="input-group mb-2">
									<h4 class="text-left">아이디</h4>&nbsp;
								</div>
								<input type="text" name="mid" id="mid" value="${vo.mid}" class="form-control" readonly required/>
							</div>
						</div>
						<div class="row">
							<div class="col-md-10 offset-md-2">
								<h4 class="text-left">비밀번호</h4>
								<a href="${ctp}/engineer/pwdChange" class="btn btn-main btn-icon-sm btn-round form-control">비밀번호 변경하기</a>
							</div>
						</div>
					</div>
				</div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-8 col-md-offset-2"><h4>연락처</h4>
						<c:set var="tel" value="${fn:split(vo.tel,'-')}"/>
						<div class="input-group mb-3">
			        <input type="text" name="tel1" value="010" class="form-control" readonly>-
			        <input type="text" name="tel2" size=4 value="${tel[1]}" maxlength=4 class="form-control" required/>-
			        <input type="text" name="tel3" size=4 value="${tel[2]}" maxlength=4 class="form-control" required/>
			      </div>
					</div>
				</div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-8 col-md-offset-2"><h4>이메일</h4>
		        <div class="input-group mb-3">
		        	<c:set var="email" value="${fn:split(vo.email, '@')}"/>
		          <input type="text" class="form-control" value="${email[0]}" placeholder="E-mail을 입력하세요." id="email1" name="email1" required />
		          <select name="email2" class="form-control" style="height:auto">
		            <option value="naver.com" ${email[1]=='naver.com' ? 'selected' : ''}>naver.com</option>
		            <option value="gmail.com" ${email[1]=='gmail.com' ? 'selected' : ''}>gmail.com</option>
		            <option value="hanmail.net" ${email[1]=='hanmail.net' ? 'selected' : ''}>hanmail.net</option>
		            <option value="daum.net" ${email[1]=='daum.net' ? 'selected' : ''}>daum.net</option>
		            <option value="nate.com" ${email[1]=='nate.com' ? 'selected' : ''}>nate.com</option>
		            <option value="yahoo.com" ${email[1]=='yahoo.com' ? 'selected' : ''}>yahoo.com</option>
		            <option value="korea.com" ${email[1]=='korea.com' ? 'selected' : ''}>korea.com</option>
		          </select>
		        </div>
					</div>
				</div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-8 col-md-offset-2"><h4>출장 가능 지역</h4>
						<div id="comment" class="text-left" style="font-size:13px">지역 및 기기 변경은 담당자에게 문의하세요.</div>
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place1" value="서울" />
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place2" value="인천" />
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place3" value="부산" />
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place4" value="대구" />
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place5" value="광주" />
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place6" value="대전" />
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place7" value="울산" />
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place8" value="세종" />
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place9" value="경기" />
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place10" value="강원"/>
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place11" value="충북"/>
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place12" value="충남"/>
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place13" value="전북"/>
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place14" value="전남"/>
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place15" value="경북"/>
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place16" value="경남"/>
						<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="place" id="place17" value="제주"/>
					</div>
				</div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-8 col-md-offset-2"><h4>담당기기</h4>
						<input type="button" class="machine btn btn-main btn-icon-md btn-round-full mr-2" name="machine" id="machine1" value="UV"/>
						<input type="button" class="machine btn btn-main btn-icon-md btn-round-full mr-2" name="machine" id="machine2" value="AAs"/>
						<input type="button" class="machine btn btn-main btn-icon-md btn-round-full mr-2" name="machine" id="machine3" value="ICP"/>
						<input type="button" class="machine btn btn-main btn-icon-md btn-round-full mr-2" name="machine" id="machine4" value="GC"/>
						<input type="button" class="machine btn btn-main btn-icon-md btn-round-full mr-2" name="machine" id="machine5" value="LC"/>
						<input type="button" class="machine btn btn-main btn-icon-md btn-round-full mr-2" name="machine" id="machine6" value="etc"/>
					</div>
				</div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-8 col-md-offset-2"><h4>입사일</h4>
						<c:set var="joinDate" value="${fn:substring(vo.joinDate,0,10)}"/>
						<input type="date" name="joinDate" value="${joinDate}" class="form-control" readonly/>
					</div>
				</div>
				<div class="divider2 mx-auto my-4 text-center" style="width:70%;"></div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-8 col-md-offset-2 text-center">
						<input type="button" value="수정하기" onclick="fCheck()" class="btn btn-main-2 btn-icon btn-round-full mr-3" />
						<input type="button" value="취소" onclick="location.href='${ctp}/engineer/myPageMain';" class="btn btn-main btn-icon btn-round-full" />
					</div>
				</div>
				<input type="hidden" name="email" />
				<input type="hidden" name="tel" />
				<input type="hidden" name="place" id="place"/>
				<input type="hidden" name="machine" id="machine"/>
				<input type="hidden" name="originPhoto" />
				<input type="hidden" name="idx" value="${vo.idx}" />
			</form>
			
		</div>
	</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>