package com.spring.javaclassS9.service;

import java.util.ArrayList;

import com.spring.javaclassS9.vo.ConsultingVO;
import com.spring.javaclassS9.vo.MemberVO;
import com.spring.javaclassS9.vo.MessageVO;
import com.spring.javaclassS9.vo.ReportMemberVO;

public interface MemberService {

	public MemberVO getMemberIdCheck(String mid);

	public MemberVO getMemberNickCheck(String nickName);

	public int setMemberJoinOk(MemberVO vo);

	public MemberVO getMemberNameCheck(String name);

	public int setMemberPwdUpdate(String mid, String pwd);

	public int setMemberUpdateOk(MemberVO vo);

	public int setMemberDeleteOk(String mid);

	public int setMessageInputOk(MessageVO vo);

	public ArrayList<MessageVO> getAllReceiveMessageList(String mid);

	public ArrayList<MessageVO> getAllSendMessageList(String mid);

	public void setMessageCheck(int idx);

	public int setMessageDelete(int idx, String sw);

	public int setMessageDeleteDB(int idx);

	public ArrayList<ConsultingVO> getConsultingList(int startIndexNo, int pageSize, String name, String email);

	public ConsultingVO getConsultingContent(int idx);

	public void setKakaoMemberInput(String mid, String pwd, String nickName, String email);

	public ReportMemberVO getReportMember(String mid, String hostIp);

	public int setReportMemberInput(String mid, String hostIp);

	public ArrayList<ReportMemberVO> getReportMemberList(int startIndexNo, int pageSize);

	public void setReportMemberUpdate(String hostIp);

	public void setReportMemberUpdateBlock(String hostIp);

	public int getNewMessageCount(String mid);

	public int getNewEstimateCount(String mid);

	public void setMemberInfoUpdate(String mid);

}
