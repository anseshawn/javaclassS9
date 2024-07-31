package com.spring.javaclassS9.interceptor;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.spring.javaclassS9.dao.AdminDAO;
import com.spring.javaclassS9.vo.BlockIpVO;

public class HostIpInterceptor extends HandlerInterceptorAdapter {
	
	@Autowired
	AdminDAO adminDAO;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		String hostIp = request.getRemoteAddr();
		
		String now = LocalDate.now().toString();
		ArrayList<BlockIpVO> vos = adminDAO.getBlockIpList();
		for(int i=0; i<vos.size(); i++) {
			if(vos.get(i).getHostIp().equals(hostIp)) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Date blockEndDate = sdf.parse(vos.get(i).getBlockEndDate());
				Date today = sdf.parse(now);
				if(today.before(blockEndDate)) {
					//System.out.println("today: "+today);
					//System.out.println("blockEndDate: "+blockEndDate);
					RequestDispatcher dispatcher = request.getRequestDispatcher("/message/blockIpNo");
					dispatcher.forward(request, response);
					return false;
				}
			}
		}
		
		return true;
	}
}
