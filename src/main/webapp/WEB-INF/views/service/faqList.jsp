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
  <title>FAQ</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<style>
		
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
		
		// faq내용 검색(파트 / 혹은 제목으로)
		function faqSearch(part) {
			let searchString = $("#searchString").val();
			if(searchString.trim() != "") location.href="${ctp}/service/faqList?searchString="+searchString;
			else location.href="${ctp}/service/faqList?part="+part;
		}
		
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
		
	</script>
</head>
<body id="top">
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<div class="container">
<p><br/></p>

<section class="page-title bg-2">
  <div class="overlay"></div>
  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <div class="block text-center">
          <span class="text-white">자주 묻는 질문</span>
          <h1 class="text-capitalize mb-5 text-lg"><a href="${ctp}/service/faqList" style="color: #fff;">FAQ</a></h1>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="section blog-wrap" style="padding:0px;">
	<div class="container">
	<p><br/></p>
		<div class="row mb-4">
			<!-- 검색창 -->
			<div class="col-md-12 text-center mb-2">
				<a href="javascript:faqSearch('')" style="padding:0.5rem;">전체</a>│
				<c:forEach var="part" items="${parts}" varStatus="st">
					<a href="javascript:faqSearch('${part}')" style="padding:0.5rem;">${part}</a>
					<c:if test="${!st.last}">│</c:if>
				</c:forEach>
			</div>
			<div class="col-md-6 offset-md-3 mb-2">
				<div class="input-group">
					<input type="text" name="searchString" id="searchString" class="form-control" style="height:36px;" required />
					<div class="input-group-append">
						<a href="javascript:faqSearch('')" class="btn btn-main btn-icon-md btn-round" style="padding:0.3rem 0.5rem;">검색<i class="fa-solid fa-magnifying-glass ml-1"></i></a>
					</div>
				</div>
			</div>
			<!-- 검색창 끝 -->
		</div>
		<div class="mb-2">총 <font color="#246BEB">${count}</font> 건</div>
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
	          <c:if test="${pageVO.pag > 1}"><a class="page-numbers" href="noticeList?pag=1&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-left"></i></a></c:if>
	          <c:if test="${pageVO.curBlock > 0}"><a class="page-numbers" href="noticeList?pag=${(pageVO.curBlock-1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-left"></i></a></c:if>
						<c:forEach var="i" begin="${(pageVO.curBlock*pageVO.blockSize+1)}" end="${(pageVO.curBlock)*pageVO.blockSize+pageVO.blockSize}" varStatus="st">
							<c:if test="${i <= pageVO.totPage && i == pageVO.pag}"><span aria-current="page" class="page-numbers current">${i}</span></c:if>
							<c:if test="${i <= pageVO.totPage && i != pageVO.pag}"><a class="page-numbers" href="noticeList?pag=${i}&pageSize=${pageVO.pageSize}">${i}</a></c:if>
						</c:forEach>
						<c:if test="${pageVO.curBlock < pageVO.lastBlock}"><a class="page-numbers" href="noticeList?pag=${(pageVO.curBlock+1)*pageVO.blockSize+1}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-right"></i></a></c:if>
						<c:if test="${pageVO.pag < pageVO.totPage}"><a class="page-numbers" href="noticeList?pag=${pageVO.totPage}&pageSize=${pageVO.pageSize}"><i class="icofont-thin-double-right"></i></a></c:if>
        	</div>
      	</nav>
			</div>
		</div>
		<!-- 블록페이지 끝 -->
	</div>
</section>
</div>
<p><br/></p>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>