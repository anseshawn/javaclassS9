package com.spring.javaclassS9.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.javaclassS9.common.JavaclassProvide;
import com.spring.javaclassS9.dao.AdminDAO;
import com.spring.javaclassS9.dao.BoardDAO;
import com.spring.javaclassS9.vo.ConsultingVO;
import com.spring.javaclassS9.vo.DeleteMemberVO;
import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.FaqVO;
import com.spring.javaclassS9.vo.FreeBoardVO;
import com.spring.javaclassS9.vo.MemberVO;
import com.spring.javaclassS9.vo.NoticeVO;
import com.spring.javaclassS9.vo.QuestionBoardVO;
import com.spring.javaclassS9.vo.RecruitBoardVO;
import com.spring.javaclassS9.vo.ReplyVO;
import com.spring.javaclassS9.vo.ReportVO;

@Service
public class AdminServiceImpl implements AdminService {

	@Autowired
	AdminDAO adminDAO;
	
	@Autowired
	BoardDAO boardDAO;
	
	@Autowired
	JavaclassProvide javaclassProvide;
	
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

	@Transactional
	@Override
	public int setEngineerDelete(EngineerVO vo) {
		if(!vo.getPhoto().equals("noimage.jpg")) {
			javaclassProvide.deleteFile(vo.getPhoto(), "engineer");
			vo.setPhoto("noimage.jpg");
		}
		return adminDAO.setEngineerDelete(vo);
	}

	@Override
	public int setProductDeleteOk(int idx) {
		return adminDAO.setProductDeleteOk(idx);
	}

	@Override
	public int setProductSaleChange(int idx, String statement) {
		return adminDAO.setProductSaleChange(idx, statement);
	}

	@Override
	public int getJoinMemberCount() {
		return adminDAO.getJoinMemberCount();
	}

	// 회원 탈퇴시 탈퇴 사유 DB에 저장
	@Override
	public void setMemberDeleteReason(String deleteReason, String etcReason) {
		DeleteMemberVO vo = new DeleteMemberVO();
		int reason = Integer.parseInt(deleteReason);
		vo.setDeleteReason(reason);
		if(reason==1) vo.setReasonDetail("찾는 제품이 없어서");
		else if(reason==2) vo.setReasonDetail("이용이 불편해서");
		else if(reason==3) vo.setReasonDetail("다른 사이트가 더 좋아서");
		else if(reason==4) vo.setReasonDetail("사용 빈도가 낮아서");
		else if(reason==5) vo.setReasonDetail("콘텐츠 불만");
		else {
			vo.setReasonDetail("기타");
			vo.setEtc(etcReason);
		}
		adminDAO.setMemberDeleteReason(vo);
	}

	@Override
	public ArrayList<DeleteMemberVO> getMemberDeleteReason() {
		return adminDAO.getMemberDeleteReason();
	}

	@Override
	public ArrayList<MemberVO> getMemberJoinDate() {
		return adminDAO.getMemberJoinDate();
	}

	@Override
	public int getProductEstimateCount() {
		return adminDAO.getProductEstimateCount();
	}

	@Override
	public ArrayList<ReportVO> getReportBoardList(int startIndexNo, int pageSize, String search, String searchString) {
		return adminDAO.getReportBoardList(startIndexNo, pageSize, search, searchString);
	}

	@Transactional
	@Override
	public int setReportBoardDelete(int idx, String board) {
		int res = 0;
		ReportVO rVo = adminDAO.getReportBoardContent(idx,"");
		ArrayList<ReplyVO> vos = null;
		if(rVo != null) {
			vos = boardDAO.getBoardReply(board,rVo.getBoardIdx());
			if(vos.size()!=0) {
				for(int j=0; j<vos.size(); j++) {
					boardDAO.setBoardReplyDelete(board, rVo.getBoardIdx(), vos.get(j).getIdx()); // 딸린 댓글 같이 지우기
				}
			}
			if(board.equals("freeBoard")) {
				FreeBoardVO vo = boardDAO.getFreeBoardContent(rVo.getBoardIdx());
				if(vo != null) res = adminDAO.setReportFreeBoardDelete(idx);
				else res = 1;
			}
			else if(board.equals("questionBoard")) {
				QuestionBoardVO vo = boardDAO.getQuestionBoardContent(rVo.getBoardIdx());
				if(vo != null) res = adminDAO.setReportQuestionBoardDelete(idx);
				else res = 1;
			}
			else if(board.equals("recruitBoard")) {
				RecruitBoardVO vo = boardDAO.getRecruitBoardContent(rVo.getBoardIdx());
				if(vo != null) res = adminDAO.setReportRecruitBoardDelete(idx);
				else res = 1;
			}
		}
		else res = 1;
		//adminDAO.setReportContentDelete(idx);
		adminDAO.setReportSameContentDelete(idx);
		return res;
	}

	@Override
	public int setConsultingInput(ConsultingVO vo) {
		return adminDAO.setConsultingInput(vo);
	}

	@Override
	public ArrayList<ConsultingVO> getConsultingList(int startIndexNo, int pageSize, String part, String searchString) {
		return adminDAO.getConsultingList(startIndexNo, pageSize, part, searchString);
	}

	@Override
	public int getNewConsultingCount() {
		return adminDAO.getNewConsultingCount();
	}

	@Override
	public ConsultingVO getConsultingContent(int idx) {
		return adminDAO.getConsultingContent(idx);
	}

	@Override
	public int setConsultingAnswer(int idx, String answer) {
		return adminDAO.setConsultingAnswer(idx,answer);
	}

	@Override
	public ReportVO getReportBoardContent(int idx, String board) {
		return adminDAO.getReportBoardContent(idx, board);
	}

	@Override
	public NoticeVO getPopupNoticeContent() {
		return adminDAO.getPopupNoticeContent();
	}

	@Override
	public int setPopupNoticeDelete() {
		return adminDAO.setPopupNoticeDelete();
	}

	@Override
	public int setNoticeInputOk(NoticeVO vo) {
		return adminDAO.setNoticeInputOk(vo);
	}

	@Override
	public ArrayList<NoticeVO> getImportantNoticeList() {
		return adminDAO.getImportantNoticeList();
	}

	@Override
	public ArrayList<NoticeVO> getNoticeListAll(int startIndexNo, int pageSize, String part, String searchString) {
		return adminDAO.getNoticeListAll(startIndexNo,pageSize,part,searchString);
	}

	@Override
	public NoticeVO getNoticeContent(int idx) {
		return adminDAO.getNoticeContent(idx);
	}

	@Override
	public int setNoticeDelete(int idx) {
		return adminDAO.setNoticeDelete(idx);
	}

	@Override
	public int setNoticeEdit(NoticeVO vo) {
		return adminDAO.setNoticeEdit(vo);
	}

	@Override
	public int getNewPaymentCount() {
		return adminDAO.getNewPaymentCount();
	}

	@Override
	public int getNewMessageCount() {
		return adminDAO.getNewMessageCount();
	}

	@Override
	public int faqInputOk(FaqVO vo) {
		return adminDAO.faqInputOk(vo);
	}

	@Override
	public ArrayList<FaqVO> getFaqList(int startIndexNo, int pageSize, String part, String searchString) {
		return adminDAO.getFaqList(startIndexNo,pageSize,part,searchString);
	}

	@Override
	public FaqVO getFaqContent(int idx) {
		return adminDAO.getFaqContent(idx);
	}

	@Override
	public String[] getFaqParts() {
		return adminDAO.getFaqParts();
	}

	@Override
	public int faqEditOk(FaqVO vo) {
		return adminDAO.faqEditOk(vo);
	}

	@Override
	public int faqDeleteOk(int idx) {
		return adminDAO.faqDeleteOk(idx);
	}
}
