package com.spring.javaclassS9.dao;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS9.vo.MemberVO;

public interface MemberDAO {

	public MemberVO getMemberIdCheck(@Param("mid") String mid);

	public MemberVO getMemberNickCheck(@Param("nickName") String nickName);

	public int setMemberJoinOk(@Param("vo") MemberVO vo);

	public MemberVO getMemberNameCheck(@Param("name") String name);

	public int setMemberPwdUpdate(@Param("mid") String mid, @Param("pwd") String pwd);

	public int setMemberUpdateOk(@Param("vo") MemberVO vo);

	public int setMemberDeleteOk(@Param("mid") String mid);
	
}
