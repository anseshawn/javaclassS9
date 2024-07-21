package com.spring.javaclassS9.common;

import java.util.ArrayList;

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
	
	//@Scheduled(cron = "0/10 * * * * *")
	@Scheduled(cron = "0 0 9 * * *")
	//@Scheduled(cron = "0/20 * * * * *")
	public void asRequestChangeStatement() {
		System.out.println("스케줄 수행중입니다");
		ArrayList<Integer> vos = customerDAO.getAsRequestTotalIdx();
		int[] idxs = new int[vos.size()];
		for(int i=0; i<vos.size(); i++) {
			idxs[i] = vos.get(i);
			System.out.println(i+". idx: "+idxs[i]);
			AsRequestVO vo = customerDAO.getAsRequestContent(idxs[i]);
			if(vo != null) {
				System.out.println("스케쥴 수행중(for if문 안): "+ i+". "+vo.getProgress());
				if(vo.getDate_diff() <= 0 && vo.getProgress()==Progress.ACCEPT) {
					vo.setProgress(Progress.PROGRESS);
					customerDAO.setAsAppointmentProgress(vo);
				}
			}
		}
	}
	
}
