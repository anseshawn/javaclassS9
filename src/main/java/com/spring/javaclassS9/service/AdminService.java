package com.spring.javaclassS9.service;

import java.util.ArrayList;

import com.spring.javaclassS9.vo.MemberVO;

public interface AdminService {

	public ArrayList<MemberVO> getAllMemberList();

	public int setMemberLevelUpdateOk(String mid);

	public int setMemberDeleteAll(String mid);

	public ArrayList<MemberVO> getMemberLevelList(String m_group);

}
