package com.spring.javaclassS9.service;

import java.util.ArrayList;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.javaclassS9.vo.AsChargeVO;
import com.spring.javaclassS9.vo.AsRequestVO;
import com.spring.javaclassS9.vo.AsRequestVO.Progress;
import com.spring.javaclassS9.vo.RecruitBoardVO;
import com.spring.javaclassS9.vo.ReviewVO;

public interface CustomerService {

	public int setAsAppointmentOk(AsRequestVO vo);

	public ArrayList<AsRequestVO> getAsRequestList(String asMid, int startIndexNo, int pageSize);

	public AsRequestVO getAsRequestContent(int idx);

	public int setReviewInput(ReviewVO vo);

	public int getReviewSearch(int idx);

	public int setAsChangeStatement(int idx, String asDate, Progress progress);

	public int setAsAppointmentComplete(AsRequestVO vo);

	public ArrayList<ReviewVO> getReviewList(int engineerIdx);

	public int setAsChargeInput(AsChargeVO vo);

	public AsChargeVO getAsChargeContent(int idx);

	public int setAsChargePaymentOk(int asIdx);

	public int setAsCompleteStatement(int idx);

	public int setAsDeleteOk(int idx);

	public AsRequestVO getAsRequestScheduleName(String asName);

	public void setAsAppointmentChange(String asName, String asDate);

}
