package com.spring.javaclassS9.service;

import java.util.ArrayList;

import com.spring.javaclassS9.vo.BlockIpVO;
import com.spring.javaclassS9.vo.ConsultingVO;
import com.spring.javaclassS9.vo.DeleteMemberVO;
import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.FaqVO;
import com.spring.javaclassS9.vo.MemberVO;
import com.spring.javaclassS9.vo.NoticeVO;
import com.spring.javaclassS9.vo.ReportMemberVO;
import com.spring.javaclassS9.vo.ReportVO;

public interface AdminService {

	public ArrayList<MemberVO> getAllMemberList(int startIndexNo, int pageSize);

	public int setMemberLevelUpdateOk(String mid);

	public int setMemberDeleteAll(MemberVO vo);

	public ArrayList<MemberVO> getMemberLevelList(int startIndexNo, int pageSize, String m_group);

	public ArrayList<MemberVO> getMemberSearchList(int startIndexNo, int pageSize, String part, String searchString);

	public int setEngineerDelete(EngineerVO vo);

	public int setProductDeleteOk(int idx);

	public int setProductSaleChange(int idx, String statement);

	public int getJoinMemberCount();

	public void setMemberDeleteReason(String deleteReason, String etcReason);

	public ArrayList<DeleteMemberVO> getMemberDeleteReason();

	public ArrayList<MemberVO> getMemberJoinDate();

	public int getProductEstimateCount();

	public ArrayList<ReportVO> getReportBoardList(int startIndexNo, int pageSize, String search, String searchString);

	public int setReportBoardDelete(int idx, String board);

	public int setConsultingInput(ConsultingVO vo);

	public ArrayList<ConsultingVO> getConsultingList(int startIndexNo, int pageSize, String part, String searchString);

	public int getNewConsultingCount();

	public ConsultingVO getConsultingContent(int idx);

	public int setConsultingAnswer(int idx, String answer);

	public ReportVO getReportBoardContent(int idx, String board);

	public NoticeVO getPopupNoticeContent();

	public int setPopupNoticeDelete();

	public int setNoticeInputOk(NoticeVO vo);

	public ArrayList<NoticeVO> getImportantNoticeList();

	public ArrayList<NoticeVO> getNoticeListAll(int startIndexNo, int pageSize, String part, String searchString);

	public NoticeVO getNoticeContent(int idx);

	public int setNoticeDelete(int idx);

	public int setNoticeEdit(NoticeVO vo);

	public int getNewPaymentCount();

	public int getNewMessageCount();

	public int faqInputOk(FaqVO vo);

	public ArrayList<FaqVO> getFaqList(int startIndexNo, int pageSize, String part, String searchString);

	public FaqVO getFaqContent(int idx);

	public String[] getFaqParts();

	public int faqEditOk(FaqVO vo);

	public int faqDeleteOk(int idx);

	public BlockIpVO getBlockIp(String hostIp);

	public int setBlockIpInput(String hostIp);

	public int setBlockIpDelete(String hostIp);

	public int setNewChatCount();

	public int setAddChatCount();
	
	public int getNewChatCount();

	public int setNewChatCountDelete();

	public int getLevelChangeMemberCount();

	public int setDeleteReportMember(String ip);

	public int setMemberDeleteDB(String mid);

}
