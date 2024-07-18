package com.spring.javaclassS9.common;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.spring.javaclassS9.dao.CustomerDAO;
import com.spring.javaclassS9.vo.AsRequestVO;
import com.spring.javaclassS9.vo.AsRequestVO.Progress;

@Service
public class JavaclassScheduler {

	@Autowired
	CustomerDAO customerDAO;
	
	//@Scheduled(cron = "0 0 24 * * *")
	@Scheduled(cron = "0/10 * * * * *")
	public void asRequestChangeStatement() {
		System.out.println("스케줄 수행중입니다");
		int cnt = customerDAO.getAsRequestTotalCnt();
		System.out.println("cnt: "+cnt);
		for(int i=1; i<=cnt; i++) {
			AsRequestVO vo = customerDAO.getAsRequestContent(i);
			if(vo != null) {
				System.out.println("스케쥴 수행중(for if문 안)");
				if(vo.getDate_diff() <= 0) vo.setProgress(Progress.PROGRESS);
			}
		}
	}
	
}
