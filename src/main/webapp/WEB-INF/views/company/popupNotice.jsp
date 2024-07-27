<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${vo.title}</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<style>
		img {
	    max-width: 100%;
	    height: auto;
		}
	</style>
	<script>
		'use strict';
		
		$(function(){ // 우선은 내용 대신 이미지 먼저 출력...
			let images = $("#content").find('img');
			if(images.length > 0) {
				$("#content").empty();
				for(let i=0; i<images.length; i++) {
					let img = $("<img>");
					img.attr('src',images[i].src);
					//img.css('max-width','100%');
					$("#content").append(img);
				}
			}
		});
		
		function showContent() {
			opener.location.href="${ctp}/company/noticeContent?idx=${vo.idx}";
			window.close();
		}
		
		function wClose(){
			let noPopup = $("#noPopup").val();
			console.log(noPopup);
			if(noPopup=='todayNo') {
				$.ajax({
					url: "${ctp}/closePopup",
					type: "post",
					data: {noPopup : noPopup},
					success: function(res) {
					},
					error: function(){
						alert("전송 오류");
					}
				}).then(function(){
					window.close();
				});
			}
			else window.close();
		}
	</script>
</head>
<body id="top">
<div class="container">
	<div class="text-right">
		<a href="javascript:showContent()" class="btn btn-main btn-icon-sm mb-2 mt-2">
			<img src="${ctp}/images/logo/imageLogo.png" width="10px"/> 자세히 보기
		</a>
	</div>
	<div id="content">${fn:replace(vo.content, newLine, '<br/>')}</div>
	<div class="text-right">
		<div class="form-check">
		  <input class="form-check-input" type="checkbox" value="todayNo" name="noPopup" id="noPopup"/>
		  <label class="form-check-label" for="popup">
		    오늘하루 보지 않기
		  </label>
		  <a href="javascript:wClose()">[닫기]</a>
		</div>
	</div>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
</body>
</html>