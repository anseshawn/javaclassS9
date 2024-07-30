package com.spring.javaclassS9.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaclassS9.dao.MemberDAO;
import com.spring.javaclassS9.vo.ConsultingVO;
import com.spring.javaclassS9.vo.MemberVO;
import com.spring.javaclassS9.vo.MessageVO;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired
	MemberDAO memberDAO;

	@Override
	public MemberVO getMemberIdCheck(String mid) {
		return memberDAO.getMemberIdCheck(mid);
	}

	@Override
	public MemberVO getMemberNickCheck(String nickName) {
		return memberDAO.getMemberNickCheck(nickName);
	}

	@Override
	public int setMemberJoinOk(MemberVO vo) {
		return memberDAO.setMemberJoinOk(vo);
	}

	@Override
	public MemberVO getMemberNameCheck(String name) {
		return memberDAO.getMemberNameCheck(name);
	}

	@Override
	public int setMemberPwdUpdate(String mid, String pwd) {
		return memberDAO.setMemberPwdUpdate(mid,pwd);
	}

	@Override
	public int setMemberUpdateOk(MemberVO vo) {
		return memberDAO.setMemberUpdateOk(vo);
	}

	@Override
	public int setMemberDeleteOk(String mid) {
		return memberDAO.setMemberDeleteOk(mid);
	}

	@Override
	public int setMessageInputOk(MessageVO vo) {
		return memberDAO.setMessageInputOk(vo);
	}

	@Override
	public ArrayList<MessageVO> getAllReceiveMessageList(String mid) {
		return memberDAO.getAllReceiveMessageList(mid);
	}

	@Override
	public ArrayList<MessageVO> getAllSendMessageList(String mid) {
		return memberDAO.getAllSendMessageList(mid);
	}

	@Override
	public void setMessageCheck(int idx) {
		memberDAO.setMessageCheck(idx);
	}

	@Override
	public int setMessageDelete(int idx, String sw) {
		return memberDAO.setMessageDelete(idx, sw);
	}

	@Override
	public int setMessageDeleteDB(int idx) {
		return memberDAO.setMessageDeleteDB(idx);
	}

	@Override
	public ArrayList<ConsultingVO> getConsultingList(int startIndexNo, int pageSize, String name, String email) {
		return memberDAO.getConsultingList(startIndexNo, pageSize, name, email);
	}

	@Override
	public ConsultingVO getConsultingContent(int idx) {
		return memberDAO.getConsultingContent(idx);
	}

	@Override
	public void setKakaoMemberInput(String mid, String pwd, String nickName, String email) {
		memberDAO.setKakaoMemberInput(mid,pwd,nickName,email);
	}
}
