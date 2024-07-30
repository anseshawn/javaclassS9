<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<div class="shuffle-container">
<div class="col-12 text-center mb-5" id="items-container">
  <c:forEach var="vo" items="${vos}" varStatus="st">
  	<c:set var="mach" value="${fn:split(vo.machine,',')}"/>
  	<c:set var="catGroup">
    	<c:forEach var="cat" items="${mach}" varStatus="catSt">
    		"${cat}"<c:if test="${!catSt.last}">,</c:if>
    	</c:forEach>
  	</c:set>
  	<div class="shuffle-wrapper">
	    <div class="border shuffle-item portfolio-gallery mb-4" data-groups='[${catGroup}]'>
	    	<table class="table table-borderless">
		      <tr>
		      	<td rowspan="3" style="width:20%;"><img src="${ctp}/engineer/${vo.photo}" width="150px"/></td>
		      	<td colspan="2"><b>${vo.name}</b> 엔지니어</td>
		      	<td>
		      		<a href="#" onclick="modalView('${vo.idx}')" data-toggle="modal" data-target="#myModal"><i class="fa-solid fa-star mr-2" style="color:#FFB724"></i> ${vo.starPoint}
		      		<span style="font-size:13px;"><br/>상세리뷰</span></a>
		      	</td>
		      </tr>
		      <tr class="text-center">
		      	<th>담당기기</th>
		      	<td>${vo.machine}</td>
		      	<td rowspan="2" style="width:20%; text-align:center;">
		      		<a href="${ctp}/customer/requests/asAppointment?idx=${vo.idx}"><i class="fa-regular fa-calendar-days"></i><br/>예약하기</a>
		      	</td>
		      </tr>
		      <tr class="text-center">
		      	<th>담당지역</th>
		      	<td>${vo.place}</td>
		      </tr>
		    </table>
		  </div>
    </div>
  </c:forEach>
</div>
</div>
</html>