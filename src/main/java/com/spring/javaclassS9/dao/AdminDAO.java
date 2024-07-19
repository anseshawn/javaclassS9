package com.spring.javaclassS9.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.MemberVO;

public interface AdminDAO {

	public ArrayList<MemberVO> getAllMemberList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public int setMemberLevelUpdateOk(@Param("mid") String mid);

	public int setMemberDeleteAll(@Param("mid") String mid);

	public ArrayList<MemberVO> getMemberLevelList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("m_group") String m_group);

	public ArrayList<MemberVO> getMemberSearchList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("part") String part, @Param("searchString") String searchString);

	public int setEngineerDeleteAll(@Param("mid") String mid);

	public int setProductDeleteOk(@Param("idx") int idx);

	public int setProductEstimateChange(@Param("idx") int idx, @Param("statement") String statement);

	public int getJoinMemberCount();

}
