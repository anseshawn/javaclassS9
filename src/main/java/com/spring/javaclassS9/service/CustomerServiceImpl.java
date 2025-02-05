package com.spring.javaclassS9.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaclassS9.dao.CustomerDAO;
import com.spring.javaclassS9.dao.EngineerDAO;
import com.spring.javaclassS9.vo.AsChargeVO;
import com.spring.javaclassS9.vo.AsRequestVO;
import com.spring.javaclassS9.vo.AsRequestVO.Machine;
import com.spring.javaclassS9.vo.AsRequestVO.Progress;
import com.spring.javaclassS9.vo.ReviewVO;
import com.spring.javaclassS9.vo.AsChargeVO.Statement;

@Service
public class CustomerServiceImpl implements CustomerService {

	@Autowired
	CustomerDAO customerDAO;
	
	@Autowired
	EngineerDAO engineerDAO;

	@Override
	public int setAsAppointmentOk(AsRequestVO vo) {
		if(vo.getMachine().toString().toUpperCase().equals("UV")) vo.setMachine(Machine.UV);
		else if(vo.getMachine().toString().toUpperCase().equals("AAS")) vo.setMachine(Machine.AAs);
		else if(vo.getMachine().toString().toUpperCase().equals("ICP")) vo.setMachine(Machine.ICP);
		else if(vo.getMachine().toString().toUpperCase().equals("GC")) vo.setMachine(Machine.GC);
		else if(vo.getMachine().toString().toUpperCase().equals("LC")) vo.setMachine(Machine.LC);
		else if(vo.getMachine().toString().toUpperCase().equals("ETC")) vo.setMachine(Machine.etc);
		vo.setProgress(Progress.REGIST);
		return customerDAO.setAsAppointmentOk(vo);
	}

	@Override
	public ArrayList<AsRequestVO> getAsRequestList(String asMid, int startIndexNo, int pageSize) {
		return customerDAO.getAsRequestList(asMid, startIndexNo, pageSize);
	}

	@Override
	public AsRequestVO getAsRequestContent(int idx) {
		return customerDAO.getAsRequestContent(idx);
	}

	@Override
	public int setReviewInput(ReviewVO vo) {
		ArrayList<ReviewVO> vos = customerDAO.getReviewList(vo.getEngineerIdx());
		int starTot = 0;
		for(ReviewVO rVo : vos) {
			starTot += rVo.getStarPoint();
		}
		starTot += vo.getStarPoint();
		double starAvg = 0.0;
		if(vos.size() != 0) starAvg = ((double)starTot/(vos.size()+1));
		else starAvg = vo.getStarPoint();
		
		int res = engineerDAO.setEngineerReviewInput(vo.getEngineerIdx(), starAvg); // 엔지니어 DB에 별점 저장
		if(res != 0)	return customerDAO.setReviewInput(vo);
		else return 0;
	}

	@Override
	public int getReviewSearch(int idx) {
		return customerDAO.getReviewSearch(idx);
	}

	@Override
	public int setAsChangeStatement(int idx, String asDate, Progress progress) {
		return customerDAO.setAsChangeStatement(idx, asDate, progress);
	}

	@Override
	public int setAsAppointmentComplete(AsRequestVO vo) {
		return customerDAO.setAsAppointmentComplete(vo);
	}

	@Override
	public ArrayList<ReviewVO> getReviewList(int engineerIdx) {
		return customerDAO.getReviewList(engineerIdx);
	}

	@Override
	public int setAsChargeInput(AsChargeVO vo) {
		vo.setStatement(Statement.WAITING);
		return customerDAO.setAsChargeInput(vo);
	}

	@Override
	public AsChargeVO getAsChargeContent(int asIdx) {
		return customerDAO.getAsChargeContent(asIdx);
	}

	@Override
	public int setAsChargePaymentOk(int asIdx) {
		return customerDAO.setAsChargePaymentOk(asIdx);
	}

	@Override
	public int setAsCompleteStatement(int idx) {
		return customerDAO.setAsCompleteStatement(idx);
	}

	@Override
	public int setAsDeleteOk(int idx) {
		return customerDAO.setAsDeleteOk(idx);
	}

	@Override
	public AsRequestVO getAsRequestScheduleName(String asName) {
		return customerDAO.getAsRequestScheduleName(asName);
	}

	@Override
	public void setAsAppointmentChange(String asName, String asDate) {
		customerDAO.setAsAppointmentChange(asName,asDate);
	}

	@Override
	public ArrayList<AsRequestVO> getAsRequestDateList(int startIndexNo, int pageSize, String asMid,
			String startSearchDate, String endSearchDate) {
		return customerDAO.getAsRequestDateList(startIndexNo,pageSize,asMid,startSearchDate,endSearchDate);
	}

}
