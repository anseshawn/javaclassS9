<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 소모품 등록</title>
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
	<script>
		'use strict';
		
		function expendableDelete(categoryMain,expendableCode) {
			let ans = confirm("해당 소모품을 삭제하겠습니까?");
			if(!ans) return false;
			$.ajax({
				url: "${ctp}/admin/product/expendableDelete",
				type: "post",
				data: {
					categoryMain : categoryMain,
					expendableCode : expendableCode
				},
				success: function(res){
					if(res != 0) {
						alert("소모품 항목이 삭제되었습니다.");
						location.reload();
					}
					else alert("삭제 실패.");
				},
				error: function(){
					alert("전송 오류");
				}
			});
		}
		
		function fCheck() {
			let regCode = /\d{3}/;
			let categoryMain = myform.categoryMain.value;
			let expendableCode = myform.expendableCode.value;
			let expendableName = myform.expendableName.value;
			let price = myform.price.value;
			
			if(categoryMain.trim()==""){
				alert("분류를 선택하세요.");
				return false;
			}
			if(expendableName.trim()=="" || price.trim()=="" || expendableCode.trim()=="") {
				alert("소모품 코드와 이름, 단가는 필수 입력값입니다.");
				return false;
			}
			if(!regCode.test(expendableCode)){
				alert("코드를 올바르게 작성하세요. 소모품 코드는 숫자 세자리 입니다.");
				return false;
			}
			myform.submit();
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
<div class="spinner-border text-muted" id="spinner" style="display:none;"></div>
	<div class="text-center"><h2>소모품 등록</h2></div>
	<div class="divider2 mx-auto my-4 text-center" style="width:70%;"></div>
	<form name="myform" method="post" class="was-validated">
		<div class="row justify-content-center mb-3">
			<div class="col-md-8">
				<div class="row justify-content-center mb-3">
					<div class="col-md-5"><label for="categoryMain">분류</label>
						<select name="categoryMain" id="categoryMain" class="form-control" style="height:45px;">
							<option value="">기기 선택</option>
							<c:forEach var="main" items="${categoryMain}">
								<option value="${main}">${main}</option>
							</c:forEach>
						</select>
					</div>
					<div class="col-md-5"><label for="expendableCode">소모품코드</label>
		        <input type="text" name="expendableCode" id="expendableCode" size="3" maxlength="3" placeholder="(예: 000, 001...)" class="form-control" required/>
					</div>
				</div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-10"><h4>소모품 명</h4>
		        <input type="text" name="expendableName" id="expendableName" placeholder="소모품명을 적어주세요." class="form-control" required>
					</div>
				</div>
				<div class="row justify-content-center mb-3">
					<div class="col-md-10"><h4>단가</h4>
		        <input type="number" name="price" id="price" placeholder="단가를 적어주세요." class="form-control" required>
					</div>
				</div>
			</div>
		</div>

		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2 text-center">
				<input type="button" value="등록하기" onclick="fCheck()" class="btn btn-main btn-icon-md btn-round-full mr-2" />
				<input type="button" value="취소" onclick="location.href='${ctp}/admin/adminMain';" class="btn btn-main-3 btn-icon-md btn-round-full" />
			</div>
		</div>
	</form>
	<hr/>
	<div class="row justify-content-center mb-3">
		<div class="col-md-8">
			<table class="table table-hover text-center m-3">
				<tr style="pointer-events: none; background:#223a66; color:#fff;">
					<th>기기</th>
					<th>소모품코드</th>
					<th>소모품명</th>
					<th>단가</th>
					<th>삭제</th>
				</tr>
				<c:forEach var="vo" items="${vos}" varStatus="st">
					<tr>
						<td>${vo.categoryMain}</td>
						<td>${vo.expendableCode}</td>
						<td>${vo.expendableName}</td>
						<td><fmt:formatNumber value="${vo.price}" pattern="#,###"/></td>
						<td><input type="button" value="삭제" onclick="expendableDelete('${vo.categoryMain}','${vo.expendableCode}')" class="btn btn-main-3 btn-icon-sm"/></td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
</div>

</body>
</html>