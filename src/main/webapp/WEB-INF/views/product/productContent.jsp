<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>장비 상세페이지 - ${vo.proName}</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<style>
		.likeBtn {
      border-color: #C7C3BB;
      color: #fff;
      background-color: #C7C3BB;
      cursor: pointer;
    }
		.likeBtn:hover {
			border-color: #0E2B5E;
      background-color: #0E2B5E;
      color: #fff;
    }
    .likeBtn.act {
      border-color: #0E2B5E;
      color: #fff;
      background-color: #0E2B5E;
    }
    th {
    	text-align: center;
    }
	</style>
	<script>
		'use strict';
		
		let likeBtnP = null;
		$(function(){
			if('${likeSw}'=='act'){
				$("#likeBtn").addClass("act");
				likeBtnP = $("#likeBtn").val();
			}
		});
		
		// 관심장비 등록 버튼
		function addLikeProduct(button) {
    	if(likeBtnP) {
    		let ans = confirm("이미 관심장비에 등록된 장비입니다.\n해당 장비를 관심목록에서 삭제하겠습니까?");
    		if(!ans) return false;
    		
    		$.ajax({
    			url: "${ctp}/product/productRemoveLike",
    			type: "post",
    			data: {
    				idx: ${vo.idx},
    				mid: '${sMid}'
    			},
    			success: function(res){
    				if(res != "0") {
    					alert("관심 목록에서 장비를 삭제했습니다.");
    					button.classList.remove("act");
	    				likeBtnP = null;
    				}
    				else alert("삭제 실패. 다시 시도하세요.");
    			},
    			error: function(){
    				alert("전송 오류");
    			}
    		});
    	}
    	else {
				$.ajax({
					url: "${ctp}/product/productAddLike",
					type: "post",
					data: {
						idx: ${vo.idx},
						mid: '${sMid}'
					},
					success: function(res) {
						if(res != "0"){
							alert("해당 장비를 관심 목록에 등록했습니다.");
							button.classList.add("act");
							likeBtnP = button;
						}
						else alert("관심장비 등록 실패. 다시 시도하세요.");
					},
					error: function() {
						alert("전송오류");
					}
				});
    	}
		}
		
		function productEdit(idx) {
			let ans = confirm("장비 설명 수정을 위하여 관리자 페이지로 이동하겠습니까?");
			if(!ans) return false;
			else location.href="${ctp}/admin/product/productEdit?idx="+idx;
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<div class="container">
	<section class="page-title bg-3">
	  <div class="overlay"></div>
	  <div class="container">
	    <div class="row">
	      <div class="col-md-12">
	        <div class="block text-center">
	          <span class="text-white">좋은 장비는 분석 효율을 높입니다</span>
	          <h1 class="text-capitalize mb-5 text-lg">분석장비</h1>
	        </div>
	      </div>
	    </div>
	  </div>
	</section>
	<section class="section blog-wrap">
		<div class="container">
			<div class="product_info_box">
				<div class="row">
					<div class="col product_info_left" style="float:left;">
						<a href="${ctp}/product/${vo.proPhoto}" target="_blank"><img src="${ctp}/product/${vo.proPhoto}" width="400px" /></a>
					</div>
					<div class="col product_info_right" style="float:right;">
						<table class="table table-bordered">
							<tr>
								<td colspan="2">제품코드 : ${vo.idx}</td>
							</tr>
							<tr>
								<td colspan="2">${vo.proName}</td>
							</tr>
							<tr>
								<th style="width:30%;">제조사</th>
								<td style="width:70%;">${vo.proMade}</td>
							</tr>
							<tr>
								<th>연식</th>
								<td>${vo.proYear} 년도</td>
							</tr>
							<tr>
								<th>비고</th>
								<td>${fn:replace(vo.etcDetail, newLine, '<br/>') }</td>
							</tr>
						</table>
						<c:if test="${!empty sLevel && sLevel > 0}">
							<div class="text-right">
								<input type="button" value="관심장비 등록" onclick="addLikeProduct(this)" id="likeBtn" class="likeBtn btn btn-main mr-2 mb-2"/> 
								<input type="button" value="견적요청" onclick="location.href='${ctp}/product/productEstimate?idx=${vo.idx}';" class="btn btn-main mb-2"/>
							</div>
						</c:if>
						<c:if test="${!empty sLevel && sLevel == 0}">
							<div class="text-right">
								<a href="javascript:productEdit(${vo.idx})" class="btn btn-main-2 btn-icon mr-2 mb-2">설명 수정</a>
							</div>
						</c:if>
					</div>
				</div>
			</div>
		</div>
	</section>
	
</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>