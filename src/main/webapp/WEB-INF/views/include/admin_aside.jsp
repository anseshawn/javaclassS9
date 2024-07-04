<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<style>
	.ani-navbar {
	 background-color: #494CB4;
	 color: white;
	 width: 200px;
	 height: 100%;
	 padding: 25px;
	 position: fixed;
	 z-index: 5;
	 transition: all 1s;
	 text-align: center;
	 transform: translateX(-150px);
	}
	
	.ani-navbar:hover {
	 transform: translateX(0px);
	 transition: all 0.5s;
	}
	
	.ani-navbar-menu {
	 display: flex;
	 align-items: center;
	 padding: 15px;
	}
	
	.ani-navbar-menu p {
	 margin: 0;
	 margin-left: 10px;
	}
	
	.ani-navbar i {
	 transition: all 0.5s;
	 transform: translateX(125px);
	}
	
	.ani-navbar:hover i {
	 transform: translateX(0px);
	}
</style>
<nav class="ani-navbar">
	<div class="ani-navbar-menu">
	  <i class="fa-solid fa-house ani-navbar-menu__icon"></i>
	  <p>Home</p>
	</div>
	<div class="ani-navbar-menu ani-navbar-menu__icon">
	  <i class="fa-solid fa-headphones"></i>
	  <p>Services</p>
	</div>
	<div class="ani-navbar-menu ani-navbar-menu__icon">
	  <i class="fa-solid fa-flag"></i>
	  <p>Alerts</p>
	</div>
	<div class="ani-navbar-menu ani-navbar-menu__icon">
	  <i class="fa-solid fa-chart-pie"></i>
	  <p>Stats</p>
	</div>
</nav>