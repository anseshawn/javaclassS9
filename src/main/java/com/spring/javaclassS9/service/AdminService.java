package com.spring.javaclassS9.service;

import java.util.ArrayList;

import com.spring.javaclassS9.vo.DeleteMemberVO;
import com.spring.javaclassS9.vo.MemberVO;

public interface AdminService {

	public ArrayList<MemberVO> getAllMemberList(int startIndexNo, int pageSize);

	public int setMemberLevelUpdateOk(String mid);

	public int setMemberDeleteAll(String mid);

	public ArrayList<MemberVO> getMemberLevelList(int startIndexNo, int pageSize, String m_group);

	public ArrayList<MemberVO> getMemberSearchList(int startIndexNo, int pageSize, String part, String searchString);

	public int setEngineerDeleteAll(String mid);

	public int setProductDeleteOk(int idx);

	public int setProductEstimateChange(int idx, String statement);

	public int getJoinMemberCount();

	public void setMemberDeleteReason(String deleteReason, String etcReason);

	public ArrayList<DeleteMemberVO> getMemberDeleteReason();

	public ArrayList<MemberVO> getMemberJoinDate();

	public int getProductEstimateCount();

}
