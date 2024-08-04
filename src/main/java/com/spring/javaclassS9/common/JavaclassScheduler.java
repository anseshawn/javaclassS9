package com.spring.javaclassS9.common;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.RequestDispatcher;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.spring.javaclassS9.dao.AdminDAO;
import com.spring.javaclassS9.dao.CustomerDAO;
import com.spring.javaclassS9.dao.ProductDAO;
import com.spring.javaclassS9.vo.AsRequestVO;
import com.spring.javaclassS9.vo.AsRequestVO.Progress;
import com.spring.javaclassS9.vo.BlockIpVO;
import com.spring.javaclassS9.vo.ProductEstimateVO;
import com.spring.javaclassS9.vo.ProductSaleVO;
import com.spring.javaclassS9.vo.ProductSaleVO.Statement;

@Service
public class JavaclassScheduler {

	@Autowired
	CustomerDAO customerDAO;
	
	@Autowired
	ProductDAO productDAO;
	
	@Autowired
	AdminDAO adminDAO;
	
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
	
	@Scheduled(cron = "0 0 17 28-31 * ?")
	public void productEstimateChangeStatement() throws ParseException {
		ArrayList<ProductSaleVO> vos = productDAO.getAllProductSaleList(-1,0);
		int[] idxs = new int[vos.size()];
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String monthBefore = LocalDate.now().minusMonths(1).toString();
		Date searchDate = sdf.parse(monthBefore);
		for(int i=0; i<vos.size(); i++) {
			ProductSaleVO saleVO = productDAO.getProductSaleContent(vos.get(i).getIdx());
			Date requestDate = sdf.parse(saleVO.getRequestDate());
			if(saleVO.getStatement().equals(Statement.CANCEL) && requestDate.before(searchDate)) {
				productDAO.setProductSaleDelete(saleVO.getIdx());	// 견적요청 건 취소 & 한달 전이면 삭제
			}
			idxs[i] = vos.get(i).getIdx();
			ProductEstimateVO vo = productDAO.getProductEstimateContent(vos.get(i).getIdx());
			if(vo != null) {
				Date sendDate = sdf.parse(vo.getSendDate());
				if(vo.getStatement().equals(Statement.CANCEL) && sendDate.before(searchDate)) {
					productDAO.setProductEstimateDelete(vo.getIdx()); // 견적서 발송 후 취소 & 한달 전이면 삭제
				}
			}
		}
	}
	
	//@Scheduled(cron = "0/10 * * * * *")
	@Scheduled(cron = "0 0 0 * * *")
	public void changeBlockIp() throws ParseException {
		String now = LocalDate.now().toString();
		ArrayList<BlockIpVO> vos = adminDAO.getBlockIpList();
		for(int i=0; i<vos.size(); i++) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date blockEndDate = sdf.parse(vos.get(i).getBlockEndDate());
			Date today = sdf.parse(now);
			if(today.after(blockEndDate)) {
				adminDAO.setBlockIpDelete(vos.get(i).getHostIp());
				adminDAO.setReportMemberChange(vos.get(i).getHostIp());
			}
		}
	}
	
}
