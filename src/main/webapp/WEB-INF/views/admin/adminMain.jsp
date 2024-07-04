<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 메인</title>
	<style>
	  .bodyLeft {
	    float: left;
	    width: 25%;
	  }
	  .bodyMiddle {
	    float: left;
	    width: 75%;
	  }
	</style>
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<div class="container">
  <h4 class="my-4">Dashboard</h4>
  <div class="row">
    <div class="col-lg-3">
      <div class="card monthly">
        <div class="card-body d-flex justify-content-between">
          <div>
            <p class="card-text mb-2">Earnings (Monthly)</p>
            <h4>$400,000</h4>
          </div>
          <i
            class="fas fa-calendar"
            style="font-size: 30px; margin-top: 20px; color: #6c757d"
          ></i>
        </div>
      </div>
    </div>
    <div class="col-lg-3">
      <div class="card annual">
        <div class="card-body d-flex justify-content-between">
          <div>
            <p class="card-text mb-2">Earnings (Annual)</p>
            <h4>$800,000</h4>
          </div>
          <i
            class="fa-solid fa-dollar-sign"
            style="font-size: 30px; margin-top: 20px; color: #6c757d"
          ></i>
        </div>
      </div>
    </div>
    <div class="col-lg-3">
      <div class="card tasks">
        <div class="card-body d-flex justify-content-between">
          <div>
            <p class="card-text mb-2">Tasks</p>
            <h4>13</h4>
          </div>
          <i class="fa-solid fa-list-check" style="font-size: 30px; margin-top: 20px; color: #6c757d"></i>
        </div>
      </div>
    </div>
    <div class="col-lg-3">
      <div class="card requests">
        <div class="card-body d-flex justify-content-between">
          <div>
            <p class="card-text mb-2">Requests</p>
            <h4>26</h4>
            </div>
            <i
              class="fa-solid fa-comments"
              style="font-size: 30px; margin-top: 20px; color: #6c757d"
            ></i>
          </div>
        </div>
      </div>
    </div>
  </div>
</body>
</html>