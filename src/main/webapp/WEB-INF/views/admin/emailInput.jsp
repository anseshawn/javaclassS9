<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 이메일 보내기</title>
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
	</style>
	<script>
		'use strict';
		
		$(function(){
			$("#myModal").on('show.bs.modal', function(e){
				$("#memberAll").show();
				$("#midSearchResult").hide();
				$("#mid").val("");
			})
		});
		
		function fCheck() {
			document.getElementById("spinner").style.display='block';
			let toMail = $("#toMail").val();
			let title = $("#title").val();
			let content = $("#content").val();
			
			if(toMail.trim()=="" || title.trim()=="" || content.trim()=="") {
				alert("받는 사람, 제목, 내용을 확인하세요.");
				return false;
			}
			
			myform.submit();
		}
		
		function midSearchView() {
			let mid = $("#mid").val();
			if(mid.trim() == "") {
				alert("아이디를 입력하세요.");
				return false;
			}
			let str = "";
			$.ajax({
				url: "${ctp}/admin/midSearch",
				type: "post",
				data: {mid : mid},
				success: function(mVos) {
					for(let i=0; i<mVos.length; i++) {
						str += '<tr>';
						str += '<td>'+mVos[i].name+'</td>';
						str += '<td><a href="${ctp}/admin/emailInput/${vo.mid}">'+mVos[i].mid+'</td>';
						str += '<td>'+mVos[i].nickName+'</td>';
						str += '</tr>';
					}
					$("#memberAll").hide();
					$("#midSearchResult").html(str).show();
				},
				error: function() {
					alert("전송오류");
				}
			});
		}
		
		function allMemberShow() {
			$("#memberAll").show();
			$("#midSearchResult").hide();
		}
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
<div class="spinner-border text-muted" id="spinner" style="display:none;"></div>
	<div class="text-center"><h2>이메일 보내기</h2></div>
	<div class="divider2 mx-auto my-4 text-center" style="width:70%;"></div>
	<form name="myform" method="post">
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2">
				<div class="input-group">
					<label class="input-group-text">보내는 사람</label>
					<input type="text" class="form-control" placeholder="그린 엔지니어링(GreenEngineering)" readonly/>
				</div>
			</div>
		</div>
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2">
				<div class="input-group">
					<h4>받는사람</h4><a href="#" id="midSearch" data-toggle="modal" data-target="#myModal" class="btn btn-main btn-icon-sm btn-round-full ml-3" style="padding:0.45rem;">주소 검색</a>
				</div>
				<input type="text" name="toMail" id="toMail" class="form-control mt-2" placeholder="받는 사람을 입력하세요" value="${toMail}" required/>
				<div id="comment" class="text-left" style="font-size:13px">여러명에게 전송 시 아이디를 쉼표로 구별해주세요. (메일 주소로 입력 시 한 명에게만 전송 가능합니다.)</div>
			</div>
		</div>
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
		<div class="divider2 mx-auto my-4 text-center" style="width:70%;"></div>
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2 text-center">
				<input type="button" value="전송하기" onclick="fCheck()" class="btn btn-main-2 btn-icon btn-round-full mr-2" />
				<input type="button" value="취소" onclick="location.href='${ctp}/admin/adminMain';" class="btn btn-main btn-icon btn-round-full" />
			</div>
		</div>
	</form>
</div>

<div class="modal fade" id="myModal">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
    
      <div class="modal-header text-center">
        <h4 class="modal-title">회원 목록</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      
      <div class="modal-body">
      	<div class="input-group mb-2">
      		<input type="text" name="mid" id="mid" placeholder="검색할 아이디를 입력하세요" class="form-control" />
	        <input type="button" value="아이디 검색" onclick="midSearchView()" id="midSearchBtn" class="btn btn-main btn-icon-md" />
	        <input type="button" value="전체보기" onclick="allMemberShow()" class="btn btn-main-3 btn-icon-md" />
      	</div>
      	<table class="table table-hover text-center">
      		<tr style="background-color:#003675; color:#fff;">
      			<th>이름</th>
      			<th>아이디</th>
      			<th>닉네임</th>
      		</tr>
      		<tbody id="memberAll">
	      		<c:forEach var="vo" items="${mVos}" varStatus="st">
	      			<tr>
	      				<td>${vo.name}</td>
	      				<td><a href="${ctp}/admin/emailInput/${vo.mid}">${vo.mid}</a></td>
	      				<td>${vo.nickName}</td>
	      			</tr>
	      		</c:forEach>
      		</tbody>
      		<tbody id="midSearchResult" style="display:none;"></tbody>
      		<tr><td colspan="3" class="m-0 p-0"></td></tr>
      	</table>
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
      
    </div>
  </div>
</div>

</body>
</html>