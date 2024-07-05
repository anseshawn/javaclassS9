package com.spring.javaclassS9.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.javaclassS9.service.AdminService;
import com.spring.javaclassS9.service.MemberService;
import com.spring.javaclassS9.vo.MemberVO;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	@Autowired
	MemberService memberService;
	
	@RequestMapping(value = "/adminMain", method = RequestMethod.GET)
	public String adminMainGet() {
		return "admin/adminMain";
	}
	
	// 회원리스트
	@RequestMapping(value = "/member/memberList", method = RequestMethod.GET)
	public String memberListGet(Model model,
			@RequestParam(name = "m_group", defaultValue = "", required = false) String m_group
			) {
		ArrayList<MemberVO> vos = null;
		if(!m_group.equals("")) vos = adminService.getMemberLevelList(m_group);
		else vos = adminService.getAllMemberList();
		
		model.addAttribute("vos", vos);
		return "admin/member/memberList";
	}
	// 개별회원모달
	@ResponseBody
	@RequestMapping(value = "/member/memberList/{mid}", method = RequestMethod.POST)
	public MemberVO memberListPost(@PathVariable String mid) {
		MemberVO mVo = memberService.getMemberIdCheck(mid);
		return mVo;
	}
	
	// 개별회원 재직자로 등급 변경
	@ResponseBody
	@RequestMapping(value = "/member/memberChangeLevel", method = RequestMethod.POST)
	public String memberChangeLevelPost(@RequestParam(name = "mid", defaultValue = "", required = false) String mid) {
		return adminService.setMemberLevelUpdateOk(mid)+"";
	}
	
	// 개별회원 DB에서 영구삭제처리
	@ResponseBody
	@RequestMapping(value = "/member/memberDeleteAll", method = RequestMethod.POST)
	public String memberDeleteAllPost(@RequestParam(name = "mid", defaultValue = "", required = false) String mid) {
		return adminService.setMemberDeleteAll(mid)+"";
	}
	
}
