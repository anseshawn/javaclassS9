package com.spring.javaclassS9.interceptor;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class Level1Interceptor extends HandlerInterceptorAdapter {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		HttpSession session = request.getSession();
		int level = session.getAttribute("sLevel")==null ? 99 : (int) session.getAttribute("sLevel");
		
		// 관리자(0), 사원(엔지니어)(1), 재직자회원(2), 일반회원(3), 비회원(99), 탈퇴회원(999)
		// 우수회원 이상 사용처리
		if(level  > 1) {
			RequestDispatcher dispatcher;
			if(level == 99) { // 비회원 처리
				dispatcher = request.getRequestDispatcher("/message/memberNo");
			}
			else { // 재직자회원 & 일반회원
				dispatcher = request.getRequestDispatcher("/message/engineerNo");
			}
			dispatcher.forward(request, response);
			return false;
		}
		
		return true;
	}
}
