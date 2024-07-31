package com.spring.javaclassS9.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS9.vo.BlockIpVO;
import com.spring.javaclassS9.vo.ConsultingVO;
import com.spring.javaclassS9.vo.DeleteMemberVO;
import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.FaqVO;
import com.spring.javaclassS9.vo.MemberVO;
import com.spring.javaclassS9.vo.NoticeVO;
import com.spring.javaclassS9.vo.ReportVO;

public interface AdminDAO {

	public ArrayList<MemberVO> getAllMemberList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public int setMemberLevelUpdateOk(@Param("mid") String mid);

	public int setMemberDeleteAll(@Param("mid") String mid);

	public ArrayList<MemberVO> getMemberLevelList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("m_group") String m_group);

	public ArrayList<MemberVO> getMemberSearchList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("part") String part, @Param("searchString") String searchString);

	public int setEngineerDelete(@Param("vo") EngineerVO vo);

	public int setProductDeleteOk(@Param("idx") int idx);

	public int setProductSaleChange(@Param("idx") int idx, @Param("statement") String statement);

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
	
	public int setReportRecruitBoardDelete(@Param("idx") int idx);

	public void setReportContentDelete(@Param("idx") int idx);

	public int adminAsRequestTotRecCnt();

	public int adminAsRequestTotRecCntSearch(@Param("search") String search, @Param("searchString") String searchString);

	public int setConsultingInput(@Param("vo") ConsultingVO vo);

	public ArrayList<ConsultingVO> getConsultingList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("search") String search, @Param("searchString") String searchString);

	public int consultingTotRecCnt();

	public int consultingTotRecCntSearch(@Param("search") String search, @Param("searchString") String searchString);

	public int getNewConsultingCount();

	public ConsultingVO getConsultingContent(@Param("idx") int idx);

	public int setConsultingAnswer(@Param("idx") int idx, @Param("answer") String answer);

	public ReportVO getReportBoardContent(@Param("idx") int idx, @Param("board") String board);

	public void setReportSameContentDelete(@Param("idx") int idx);

	public NoticeVO getPopupNoticeContent();

	public int setPopupNoticeDelete();

	public int setNoticeInputOk(@Param("vo") NoticeVO vo);

	public ArrayList<NoticeVO> getImportantNoticeList();

	public int noticeTotRecCnt();

	public int noticeTotRecCntSearch(@Param("search") String search, @Param("searchString") String searchString);

	public ArrayList<NoticeVO> getNoticeListAll(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("search") String part, @Param("searchString") String searchString);

	public NoticeVO getNoticeContent(@Param("idx") int idx);

	public int setNoticeDelete(@Param("idx") int idx);

	public int setNoticeEdit(@Param("vo") NoticeVO vo);

	public int getNewPaymentCount();

	public int getNewMessageCount();

	public int faqTotRecCnt();

	public int faqTotRecCntSearch(@Param("searchString") String searchString);

	public int faqInputOk(@Param("vo") FaqVO vo);

	public ArrayList<FaqVO> getFaqList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("part") String part, @Param("searchString") String searchString);

	public int faqTotRecCntPart(@Param("part") String part);

	public FaqVO getFaqContent(@Param("idx") int idx);

	public String[] getFaqParts();

	public int faqEditOk(@Param("vo") FaqVO vo);

	public int faqDeleteOk(@Param("idx") int idx);

	public BlockIpVO getBlockIp(@Param("hostIp") String hostIp);

	public int setBlockIpInput(@Param("hostIp") String hostIp);

	public ArrayList<BlockIpVO> getBlockIpList();

	public int setBlockIpDelete(@Param("hostIp") String hostIp);

	public int setNewChatCount();

	public int getNewChatCount();

	public int setNewChatCountDelete();

	public int getLevelChangeMemberCount();

}
