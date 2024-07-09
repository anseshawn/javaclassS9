package com.spring.javaclassS9.service;

import java.util.ArrayList;

import com.spring.javaclassS9.vo.AsRequestVO;

public interface CustomerService {

	public int setAsAppointmentOk(AsRequestVO vo);

	public ArrayList<AsRequestVO> getAsRequestList(String asMid, int startIndexNo, int pageSize);

	public AsRequestVO getAsRequestContent(int idx);

}
