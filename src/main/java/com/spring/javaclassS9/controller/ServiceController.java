package com.spring.javaclassS9.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.javaclassS9.service.AdminService;
import com.spring.javaclassS9.service.MemberService;
import com.spring.javaclassS9.vo.ConsultingVO;
import com.spring.javaclassS9.vo.MemberVO;

@Controller
@RequestMapping("/service")
public class ServiceController {
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	AdminService adminService;
	
	// 온라인 상담
	@RequestMapping(value = "/serviceMain", method = RequestMethod.GET)
	public String serviceMainGet(HttpSession session, Model model) {
		String mid = "";
		if(session != null) {
			mid = (String) session.getAttribute("sMid");
			MemberVO vo = memberService.getMemberIdCheck(mid);
			if(vo != null) model.addAttribute("vo", vo);
		}
		return "service/serviceMain";
	}
	
	@RequestMapping(value = "/serviceMain", method = RequestMethod.POST)
	public String serviceMainPost(ConsultingVO vo) {
		int res = adminService.setConsultingInput(vo);
		if(res != 0) return "redirect:/message/consultingInputOk";
		else return "redirect:/message/consultingInputNo?pathFlag=service";
	}
	
	// 불편사항 신고
	@RequestMapping(value = "/complaintMain", method = RequestMethod.GET)
	public String complaintGet(HttpSession session, Model model) {
		String mid = "";
		if(session != null) {
			mid = (String) session.getAttribute("sMid");
			MemberVO vo = memberService.getMemberIdCheck(mid);
			if(vo != null) model.addAttribute("vo", vo);
		}
		return "service/complaintMain";
	}
	@RequestMapping(value = "/complaintMain", method = RequestMethod.POST)
	public String complaintPost(ConsultingVO vo) {
		int res = adminService.setConsultingInput(vo);
		if(res != 0) return "redirect:/message/consultingInputOk";
		else return "redirect:/message/consultingInputNo?pathFlag=complaint";
	}
	
}
