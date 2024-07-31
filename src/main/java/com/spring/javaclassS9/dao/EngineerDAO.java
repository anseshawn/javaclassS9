package com.spring.javaclassS9.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS9.vo.AsRequestVO;
import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.Message2VO;
import com.spring.javaclassS9.vo.ScheduleVO;

public interface EngineerDAO {

	public EngineerVO getEngineerIdCheck(@Param("mid") String mid);

	public int setEngineerJoinOk(@Param("vo") EngineerVO vo);

	public int totRecCnt();

	public int totRecCntSearch(@Param("search") String search, @Param("searchString") String searchString);

	public ArrayList<EngineerVO> getEngineerSearchList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("part") String part, @Param("searchString") String searchString);

	public ArrayList<EngineerVO> getAllEngineerList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public EngineerVO getEngineerIdxCheck(@Param("idx") int idx);

	public int setEngineerReviewInput(@Param("idx") int engineerIdx, @Param("starPoint") double starAvg);

	public int setEngineerPwdUpdate(@Param("mid") String mid, @Param("pwd") String pwd);

	public int setEngineerUpdateOk(@Param("vo") EngineerVO vo);

	public void setEngineerMidChange(@Param("mid") String mid, @Param("idx") int idx);

	public ArrayList<ScheduleVO> getScheduleListAll();

	public int setScheduleDeleteTrue(@Param("title") String title, @Param("engineerIdx") int engineerIdx, @Param("startTime") String formattedStartTime);

	public int setScheduleDelete(@Param("title")String title, @Param("engineerIdx") int engineerIdx,
			@Param("startTime") String formattedStartTime, @Param("endTime") String formattedEndTime,
			@Param("allDay") Boolean allDay);

	public int setScheduleInput(@Param("vo") ScheduleVO vo);

	public int setScheduleUpdate(@Param("vo") ScheduleVO vo);

	public ArrayList<ScheduleVO> getScheduleListOne(@Param("engineerIdx") int engineerIdx);

	public ArrayList<AsRequestVO> getAsRequestList(@Param("idx") int idx, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public int totAsRequestRecCnt(@Param("searchString") String searchString);

	public AsRequestVO getAsRequestContent(@Param("idx") int idx);

	public EngineerVO getEngineerNameCheck(@Param("name") String engineerName);

	public ArrayList<AsRequestVO> getAllAsRequestList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("search") String search, @Param("searchString") String searchString);

	public ArrayList<ScheduleVO> getEngineerSchedule(@Param("engineerIdx") int idx);

	public int setMessageInputOk(@Param("vo") Message2VO vo);

	public ArrayList<Message2VO> getAllReceiveMessageList(@Param("mid") String mid);

	public ArrayList<Message2VO> getAllSendMessageList(@Param("mid") String mid);

	public void setMessageCheck(@Param("idx") int idx);

	public int setMessageDelete(@Param("idx") int idx, @Param("sw") String sw);

	public int setMessageDeleteDB(@Param("idx") int idx);

}
