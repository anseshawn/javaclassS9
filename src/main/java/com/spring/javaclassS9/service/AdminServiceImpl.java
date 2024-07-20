package com.spring.javaclassS9.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaclassS9.dao.AdminDAO;
import com.spring.javaclassS9.vo.DeleteMemberVO;
import com.spring.javaclassS9.vo.MemberVO;
import com.spring.javaclassS9.vo.ReportVO;

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

	@Override
	public int setProductEstimateChange(int idx, String statement) {
		return adminDAO.setProductEstimateChange(idx, statement);
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

	@Override
	public int setReportBoardDelete(int idx, String board) {
		int res = 0;
		if(board.equals("freeBoard")) res = adminDAO.setReportFreeBoardDelete(idx);
		else if(board.equals("questionBoard")) res = adminDAO.setReportQuestionBoardDelete(idx);
		adminDAO.setReportContentDelete(idx);
		return res;
	}
}
