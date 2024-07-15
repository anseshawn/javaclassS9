<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 판매기기 등록</title>
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
    .proType {
      padding: 10px 20px;
      border: none;
      background-color: #C7C3BB;
      color: #fff;
      cursor: pointer;
    }

    .proType.act {
      background-color: #0E2B5E;
      color: white;
    }
	</style>
	<script>
		'use strict';
		
		window.onload = function(){
			document.getElementById("demoImg").src = "${ctp}/images/noimage2.png";
		}
		
		var selectedBtnP = null;
    function proTypeSelect(button) {
    	if(selectedBtnP) {
    		selectedBtnP.classList.remove("act");
    	}
    	button.classList.add("act");
    	selectedBtnP = button;
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
			let proName = myform.proName.value;
			let proMade = myform.proMade.value;
			let proYear = myform.proYear.value;
			let proPrice = myform.proPrice.value;
			
			if(selectedBtnP==null) {
				alert("기기 분류를 선택하세요.");
				return false;
			}
			if(proName.trim()=="" || proMade.trim()=="" || proYear.trim()=="" || proPrice.trim()=="") {
				alert("모델명, 제조사, 제조년도, 가격은 필수 입력값입니다.");
				return false;
			}
			let proType = selectedBtnP.value;
			document.getElementById("proType").value = proType;
			myform.submit();
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
<div class="spinner-border text-muted" id="spinner" style="display:none;"></div>
	<div class="text-center"><h2>기기 등록</h2></div>
	<div class="divider2 mx-auto my-4 text-center" style="width:70%;"></div>
	<form name="myform" method="post" class="was-validated" enctype="multipart/form-data">
		<div class="row justify-content-center mb-3">
			<div class="col-md-2 col-md-offset-2">
				<div><img id="demoImg" width="200px"/></div>
				<input type="file" name="fName" id="file" onchange="imgCheck(this)" class="form-control-file borderless mt-3"/>
			</div>
			<div class="col-md-6">
				<div class="row justify-content-center mb-3">
					<div class="col-md-10 offset-md-2"><h4>분류</h4>
						<input type="button" class="proType btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="proType" value="UV" onclick="proTypeSelect(this)"/>
						<input type="button" class="proType btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="proType" value="AAs" onclick="proTypeSelect(this)"/>
						<input type="button" class="proType btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="proType" value="ICP" onclick="proTypeSelect(this)"/>
						<input type="button" class="proType btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="proType" value="GC" onclick="proTypeSelect(this)"/>
						<input type="button" class="proType btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="proType" value="LC" onclick="proTypeSelect(this)"/>
						<input type="button" class="proType btn btn-main btn-icon-md btn-round-full mb-2" name="proType" value="etc" onclick="proTypeSelect(this)"/>
					</div>
				</div>
				<div class="row mb-3">
					<div class="col-md-10 offset-md-2">
						<h4 class="text-left">모델명</h4>
						<input type="text" name="proName" id="proName" class="form-control" placeholder="장비의 모델명을 입력하세요" required/>
					</div>
				</div>
				<div class="row mb-3">
					<div class="col-md-10 offset-md-2">
						<h4 class="text-left">제조사</h4>
						<input type="text" name="proMade" id="proMade" class="form-control" placeholder="제조사를 입력하세요" required/>
					</div>
				</div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-10 offset-md-2"><h4>제조년도</h4>
		        <input type="number" name="proYear" id="proYear" placeholder="장비 제조년도를 입력하세요" class="form-control" required >
					</div>
				</div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-10 offset-md-2"><h4>가격</h4>
		        <input type="number" name="proPrice" id="proPrice" placeholder="(판매 페이지에는 노출되지 않습니다)" class="form-control" required>
					</div>
				</div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-10 offset-md-2"><h4>기타 내용</h4>
						<textarea rows="5" name="etcDetail" id="etcDetail" class="form-control"></textarea>
					</div>
				</div>
			</div>
		</div>

		<div class="divider2 mx-auto my-4 text-center" style="width:70%;"></div>
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2 text-center">
				<input type="button" value="등록하기" onclick="fCheck()" class="btn btn-main btn-icon btn-round-full mr-2" />
				<input type="button" value="취소" onclick="location.href='${ctp}/admin/adminMain';" class="btn btn-main-3 btn-icon btn-round-full" />
			</div>
		</div>
		<input type="hidden" name="proType" id="proType">
	</form>
</div>

</body>
</html>