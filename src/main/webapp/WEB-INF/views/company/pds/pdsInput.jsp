<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>글쓰기 - 자료실</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<script>
		'use strict';
		
		function fCheck(){
			let title = $("#title").val();
			let content = $("#content").val();
			
			if(title.trim()=="") {
				alert("제목을 입력하세요.");
				myform.title.focus();
				return false;
			}
			else if(content.trim()==""){
				alert("내용을 입력하세요.");
				myform.content.focus();
				return false;
			}
			
  		let fName = document.getElementById("fName").value;
  		let maxSize = 1024 * 1024 * 10; // 기본 단위 : Byte, 1024 * 1024: Mb, 1024*1024*10 = 10MByte 허용
  		
  		if(fName.trim() != "") {
	  		let ext = fName.substring(fName.lastIndexOf(".")+1).toLowerCase(); // 확장자 부분만 뽑아서 소문자로
	  		let fileSize = document.getElementById("fName").files[0].size;
	  		if(fileSize > maxSize) {
	  			alert("업로드할 파일의 최대용량은 10MByte입니다.");
	  			return false;
	  		}
	  		else if(ext != 'jpg' && ext != 'gif' && ext != 'png' && ext != 'zip' && ext != 'hwp' && ext != 'doc' && ext != 'pdf' && ext != 'ppt' && ext != 'pptx') {
	  			alert("업로드 가능한 파일은 '그림파일(jpg/gif/png) 및 pdf/zip/hwp/doc' 입니다.");
	  			return false;
	  		}
	  		else if(fName.includes("/")) {
	  			alert("파일명에 슬래시('/')가 들어갈 수 없습니다. 파일명을 변경해주세요.");
	  			return false;
	  		}
  		}
			
			myform.submit();
		}
	</script>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<p><br/></p>
<div class="container">
<form name="myform" method="post" enctype="multipart/form-data">
	<div class="row justify-content-center mb-2">
		<div class="col-md-8 col-md-offset-2">
			<div class="form-group">
				<input type="text" name="board" id="board" class="form-control" value="자료실" readonly />
			</div>
		</div>
	</div>
	<div class="row justify-content-center mb-2">
		<div class="col-md-8">
			<input type="text" name="writer" id="writer" class="form-control" value="${sNickName} (${sMid})" readonly />		
		</div>
	</div>
	<div class="divider2 mx-auto my-4"></div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-8 col-md-offset-2"><h4>제목</h4>
			<input type="text" name="title" id="title" class="form-control mt-2" placeholder="제목을 입력하세요" required/>
		</div>
	</div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-8 col-md-offset-2"><h4>내용</h4>
			<textarea name="content" id="content" rows="10" class="form-control"></textarea>
		</div>
	</div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-8 col-md-offset-2">
			<label>첨부파일(이름에 '/'가 들어간 파일은 업로드 할 수 없습니다)</label>
			<input type="file" name="file" id="fName" class="form-control-file border mb-2" multiple style="float:left;" accept=".jpg,.gif,.png,.zip,.pdf,.ppt,.pptx,.hwp,.doc" />
		</div>
	</div>
	<div class="divider2 mx-auto my-4"></div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-8 col-md-offset-2 text-right">
			<input type="button" value="등록하기" onclick="fCheck()" class="btn btn-main-2 btn-icon btn-round-full" />
			<a href="${ctp}/company/pds/pdsList?pag=${pageVO.pag}&pageSize=${pageVO.pageSize}" class="btn btn-main btn-icon btn-round-full">취소</a>
		</div>
	</div>
	<input type="hidden" name="mid" value="${sMid}"/>
</form>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>