package com.spring.javaclassS9.service;

import java.util.ArrayList;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS9.vo.EngineerVO;

public interface EngineerService {

	public EngineerVO getEngineerIdCheck(String mid);

	public int setEngineerJoinOk(MultipartFile fName, EngineerVO vo);

	public ArrayList<EngineerVO> getEngineerSearchList(int startIndexNo, int pageSize, String part, String searchString);

	public ArrayList<EngineerVO> getAllEngineerList(int startIndexNo, int pageSize);

	public EngineerVO getEngineerIdxCheck(int idx);

	public int setEngineerPwdUpdate(String mid, String pwd);

	public int setEngineerUpdateOk(MultipartFile fName, EngineerVO vo);

}
