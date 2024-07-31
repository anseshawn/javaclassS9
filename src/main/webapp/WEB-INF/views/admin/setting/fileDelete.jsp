<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>임시파일 관리</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
	<script>
		'use strict';
		
		function allSelect(){
  		if(document.getElementById("allSelect").checked){
	  		for(let i=0; i<${fileCount}; i++) {
	  			document.getElementsByName("selectFile")[i].checked = true;
	  		}  			
  		}
  		else {
	  		for(let i=0; i<${fileCount}; i++) {
	  			document.getElementsByName("selectFile")[i].checked = false;
	  		}  
  		}
		}
		
		function selectDelete() {
			let fileName = "";
			let cnt = 0;
			for(let i=0; i<document.getElementsByName("selectFile").length; i++) {
				if(document.getElementsByName("selectFile")[i].checked) {
					cnt++;
					fileName += document.getElementsByName("selectFile")[i].value+",";
				}
			}
			if(cnt==0) {
				alert("삭제할 파일을 선택하세요.");
				return false;
			}
			fileName = fileName.substring(0,fileName.length-1);
			let ans = confirm("선택한 파일을 모두 삭제하시겠습니까?");
			if(!ans) return false;
			$.ajax({
				url: "${ctp}/admin/setting/fileDeleteAll",
				type: "post",
				data: {fileName : fileName},
				success: function(res) {
					if(res != 0) {
						alert("선택한 파일이 삭제 되었습니다.");
						location.reload();
					}
					else alert("삭제 실패.");
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
		
		function fileDelete(file){
			let ans = confirm("해당 파일을 삭제하겠습니까?");
			if(!ans) return false;
			$.ajax({
				url: "${ctp}/admin/setting/fileDelete",
				type: "post",
				data: {file : file},
				success: function(res) {
					if(res != 0) {
						alert("파일이 삭제 되었습니다.");
						location.reload();
					}
					else alert("파일 삭제 실패");
				},
				error: function() {
					alert("전송오류");
				}
			});
		}
		
		function modalView(file) {
			let fNameArray = file.split(".");
			let extName = fNameArray[fNameArray.length-1].toLowerCase();
			let ext = "";
			if(extName=='zip') ext="압축파일";
			else if(extName=='ppt' || extName=='pptx') ext="PPT 파일";
			else if(extName=='hwp') ext="한글파일";
			else if(extName=='txt') ext="메모장파일";
			else if(extName=='pdf') ext="PDF 파일";
			else if(extName=='doc') ext="워드파일";
			else if(extName=='jpg' || extName=='png' || extName=='gif') ext="그림파일";
			
			let str = "<table class='table'>";
			str += "<tr><td>"+file+"</td>";
			str += "<td>"+ext+"</td>";
			str += "</tr>";
			if(extName=='jpg' || extName=='png' || extName=='gif'){
				str += "<tr><td colspan='2'>";
				str += '<img src="${ctp}/data/ckeditor/'+file+'" width="300px"/>';
				str += "</td></tr>";
			}
			str += "</table>";
			$("#content").html(str);
		}
			
	</script>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
	<h3>임시 파일 관리</h3>
	<div>용량 관리를 위해 임시 파일을 삭제해주세요.</div>
	<div class="divider2 mx-auto my-4 text-center" style="width:100%;"></div>
	<div class="row mb-2">
		<div class="col text-left">
			<div>총 ${fileCount}건</div>
		</div>
		<div class="col text-right">
			<div class="text-right"><input type="button" value="선택삭제" onclick="selectDelete()" class="btn btn-main-2 btn-icon-sm btn-round"/></div>
		</div>
	</div>
	<table class="table text-center">
		<tr>
			<th><input type="checkbox" name="allSelect" id="allSelect" onclick="allSelect()" class="custom-conrol-input"/></th>
			<th>번호</th>
			<th>파일명</th>
			<th>파일확인</th>
			<th>삭제</th>
		</tr>
		<c:forEach var="file" items="${files}" varStatus="st">
			<tr>
				<td>
					<form name="selectForm">
						<input type="checkbox" name="selectFile" id="selectFile${st.index}" value="${file}" />
					</form>
				</td>
				<td>${st.count}</td>
				<td>${file}</td>
				<td>
					<a href="#" onclick="modalView('${file}')" data-toggle="modal" data-target="#myModal" class="btn btn-main btn-icon-sm">파일확인</a>
				</td>
				<td><input type="button" value="삭제" onclick="fileDelete('${file}')" class="btn btn-main-3 btn-icon-sm" /></td>
			</tr>
		</c:forEach>
	</table>
</div>

<!-- 파일 미리보기 모달에 출력하기 -->
<div class="modal fade" id="myModal">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
    
      <!-- Modal Header -->
      <div class="modal-header text-center">
        <h4 class="modal-title">파일 미리보기</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      <!-- Modal body -->
      <div class="modal-body">
    		<span id="content"></span>
      </div>
      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
      
    </div>
  </div>
</div>

<p><br/></p>
</body>
</html>