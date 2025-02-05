package com.spring.javaclassS9.service;

import java.util.ArrayList;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS9.vo.AsRequestVO;
import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.Message2VO;
import com.spring.javaclassS9.vo.MessageVO;
import com.spring.javaclassS9.vo.ScheduleVO;

public interface EngineerService {

	public EngineerVO getEngineerIdCheck(String mid);

	public int setEngineerJoinOk(MultipartFile fName, EngineerVO vo);

	public ArrayList<EngineerVO> getEngineerSearchList(int startIndexNo, int pageSize, String part, String searchString);

	public ArrayList<EngineerVO> getAllEngineerList(int startIndexNo, int pageSize);

	public EngineerVO getEngineerIdxCheck(int idx);

	public int setEngineerPwdUpdate(String mid, String pwd);

	public int setEngineerUpdateOk(MultipartFile fName, EngineerVO vo);

	public void setEngineerMidChange(String mid, int idx);

	public ArrayList<ScheduleVO> getScheduleListAll();

	public int setScheduleDeleteTrue(String title, int engineerIdx, String formattedStartTime);

	public int setScheduleDelete(String title, int engineerIdx, String formattedStartTime, String formattedEndTime, Boolean allDay);

	public int setScheduleInput(ScheduleVO vo);

	public int setScheduleUpdate(ScheduleVO vo);

	public ArrayList<ScheduleVO> getScheduleListOne(int engineerIdx);

	public ArrayList<AsRequestVO> getAsRequestList(int idx, int startIndexNo, int pageSize);

	public AsRequestVO getAsRequestContent(int idx);

	public EngineerVO getEngineerNameCheck(String engineerName);

	public ArrayList<AsRequestVO> getAllAsRequestList(int startIndexNo, int pageSize, String search, String searchString);

	public ArrayList<ScheduleVO> getEngineerSchedule(int idx);
	
	public int setMessageInputOk(Message2VO vo);

	public ArrayList<Message2VO> getAllReceiveMessageList(String mid);

	public ArrayList<Message2VO> getAllSendMessageList(String mid);

	public void setMessageCheck(int idx);

	public int setMessageDelete(int idx, String sw);

	public int setMessageDeleteDB(int idx);

	public ArrayList<AsRequestVO> getAllAsRequestDateList(int startIndexNo, int pageSize, String startSearchDate,
			String endSearchDate);

	public ArrayList<AsRequestVO> getAsRequestDateList(int startIndexNo, int pageSize, int engineerIdx, String startSearchDate,
			String endSearchDate);

}
