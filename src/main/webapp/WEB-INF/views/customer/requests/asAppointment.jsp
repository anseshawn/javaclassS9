<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약하기</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <script src="${ctp}/js/woo.js"></script>
  <link rel="stylesheet" href="${ctp}/css/bootstrap-datepicker.css">
	<style>
    .place, .machine {
      padding: 10px 20px;
      border: none;
      background-color: #C7C3BB;
      color: #fff;
      cursor: pointer;
    }

    .place.act, .machine.act {
      background-color: #0E2B5E;
      color: white;
    }
    
    .place:disabled, .machine:disabled {
    	border: none;
      background-color: #C7C3BB;
      pointer-events: none;
      cursor: none;
    }
	</style>
	<script>
		'use strict';
		$(function() {
			for(let i=1; i<=17; i++) {
		  	let engineerPlace = '${eVo.place}';
	      if(!engineerPlace.includes($("#place"+i).val())){
	    	  $("#place"+i).attr("disabled",true);
	      }
			}
			for(let i=1; i<=6; i++) {
		  	let engineerMachine = '${eVo.machine}';
	      if(!engineerMachine.includes($("#machine"+i).val())){
	    	  $("#machine"+i).addClass("disabled");
	      }
			}
			
			$('#datePicker').datepicker({
		    format: "yyyy-mm-dd",	//데이터 포맷 형식(yyyy : 년 mm : 월 dd : 일 )
		    startDate: '-0d',	//달력에서 선택 할 수 있는 가장 빠른 날짜. 이전으로는 선택 불가능 ( d : 일 m : 달 y : 년 w : 주)
		    endDate: '+10m',	//달력에서 선택 할 수 있는 가장 느린 날짜. 이후로 선택 불가 ( d : 일 m : 달 y : 년 w : 주)
		    autoclose : true,	//사용자가 날짜를 클릭하면 자동 캘린더가 닫히는 옵션
		    //clearBtn : false, //날짜 선택한 값 초기화 해주는 버튼 보여주는 옵션 기본값 false 보여주려면 true
		    disableTouchKeyboard : false,	//모바일에서 플러그인 작동 여부 기본값 false 가 작동 true가 작동 안함.
		    immediateUpdates: true,	//사용자가 보는 화면으로 바로바로 날짜를 변경할지 여부 기본값 :false 
		    multidate : false, //여러 날짜 선택할 수 있게 하는 옵션 기본값 :false 
		    multidateSeparator :"~", //여러 날짜를 선택했을 때 사이에 나타나는 글짜 2019-05-01,2019-06-01
		    templates : {
		        leftArrow: '&laquo;',
		        rightArrow: '&raquo;'
		    }, //다음달 이전달로 넘어가는 화살표 모양 커스텀 마이징 
		    showWeekDays : true,// 위에 요일 보여주는 옵션 기본값 : true
		    todayHighlight : true ,	//오늘 날짜에 하이라이팅 기능 기본값 :false 
		    toggleActive : false,	//이미 선택된 날짜 선택하면 기본값 : false인경우 그대로 유지 true인 경우 날짜 삭제
		    weekStart : 0 ,//달력 시작 요일 선택하는 것 기본값은 0인 일요일 
		    language : "ko"	//달력의 언어 선택, 그에 맞는 js로 교체해줘야한다.
			});
		});
		
		// 버튼 하나만 선택, 담당자에 따른 지역과 기기명 선택
		var selectedBtnP = null;
		var selectedBtnI = null;
		
    function placeSelect(button) {
    	if(selectedBtnP) {
    		selectedBtnP.classList.remove("act");
    	}
    	button.classList.add("act");
    	selectedBtnP = button;
    	
    	let place = $(button).val();
	  	let engineerPlace = '${eVo.place}';
      if(!engineerPlace.includes(place)){
    	  alert("해당 지역 담당 엔지니어를 선택해주세요.");
    	  button.classList.remove("act");
    	  $("#addressInput").hide();
    	  return false;
      }
      
  	  $("#addressInput").show();
    }
    // 지역 선택 새로고침
    function activeSelect() {
    	if(selectedBtnP) {
    		selectedBtnP.classList.remove("act");
    		selectedBtnP = null;
    	}
    	$("#addressInput").hide();
    }
    // 기기 선택
    function machineSelect(button) {
    	if(selectedBtnI) {
    		selectedBtnI.classList.remove("act");
    	}
    	button.classList.add("act");
    	selectedBtnI = button;
    	
    	let machine = $(button).val();
	  	let engineerMachine = '${eVo.machine}';
      if(!engineerMachine.includes(machine)){
    	  let str = "해당 엔지니어의 담당 기기는 ${eVo.machine} 입니다.";
    	  alert(str);
    	  button.classList.remove("act");
    	  return false;
      }
      $("#noteInput").show();
    }
    
    // 유효성 검사
    function fCheck() {
    	if(selectedBtnP==null || selectedBtnI==null) {
    		alert("신청지역 및 기기명을 선택하세요.");
    		return false;
    	}
    	
    	let place = selectedBtnP.value;
    	let machine = selectedBtnI.value;
    	let asName = document.getElementById("asName").value;
    	if(asName.trim()=="") {
    		alert("신청자 이름은 필수 입력값입니다.");
    		$("#name").focus();
    		return false;
    	}
    	if(asName.trim().length > 20) { // 회사명 가능성 있어서 길이만 검사
    		alert("신청자 이름은 20자까지 입력 가능합니다.");
    		return false;
    	}
    	
    	let postcode = myform.postcode.value;
    	let roadAddress = myform.roadAddress.value;
    	let detailAddress = myform.detailAddress.value+" ";
    	let extraAddress = myform.extraAddress.value+" ";
    	let address = postcode+"/"+roadAddress+"/"+detailAddress+"/"+extraAddress;
    	if(postcode.trim()=="" || roadAddress.trim()=="") {
    		alert("상세 주소를 입력하세요.");
    		document.getElementById("sample6_postcode").focus();
    		return false;
    	}
    	myform.address.value = address;
    	
    	myform.asPlace.value = place;
    	document.getElementById("machine").value = machine;
    	
    	myform.submit();
    }
    
	</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<jsp:include page="/WEB-INF/views/include/nav2.jsp" />
<div class="container">
	<div class="text-center"><h2>A/S 신청</h2></div>
	<div class="divider2 mx-auto my-4 text-center" style="width:70%;"></div>
	<form name="myform" method="post" class="was-validated">
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2"><h4>담당자</h4>
				<input type="text" name="eName" id="eName" value="${eVo.name} 엔지니어" readonly required class="form-control"/>
			</div>
		</div>
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2"><h4>신청자 아이디</h4>
				<input type="text" name="asMid" id="asMid" value="${sMid}" readonly required class="form-control"/>
			</div>
		</div>
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2"><h4>신청자 이름</h4>
				<input type="text" name="asName" id="asName" required class="form-control"/>
			</div>
		</div>
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2">
				<div class="input-group"><h4>신청 지역 선택</h4><a href="javascript:activeSelect()" class="ml-2"><i class="fa-solid fa-arrow-rotate-right"></i></a></div>
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place1" value="서울" onclick="placeSelect(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place2" value="인천" onclick="placeSelect(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place3" value="부산" onclick="placeSelect(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place4" value="대구" onclick="placeSelect(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place5" value="광주" onclick="placeSelect(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place6" value="대전" onclick="placeSelect(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place7" value="울산" onclick="placeSelect(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place8" value="세종" onclick="placeSelect(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place9" value="경기" onclick="placeSelect(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place10" value="강원" onclick="placeSelect(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place11" value="충북" onclick="placeSelect(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place12" value="충남" onclick="placeSelect(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place13" value="전북" onclick="placeSelect(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place14" value="전남" onclick="placeSelect(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place15" value="경북" onclick="placeSelect(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place16" value="경남" onclick="placeSelect(this)">
				<input type="button" class="place btn btn-main btn-icon-md btn-round-full mr-2 mb-2" id="place17" value="제주" onclick="placeSelect(this)">
      </div>
		</div>
		<div class="row justify-content-center mb-3" id="addressInput" style="display:none;">
			<div class="col-md-8 col-md-offset-2"><h4>상세주소</h4>
				<div class="form-group">
		      <div class="input-group mb-1">
		        <input type="text" name="postcode" id="sample6_postcode" placeholder="우편번호" class="form-control">
		        <div class="input-group-append">
		          <input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기" class="btn btn-main-2 btn-round btn-icon-sm">
		        </div>
		      </div>
		      <input type="text" name="roadAddress" id="sample6_address" size="50" placeholder="주소" class="form-control mb-1">
		      <div class="input-group mb-1">
		        <input type="text" name="detailAddress" id="sample6_detailAddress" placeholder="상세주소" class="form-control"> &nbsp;&nbsp;
		        <div class="input-group-append">
		          <input type="text" name="extraAddress" id="sample6_extraAddress" placeholder="참고항목" class="form-control">
		        </div>
		      </div>
		    </div>
	    </div>
    </div>
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2"><h4>A/S 희망 날짜</h4>
				<div id="comment" class="text-left" style="font-size:13px">엔지니어 사정으로 변경될 수 있습니다.</div>
				<input type="text" id="datePicker" name="asDate" class="form-control" value="<%=java.time.LocalDate.now() %>">
			</div>
		</div>
		
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2"><h4>기기명(종류)</h4>
				<div id="comment" class="text-left" style="font-size:13px">상세한 모델명이나 증상은 아래 비고란에 남겨주세요.</div>
				<input type="button" class="machine btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="machine" value="UV" onclick="machineSelect(this)"/>
				<input type="button" class="machine btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="machine" value="AAs" onclick="machineSelect(this)"/>
				<input type="button" class="machine btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="machine" value="ICP" onclick="machineSelect(this)"/>
				<input type="button" class="machine btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="machine" value="GC" onclick="machineSelect(this)"/>
				<input type="button" class="machine btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="machine" value="LC" onclick="machineSelect(this)"/>
				<input type="button" class="machine btn btn-main btn-icon-md btn-round-full mr-2 mb-2" name="machine" value="etc" onclick="machineSelect(this)"/>
			</div>
		</div>
		<div class="row justify-content-center mb-3" id="noteInput" style="display:none;">
			<div class="col-md-8 col-md-offset-2"><h4>비고</h4>
				<textarea rows="5" class="form-control" name="detailNote" id="detailNote" placeholder="모델명, 증상 등 관련 사항을 남겨주시면 접수가 빨라집니다."></textarea>
			</div>
		</div>

		<div class="divider2 mx-auto my-4 text-center" style="width:70%;"></div>
		<div class="row justify-content-center mb-3">
			<div class="col-md-8 col-md-offset-2 text-center">
				<input type="button" value="신청하기" onclick="fCheck()" class="btn btn-main btn-icon btn-round-full mr-2" />
				<input type="button" value="취소" onclick="location.href='${ctp}/customer/requests/asRequest';" class="btn btn-main-3 btn-icon btn-round-full" />
			</div>
		</div>
		<input type="hidden" name="asPlace" id="asPlace">
		<input type="hidden" name="machine" id="machine">
		<input type="hidden" name="address" id="address">
		<input type="hidden" name="engineerIdx" value="${eVo.idx}">
	</form>
</div>
<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.js"></script>
<script src="${ctp}/js/bootstrap-datepicker.ko.js"></script>
</body>
</html>