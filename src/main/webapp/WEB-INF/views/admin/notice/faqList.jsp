<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자 - FAQ 목록</title>
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
	<link rel="stylesheet" href="${ctp}/css/bootstrap-datepicker.css">
	<style>
	  .narrow-row .col {
	    padding-left: 2px;
	    padding-right: 2px;
	  }
		.accordion {
	    margin: 0 auto;
	    background: #fff;
	    border-radius: 8px;
	    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
		}
		
		.accordion-item {
	    border-bottom: 1px solid #ddd;
		}
		
		.accordion-header {
	    background: #f9f9f9;
	    border: none;
	    width: 100%;
	    text-align: left;
	    padding: 15px;
	    font-size: 18px;
	    cursor: pointer;
	    outline: none;
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    transition: background 0.3s;
		}
		
		.accordion-header:hover {
	    background: #e9e9e9;
		}
		
		.accordion-content {
	    max-height: 0;
	    overflow: hidden;
	    transition: max-height 0.3s ease-out;
	    background: #fafafa;
	    padding: 0 15px;
		}
		
		.accordion-content p {
	    margin: 15px 0;
		}
		.accordion-header i {
	    margin-left: auto;
	    margin-right: 10px; /* 원하는 마진 크기로 조정하세요 */
		}
		.accordion-header .fa-angle-up {
    	display: none;
		}

		.accordion-header.active .fa-angle-down {
	    display: none;
		}
		
		.accordion-header.active .fa-angle-up {
	    display: inline;
		}
	</style>
	<script>
		'use strict';
		
		document.addEventListener('DOMContentLoaded', function() {
		    let acc = document.getElementsByClassName("accordion-header");
		    let i;

		    for (i=0; i <acc.length; i++) {
	        acc[i].addEventListener("click", function() {
	          this.classList.toggle("active");

	          let content = this.nextElementSibling;
	          if (content.style.maxHeight) {
	            content.style.maxHeight = null;
	          }
	          else {
	            content.style.maxHeight = content.scrollHeight + "px";
	          }
	        });
		    }
			});
			
		
		function faqSearch(part) {
			let searchString = $("#searchString").val();
			if(searchString.trim() != "") location.href="${ctp}/admin/notice/faqList?searchString="+searchString;
			else location.href="${ctp}/admin/notice/faqList?part="+part;
		}
		
		function faqDelete(idx){
			let ans = confirm("해당 FAQ를 삭제하시겠습니까?");
			if(!ans) return false;
			location.href="${ctp}/admin/notice/faqDelete?idx="+idx;
		}
		
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="spinner-border text-muted" id="spinner" style="display:none;"></div>
<div class="container">
	<div class="row">
		<div class="col-lg-12 text-center"><h2>FAQ 리스트 (총 ${pageVO.totRecCnt} 건)</h2></div>
	</div>
	<div class="row">
		<div class="col-lg-12"><div class="divider2 mx-auto my-4 text-center" style="width:50%;"></div></div>
	</div>
	<!-- 검색창 -->
	<div class="row mb-2">
		<div class="col-md-12 text-center mb-2">
			<a href="javascript:faqSearch('')" style="padding:0.5rem;">전체</a>│
			<c:forEach var="part" items="${parts}" varStatus="st">
				<a href="javascript:faqSearch('${part}')" style="padding:0.5rem;">${part}</a>
				<c:if test="${!st.last}">│</c:if>
			</c:forEach>
		</div>
	</div>
	<div class="row mb-2">
		<div class="col-md-6 offset-md-3">
			<div class="input-group">
				<input type="text" name="searchString" id="searchString" class="form-control" style="height:36px;" required />
				<div class="input-group-append">
					<a href="javascript:faqSearch('')" class="btn btn-main btn-icon-md btn-round" style="padding:0.3rem 0.5rem;">검색<i class="fa-solid fa-magnifying-glass ml-1"></i></a>
				</div>
			</div>
		</div>
		<div class="col-md-2">
			<a href="${ctp}/admin/notice/faqInput" class="btn btn-main btn-icon-md btn-round" style="padding:0.3rem 0.5rem;">새로 작성하기</a>
			<a href="${ctp}/admin/notice/faqInput" class="btn btn-main btn-icon-md btn-round" style="padding:0.3rem 0.5rem;">분류 수정하기</a>
		</div>
	</div>
	<!-- 검색창 끝 -->
	<c:forEach var="vo" items="${vos}" varStatus="st">
		<div class="row mb-2">
			<div class="col-md-12">
				<div class="accordion">
				  <div class="accordion-item">
				      <button class="accordion-header">
				      	${vo.title}
				      	<i class="fa-solid fa-angle-down"></i>
								<i class="fa-solid fa-angle-up"></i>
				      </button>
				      <div class="accordion-content">
			          <p>${fn:replace(vo.content,newLine,'<br/>') }</p>
			          <p class="text-right">
					        <a href="${ctp}/admin/notice/faqEdit?idx=${vo.idx}&pag=${pageVO.pag}&pageSize=${pageVO.pageSize}" class="btn btn-main btn-icon-sm">수정하기</a>
					        <a href="javascript:faqDelete(${vo.idx})" class="btn btn-main-3 btn-icon-sm">삭제</a>
				        </p>
				      </div>
				  </div>
				</div>
			</div>
		</div>
	</c:forEach>
	<!-- 블록페이지 시작(목록 아래 딱 붙어 나오도록) -->	
  <div class="row mt-5 align-items-center">
    <div class="col-lg-9">
      <nav class="pagination py-2 d-inline-block">
        <div class="nav-links">
          <c:if test="${pageVO.pag > 1}"><a class="page-numbers" href="faqList?pag=1&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-left"></i></a></c:if>
          <c:if test="${pageVO.curBlock > 0}"><a class="page-numbers" href="faqList?pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-left"></i></a></c:if>
					<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
						<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><span aria-current="page" class="page-numbers current">${i}</span></c:if>
						<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><a class="page-numbers" href="faqList?pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></c:if>
					</c:forEach>
					<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><a class="page-numbers" href="faqList?pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-right"></i></a></c:if>
					<c:if test="${pageVO.pag < pageVO.totPage}"><a class="page-numbers" href="faqList?pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-right"></i></a></c:if>
      	</div>
    	</nav>
		</div>
	</div>
	<!-- 블록페이지 끝 -->
	
<!-- 문의 내용과 답변 입력 창 모달에 출력하기 -->
<div class="modal fade" id="myModal">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
    
      <!-- Modal Header -->
      <div class="modal-header text-center">
        <h4 class="modal-title">답변 등록</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
    		<span id="content"></span>
    		<hr/>
    		<table class="table table-borderless text-center">
    			<tr>
	    			<th>답변</th>
	    			<td><textarea rows="3" name="answer" id="answer" class="form-control"></textarea></td>
    			</tr>
    		</table>
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" onclick="answerInput()" id="answerInputBtn" class="btn btn-main btn-icon-md">등록하기</button>
        <button type="button" class="btn btn-main-3 btn-icon-md" data-dismiss="modal">Close</button>
      </div>
      
    </div>
  </div>
</div>
<p><br/></p>	
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.js"></script>
<script src="${ctp}/js/bootstrap-datepicker.ko.js"></script>
</body>
</html>