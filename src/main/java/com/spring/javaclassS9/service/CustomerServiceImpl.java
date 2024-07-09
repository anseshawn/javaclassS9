package com.spring.javaclassS9.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaclassS9.dao.CustomerDAO;
import com.spring.javaclassS9.vo.AsRequestVO;
import com.spring.javaclassS9.vo.AsRequestVO.Instrument;
import com.spring.javaclassS9.vo.AsRequestVO.Progress;

@Service
public class CustomerServiceImpl implements CustomerService {

	@Autowired
	CustomerDAO customerDAO;

	@Override
	public int setAsAppointmentOk(AsRequestVO vo) {
		if(vo.getInstrument().toString().toUpperCase().equals("UV")) vo.setInstrument(Instrument.UV);
		else if(vo.getInstrument().toString().toUpperCase().equals("AAS")) vo.setInstrument(Instrument.AAs);
		else if(vo.getInstrument().toString().toUpperCase().equals("ICP")) vo.setInstrument(Instrument.ICP);
		else if(vo.getInstrument().toString().toUpperCase().equals("GC")) vo.setInstrument(Instrument.GC);
		else if(vo.getInstrument().toString().toUpperCase().equals("LC")) vo.setInstrument(Instrument.LC);
		else if(vo.getInstrument().toString().toUpperCase().equals("ETC")) vo.setInstrument(Instrument.etc);
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
	
	
}
