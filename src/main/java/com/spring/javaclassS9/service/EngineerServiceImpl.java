package com.spring.javaclassS9.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS9.common.JavaclassProvide;
import com.spring.javaclassS9.dao.EngineerDAO;
import com.spring.javaclassS9.vo.AsRequestVO;
import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.Message2VO;
import com.spring.javaclassS9.vo.ScheduleVO;

@Service
public class EngineerServiceImpl implements EngineerService {
	
	@Autowired
	EngineerDAO engineerDAO;
	
	@Autowired
	JavaclassProvide javaclassProvide;

	@Override
	public EngineerVO getEngineerIdCheck(String mid) {
		return engineerDAO.getEngineerIdCheck(mid);
	}

	@Override
	public int setEngineerJoinOk(MultipartFile fName, EngineerVO vo) {
		int res = 0;
		
		String oFileName = fName.getOriginalFilename();
		String sFileName = "";
		if(fName != null && oFileName != "") {
			sFileName = vo.getMid()+"_"+javaclassProvide.saveFileName(oFileName);
			try {
				javaclassProvide.writeFile(fName, sFileName, "engineer");
				res = 1;
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if(res != 0) vo.setPhoto(sFileName);
		else vo.setPhoto("noimage.jpg");
		
		return engineerDAO.setEngineerJoinOk(vo);
	}

	@Override
	public ArrayList<EngineerVO> getEngineerSearchList(int startIndexNo, int pageSize, String part, String searchString) {
		return engineerDAO.getEngineerSearchList(startIndexNo, pageSize, part, searchString);
	}

	@Override
	public ArrayList<EngineerVO> getAllEngineerList(int startIndexNo, int pageSize) {
		return engineerDAO.getAllEngineerList(startIndexNo, pageSize);
	}

	@Override
	public EngineerVO getEngineerIdxCheck(int idx) {
		return engineerDAO.getEngineerIdxCheck(idx);
	}

	@Override
	public int setEngineerPwdUpdate(String mid, String pwd) {
		return engineerDAO.setEngineerPwdUpdate(mid, pwd);
	}

	@Override
	public int setEngineerUpdateOk(MultipartFile fName, EngineerVO vo) {
		int res = 0;
		String oFileName = fName.getOriginalFilename();
		String sFileName = "";
		if(oFileName != "" && !oFileName.equals(vo.getOriginPhoto())) {
			sFileName = javaclassProvide.saveFileName(oFileName);
			try {
				javaclassProvide.deleteFile(vo.getOriginPhoto(), "engineer");
				javaclassProvide.writeFile(fName, sFileName, "engineer");
				res = 1;
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if(res != 0) vo.setPhoto(sFileName);
		else vo.setPhoto(vo.getOriginPhoto());
		return engineerDAO.setEngineerUpdateOk(vo);
	}

	@Override
	public void setEngineerMidChange(String mid, int idx) {
		engineerDAO.setEngineerMidChange(mid, idx);
	}

	@Override
	public ArrayList<ScheduleVO> getScheduleListAll() {
		return engineerDAO.getScheduleListAll();
	}

	@Override
	public int setScheduleDeleteTrue(String title, int engineerIdx, String formattedStartTime) {
		return engineerDAO.setScheduleDeleteTrue(title,engineerIdx,formattedStartTime);
	}

	@Override
	public int setScheduleDelete(String title, int engineerIdx, String formattedStartTime, String formattedEndTime, Boolean allDay) {
		return engineerDAO.setScheduleDelete(title,engineerIdx,formattedStartTime, formattedEndTime, allDay);
	}

	@Override
	public int setScheduleInput(ScheduleVO vo) {
		return engineerDAO.setScheduleInput(vo);
	}

	@Override
	public int setScheduleUpdate(ScheduleVO vo) {
		return engineerDAO.setScheduleUpdate(vo);
	}

	@Override
	public ArrayList<ScheduleVO> getScheduleListOne(int engineerIdx) {
		return engineerDAO.getScheduleListOne(engineerIdx);
	}

	@Override
	public ArrayList<AsRequestVO> getAsRequestList(int idx,int startIndexNo, int pageSize) {
		return engineerDAO.getAsRequestList(idx,startIndexNo,pageSize);
	}

	@Override
	public AsRequestVO getAsRequestContent(int idx) {
		return engineerDAO.getAsRequestContent(idx);
	}

	@Override
	public EngineerVO getEngineerNameCheck(String engineerName) {
		return engineerDAO.getEngineerNameCheck(engineerName);
	}

	@Override
	public ArrayList<AsRequestVO> getAllAsRequestList(int startIndexNo, int pageSize, String search, String searchString) {
		return engineerDAO.getAllAsRequestList(startIndexNo, pageSize, search, searchString);
	}

	@Override
	public ArrayList<ScheduleVO> getEngineerSchedule(int idx) {
		return engineerDAO.getEngineerSchedule(idx);
	}

	@Override
	public int setMessageInputOk(Message2VO vo) {
		return engineerDAO.setMessageInputOk(vo);
	}

	@Override
	public ArrayList<Message2VO> getAllReceiveMessageList(String mid) {
		return engineerDAO.getAllReceiveMessageList(mid);
	}

	@Override
	public ArrayList<Message2VO> getAllSendMessageList(String mid) {
		return engineerDAO.getAllSendMessageList(mid);
	}

	@Override
	public void setMessageCheck(int idx) {
		engineerDAO.setMessageCheck(idx);
	}

	@Override
	public int setMessageDelete(int idx, String sw) {
		return engineerDAO.setMessageDelete(idx, sw);
	}

	@Override
	public int setMessageDeleteDB(int idx) {
		return engineerDAO.setMessageDeleteDB(idx);
	}

}
