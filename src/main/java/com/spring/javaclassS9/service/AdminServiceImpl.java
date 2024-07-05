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
	public ArrayList<MemberVO> getAllMemberList() {
		return adminDAO.getAllMemberList();
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
	public ArrayList<MemberVO> getMemberLevelList(String m_group) {
		return adminDAO.getMemberLevelList(m_group);
	}
}
