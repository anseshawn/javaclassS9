package com.spring.javaclassS9.service;

import java.util.ArrayList;

import com.spring.javaclassS9.vo.AsRequestVO;
import com.spring.javaclassS9.vo.AsRequestVO.Progress;
import com.spring.javaclassS9.vo.ReviewVO;

public interface CustomerService {

	public int setAsAppointmentOk(AsRequestVO vo);

	public ArrayList<AsRequestVO> getAsRequestList(String asMid, int startIndexNo, int pageSize);

	public AsRequestVO getAsRequestContent(int idx);

	public int setReviewInput(ReviewVO vo);

	public int getReviewSearch(int idx);

	public int setAsChangeStatement(int idx, Progress progress);

}
