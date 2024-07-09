<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<style>

	ul, li {
		margin: 0;
		padding: 0;
		list-style: none;
	}
  .ani-navbar ul ul {
	  display: none;
	  position: absolute;
	  top: 30%;
	  left: 100%;
	  background-color: rgba(0, 43, 94, 0.7); /* 70% 투명화 */
	  /* background-color: rgba(42, 92, 150, 0.7); 네비색이랑 같이 */
	  color: white;
	  width: 200px;
	  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	  z-index: 10;
  }
	.ani-navbar > ul > li {
		position: relative;
	}
  .ani-navbar > ul > li:hover > ul {
    display: block;
  }
	
	.ani-navbar {
		background-color: #2A5C96;
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
		position: relative;
	}
	
	.ani-navbar-menu a {
		margin: 0;
		margin-left: 10px;
		color: white;
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
	
	.dropdown-content a {
		display: block;
		padding: 10px;
		color: white;
		text-decoration: none;
	}

	.dropdown-content a:hover {
		 background-color: rgba(255, 255, 255, 0.3); /* 70% 투명화된 흰색 배경 */
	}
	
	.dropdown-btn:hover + .dropdown-content {
	    display: block;
	}
	.ani-navbar:hover .dropdown-content {
	    display: none;
	}
	.ani-navbar:hover .dropdown:hover .dropdown-content {
	    display: block;
	}
	
	.divider2 {
	  width: 100%;
	}
	
  /* Responsive styles */
  @media (max-width: 768px) {
      .ani-navbar {
          width: 100%;
          height: auto;
          padding: 10px;
          transform: translateX(0);
          text-align: left;
          overflow: hidden;
      }

      .navbar-toggle {
          display: block;
          position: absolute;
          top: 15px;
          right: 15px;
          color: white;
          font-size: 20px;
      }

      .ani-navbar ul {
          display: none;
          flex-direction: column;
          width: 100%;
          background-color: #2A5C96;
          position: absolute;
          top: 50px;
          left: 0;
          padding: 10px;
          box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
      }

      .ani-navbar.open ul {
          display: flex;
      }

      .ani-navbar-menu {
          flex-direction: column;
          align-items: flex-start;
          padding: 10px;
      }

      .ani-navbar-menu a, .ani-navbar-menu p {
          font-size: 16px;
          color: white;
          text-decoration: none;
          display: block;
          padding: 8px 0;
          cursor: pointer;
      }

      .ani-navbar-menu a:hover {
          background-color: rgba(255, 255, 255, 0.1);
      }

      .dropdown-content {
          display: none;
          flex-direction: column;
          position: relative;
          left: 100%;
          top: -50px;
          background-color: #2A5C96;
          padding: 10px;
      }

      .dropdown-content a {
          font-size: 14px;
          color: white;
          padding: 8px 0;
          cursor: pointer;
      }

      .dropdown:hover .dropdown-content {
          display: flex;
      }
  }

  @media (max-width: 480px) {
      .ani-navbar {
          padding: 5px;
      }

      .ani-navbar ul {
          padding: 8px;
      }

      .ani-navbar-menu a, .ani-navbar-menu p {
          font-size: 14px;
      }

      .dropdown-content a {
          padding: 6px;
          font-size: 14px;
      }
  }

</style>
<script>
	function toggleNavbar() {
	    const navbar = document.querySelector('.ani-navbar');
	    navbar.classList.toggle('open');
	}
</script>
<nav class="ani-navbar">
  <div class="navbar-toggle" onclick="toggleNavbar()">
      <i class="fas fa-bars"></i>
  </div>
	<div class="ani-navbar-menu">
	  <i class="fa-solid fa-house ani-navbar-menu__icon"></i>
		<a href="${ctp}/admin/adminMain">Home</a>
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
	<ul>
		<li class="dropdown">
			<div class="ani-navbar-menu ani-navbar-menu__icon">
			  <i class="fa-solid fa-users"></i><a href="#">회원 관리</a>
			  <ul class="dropdown-content">
			  	<li><div class="divider2"></div></li>
				  <li><a href="${ctp}/admin/member/memberList">회원 리스트</a></li>
				  <li><a href="${ctp}/admin/emailInput/all">메일 전송</a></li>
			  </ul>
			</div>
		</li>
		<li class="dropdown">
			<div class="ani-navbar-menu ani-navbar-menu__icon">
			  <i class="fa-solid fa-user-plus"></i><a href="javascript:void(0)">사원 관리</a>
			  <ul class="dropdown-content">
			  	<li><div class="divider2"></div></li>
				  <li><a href="${ctp}/admin/engineer/engineerInput">엔지니어 등록</a></li>
				  <li><a href="${ctp}/admin/engineer/engineerList">엔지니어 현황</a></li>
			  </ul>
			</div>
		</li>
	</ul>
</nav>