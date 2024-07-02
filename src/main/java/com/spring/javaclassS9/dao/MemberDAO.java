package com.spring.javaclassS9.dao;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS9.vo.MemberVO;

public interface MemberDAO {

	public MemberVO getMemberIdCheck(@Param("mid") String mid);

	public MemberVO getMemberNickCheck(@Param("nickName") String nickName);

	public int setMemberJoinOk(@Param("vo") MemberVO vo);
	
}
