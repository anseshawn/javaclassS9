package com.spring.javaclassS9.service;

import java.util.ArrayList;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS9.vo.AsRequestVO;
import com.spring.javaclassS9.vo.EngineerVO;
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

}
