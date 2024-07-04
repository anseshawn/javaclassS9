package com.spring.javaclassS9.service;

import com.spring.javaclassS9.vo.MemberVO;

public interface MemberService {

	public MemberVO getMemberIdCheck(String mid);

	public MemberVO getMemberNickCheck(String nickName);

	public int setMemberJoinOk(MemberVO vo);

	public MemberVO getMemberNameCheck(String name);

	public int setMemberPwdUpdate(String mid, String pwd);
	
	
}
