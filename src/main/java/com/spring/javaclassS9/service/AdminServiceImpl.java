package com.spring.javaclassS9.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaclassS9.dao.AdminDAO;
import com.spring.javaclassS9.vo.MemberVO;

@Service
public class AdminServiceImpl implements AdminService {

	@Autowired
	AdminDAO adminDAO;
	
	@Override
	public ArrayList<MemberVO> getAllMemberList(int startIndexNo, int pageSize) {
		return adminDAO.getAllMemberList(startIndexNo, pageSize);
	}

	@Override
	public int setMemberLevelUpdateOk(String mid) {
		return adminDAO.setMemberLevelUpdateOk(mid);
	}

	@Override
	public int setMemberDeleteAll(String mid) {
		return adminDAO.setMemberDeleteAll(mid);
	}

	@Override
	public ArrayList<MemberVO> getMemberLevelList(int startIndexNo, int pageSize, String m_group) {
		return adminDAO.getMemberLevelList(startIndexNo,pageSize,m_group);
	}

	@Override
	public ArrayList<MemberVO> getMemberSearchList(int startIndexNo, int pageSize, String part, String searchString) {
		return adminDAO.getMemberSearchList(startIndexNo,pageSize,part,searchString);
	}

	@Override
	public int setEngineerDeleteAll(String mid) {
		return adminDAO.setEngineerDeleteAll(mid);
	}

	@Override
	public int setProductDeleteOk(int idx) {
		return adminDAO.setProductDeleteOk(idx);
	}
}
