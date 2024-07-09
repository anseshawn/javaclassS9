package com.spring.javaclassS9.service;

import java.util.ArrayList;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS9.common.JavaclassProvide;
import com.spring.javaclassS9.dao.EngineerDAO;
import com.spring.javaclassS9.vo.EngineerVO;

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
}
