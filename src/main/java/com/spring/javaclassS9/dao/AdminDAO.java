package com.spring.javaclassS9.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS9.vo.MemberVO;

public interface AdminDAO {

	public ArrayList<MemberVO> getAllMemberList();

	public int setMemberLevelUpdateOk(@Param("mid") String mid);

	public int setMemberDeleteAll(@Param("mid") String mid);

	public ArrayList<MemberVO> getMemberLevelList(@Param("m_group") String m_group);

}
