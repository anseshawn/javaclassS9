package com.spring.javaclassS9.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS9.vo.DeleteMemberVO;
import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.MemberVO;
import com.spring.javaclassS9.vo.ReportVO;

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

	public void setMemberDeleteReason(DeleteMemberVO vo);

	public ArrayList<DeleteMemberVO> getMemberDeleteReason();

	public ArrayList<MemberVO> getMemberJoinDate();

	public int getProductEstimateCount();

	public int reportBoardTotRecCnt();

	public int reportBoardTotRecCntSearch(@Param("search") String search, @Param("searchString") String searchString);

	public ArrayList<ReportVO> getReportBoardList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("search") String search, @Param("searchString") String searchString);

	public int setReportFreeBoardDelete(@Param("idx") int idx);

	public int setReportQuestionBoardDelete(@Param("idx") int idx);

	public void setReportContentDelete(@Param("idx") int idx);

}
