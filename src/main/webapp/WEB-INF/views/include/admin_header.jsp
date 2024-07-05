<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<style>
	.nav-container {
	 background-color: white;
	 width: 100%;
	 height: 60px;
	 box-shadow: 0px 2px 2px 2px #eee;
	 display: flex;
	 justify-content: space-between;
	}
	
	.search-box {
	 display: inline-flex;
	 align-items: center;
	 margin-left: 100px;
	}
	
	.search-box-input {
	 padding: 5px;
	 border-radius: 5px 0px 0px 5px;
	 border: 1px solid lightgrey;
	 width: 150px;
	 transition: width 1s;
	}
	
	.search-box-input:focus {
	 width:300px;
	}
	
	.search-box-btn {
	 background-color: #343940;
	 color: white;
	 border: none;
	 border-radius: 0px 5px 5px 0px;
	 height: 36px;
	 width: 40px;
	}
	
	.notification {
	 display: flex;
	 margin-right: 20px;
	 align-items: center;
	}
	
	.notification-icon {
	 font-size: x-large;
	 margin-left: 60px;
	 color: #808080;
	 margin-bottom: 20px;
	}
	
	.notification-badge {
	 position: relative;
	 left: 15px;
	 top: 16px;
	 background-color: #DC3545;
	 width: 20px;
	 height: 20px;
	 border-radius: 5px;
	 display: flex;
	 justify-content: center;
	 align-items: center;
	 color: white;
	 font-size: small;
	 font-weight: 600;
	}
	
	#notification-name {
	 margin-left: 40px;
	 color: grey;
	}
</style>
<nav class="nav-container">
  <div class="search-box">
    <input type="text" class="search-box-input" placeholder="Search" />
    <button class="search-box-btn">
      <i class="fa-solid fa-magnifying-glass"></i>
    </button>
  </div>

  <div class="notification">
    <div class="notification-icon">
      <span class="notification-badge">5</span>
      <i class="fa-solid fa-bell"></i>
    </div>
    <div class="notification-icon">
      <span class="notification-badge">9</span>
      <i class="fa-solid fa-envelope"></i>
    </div>
    <span id="notification-name">Hyewon Shin</span>
  </div>
</nav>