package com.spring.javaclassS9.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS9.vo.ConsultingVO;
import com.spring.javaclassS9.vo.MemberVO;
import com.spring.javaclassS9.vo.MessageVO;
import com.spring.javaclassS9.vo.ReportMemberVO;

public interface MemberDAO {

	public MemberVO getMemberIdCheck(@Param("mid") String mid);

	public MemberVO getMemberNickCheck(@Param("nickName") String nickName);

	public int setMemberJoinOk(@Param("vo") MemberVO vo);

	public MemberVO getMemberNameCheck(@Param("name") String name);

	public int setMemberPwdUpdate(@Param("mid") String mid, @Param("pwd") String pwd);

	public int setMemberUpdateOk(@Param("vo") MemberVO vo);

	public int setMemberDeleteOk(@Param("mid") String mid);

	public int totRecCnt();

	public int totRecCntSearch(@Param("search") String search, @Param("searchString") String searchString);

	public int setMessageInputOk(@Param("vo") MessageVO vo);

	public ArrayList<MessageVO> getAllReceiveMessageList(@Param("mid") String mid);

	public ArrayList<MessageVO> getAllSendMessageList(@Param("mid") String mid);

	public void setMessageCheck(@Param("idx") int idx);

	public int setMessageDelete(@Param("idx") int idx, @Param("sw") String sw);

	public int setMessageDeleteDB(@Param("idx") int idx);

	public int consultingTotRecCnt(@Param("name") String name, @Param("email") String email);

	public ArrayList<ConsultingVO> getConsultingList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("name") String name, @Param("email") String email);

	public ConsultingVO getConsultingContent(@Param("idx") int idx);

	public void setKakaoMemberInput(@Param("mid") String mid, @Param("pwd") String pwd, @Param("nickName") String nickName, @Param("email") String email);

	public ReportMemberVO getReportMember(@Param("rpMid") String mid, @Param("hostIp") String hostIp);

	public int setReportMemberInput(@Param("rpMid") String mid, @Param("hostIp") String hostIp);

	public int reportMemberTotRecCnt();

	public ArrayList<ReportMemberVO> getReportMemberList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public void setReportMemberUpdate(@Param("hostIp") String hostIp);

	public void setReportMemberUpdateBlock(@Param("hostIp") String hostIp);

	public int getNewMessageCount(@Param("mid") String mid);

	public int getNewEstimateCount(@Param("mid") String mid);

	public void setMemberInfoUpdate(@Param("mid") String mid);
	
}
