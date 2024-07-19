<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>접수현황 확인</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<link rel="stylesheet" href="${ctp}/css/bootstrap-datepicker.css">
	<style>
		.content th {
			background-color: #CDD7E4; 
		}
		/* 별점 스타일 적용하기 */
  	#starForm fieldset {
  		direction : rtl;
  	}
  	#starForm input[type=radio] {
  		display: none;
  	}
  	#starForm label {
  		font-size: 1.4em;
  		color: transparent;
  		text-shadow: 0 0 0 #f0f0f0; /* 오른쪽 아래쪽 크기 순서 */
  	}
  	#starForm label:hover {
  		text-shadow: 0 0 0 rgba(250,200,0,0.98);
  	}
  	#starForm label:hover ~ label { /* 물결 연산자: 흐름 */
  		text-shadow: 0 0 0 rgba(250,200,0,0.98);
  	}
  	#starForm input[type=radio]:checked ~ label { /* 라디오버튼이 눌리면 멈춘다 */
  		text-shadow: 0 0 0 rgba(250,200,0,0.98);
  	}
	</style>
	<script>
		'use strict';
		
		$(function(){
			if(${sw} != 0) $("#starFinish").show();
		});
		
		function modalView(idx) {
			let str = '<div class="border portfolio-gallery">';
			$.ajax({
				url: "${ctp}/engineer/engineerContent",
				type: "post",
				data: {idx:idx},
				success: function(eVo) {
					str += '<table class="table table-borderless text-center">';
					str += '<tr>';
					str += '<td rowspan="3" style="width:20%;"><img src="${ctp}/engineer/'+eVo.photo+'" width="150px"/></td>';
					str += '<td colspan="2"><b>'+eVo.name+'</b> 엔지니어</td>';
					str += '<td colspan="2"><i class="fa-solid fa-star mr-2" style="color:#FFB724"></i>'+eVo.starPoint+'</td>';
					str += '</tr>';
					str += '<tr class="text-center">';
					str += '<th>이메일</th>';
					str += '<td>'+eVo.email+'</td>';
					str += '<th>연락처</th>';
					str += '<td>'+eVo.tel+'</td>';
					str += '</tr>';
					str += '<tr>';
					str += '<th>담당기기</th><td colspan="3">'+eVo.machine+'</td>';
					str += '</tr>';
					str += '</table>';
					str += '</div>';
					
					$("#content").html(str);
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
		
		function reviewCheck() {
			let star = starForm.star.value;
			let reviewDetail = document.getElementById("review").value;
			if(star.trim()=="") {
				alert("엔지니어 평가시 별점은 필수 입력값입니다.");
				return false;
			}
			let query = {
					memberMid: '${sMid}',
					asIdx: ${vo.idx},
					engineerIdx: ${vo.engineerIdx},
					starPoint: star,
					reviewDetail: reviewDetail
			}
			
			$.ajax({
				url: "${ctp}/customer/reviewInput",
				type: "post",
				data: query,
				success: function(res) {
					if(res != "0") {
						$("#starForm").hide();
						$("#starFinish").show();
					}
					else {
						alert("별점 등록에 실패했습니다. 다시 확인해주세요.");
					}
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<div class="container">
	<section class="page-title bg-3">
	  <div class="overlay"></div>
	  <div class="container">
	    <div class="row">
	      <div class="col-md-12">
	        <div class="block text-center">
	          <h1 class="text-capitalize mb-5 text-lg">나의 접수현황</h1>
	        </div>
	      </div>
	    </div>
	  </div>
	</section>

	<section class="section blog-wrap">
		<div class="container">
			<table class="table content table-bordered text-center">
				<tr>
					<th>접수번호</th>
					<td>${vo.idx}</td>
					<th>담당자</th>
					<td><a href="#" onclick="modalView('${vo.engineerIdx}')" data-toggle="modal" data-target="#engineerInfoModal">${vo.engineerName}<i class="fa-solid fa-phone ml-2"></i></a></td>
				</tr>
				<tr>
					<th>신청일</th>
					<c:set var="requestDate" value="${fn:substring(vo.requestDate,0,10)}"/>
					<td>${requestDate}</td>
					<th>기기명</th>
					<td>${vo.machine}</td>
				</tr>
				<c:if test="${vo.progress!='REGIST'}"> <!-- 접수 완료되어 asDate를 엔지니어가 수정하면 보이게 -->
					<c:set var="asDate" value="${fn:substring(vo.asDate,0,10)}"/>
					<tr>
						<th>출장 진행일</th>
						<td colspan="3">${asDate}</td>
					</tr>
				</c:if>
				<tr>
					<th>진행 상황</th>
					<td colspan="3">
						${progress}
						<c:if test="${progress=='신청완료'}"><font size="2"><br/>엔지니어가 신청을 확인하여 날짜를 확정하면 접수완료 상태로 변경됩니다.</font></c:if>
					</td>
				</tr>
				<tr>
					<th>증상</th>
					<td colspan="3"><c:if test="${empty vo.detailNote}">-</c:if><c:if test="${!empty vo.detailNote}">${vo.detailNote}</c:if></td>
				</tr>
				<c:if test="${vo.progress=='PAYMENT' || vo.progress=='COMPLETE'}">
					<tr>
						<th>엔지니어 코멘트</th>
						<td colspan="3">${fn:replace(vo.comment,newLine,'<br/>')}</td>
					</tr>
				</c:if>
				<tr><td colspan="4" class="m-0 p-0"></td></tr>
			</table>
			<c:if test="${vo.progress=='COMPLETE' && sw==0}">
				<hr/>
				<form name="starForm" id="starForm">
					<div class="row justify-content-center">
					 <div class="col-5"><h3>${vo.engineerName} 엔지니어의 서비스는 어땠나요?</h3></div>
						<div class="col-7">
							<fieldset style="border:0px;">
								<div class="viewPoint m-0 b-0"> <!-- rtl(right to left) 형식으로 가기 위해 라디오버튼 다음 라벨 -->
									<input type="radio" name="star" value="5" id="star1" /><label for="star1">⭐</label>
									<input type="radio" name="star" value="4" id="star2" /><label for="star2">⭐</label>
									<input type="radio" name="star" value="3" id="star3" /><label for="star3">⭐</label>
									<input type="radio" name="star" value="2" id="star4" /><label for="star4">⭐</label>
									<input type="radio" name="star" value="1" id="star5" /><label for="star5">⭐</label>
									: 별점을 선택해 주세요 ■
								</div>
							</fieldset>	
						</div>
					</div>
					<div class="row justify-content-center">
						<div class="col-8">
							<textarea rows="2" name="review" id="review" class="form-control" placeholder="상세한 후기를 남겨주시면 서비스 개선에 참고하겠습니다."></textarea>
						</div>
						<div class="col-4">
							<input type="button" value="등록" onclick="reviewCheck()" class="btn btn-main-3"/>
						</div>
					</div>
				</form>
			</c:if>
			<div id="starFinish" style="display:none; text-align:center;">
				<h4>평가가 완료되었습니다.</h4>
			</div>
			<div class="text-right mt-2">
				<a href="${ctp}/customer/requests/asProgress?pag=${pag}&pageSize=${pageSize}" class="btn btn-main btn-icon btn-round">목록으로</a>
			</div>
		</div>
	</section>
</div>
<!-- 멤버 정보 모달에 출력하기 -->
<div class="modal fade" id="engineerInfoModal">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
    
      <!-- Modal Header -->
      <div class="modal-header text-center">
        <h4 class="modal-title">엔지니어 상세정보</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
    		<span id="content"></span>
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-main-3" data-dismiss="modal">Close</button>
      </div>
      
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.js"></script>
<script src="${ctp}/js/bootstrap-datepicker.ko.js"></script>
</body>
</html>