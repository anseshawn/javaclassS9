package com.spring.javaclassS9.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.javaclassS9.pagination.PageProcess;
import com.spring.javaclassS9.service.AdminService;
import com.spring.javaclassS9.service.MemberService;
import com.spring.javaclassS9.vo.ConsultingVO;
import com.spring.javaclassS9.vo.FaqVO;
import com.spring.javaclassS9.vo.MemberVO;
import com.spring.javaclassS9.vo.PageVO;

@Controller
@RequestMapping("/service")
public class ServiceController {
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	AdminService adminService;
	
	@Autowired
	PageProcess pageProcess;
	
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
	
	// 자주묻는질문
	@RequestMapping(value = "/faqList", method = RequestMethod.GET)
	public String faqListGet(Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
		) {
  	PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "faq", part, "");
  	ArrayList<FaqVO> vos = adminService.getFaqList(pageVO.getStartIndexNo(),pageSize,part,searchString);
  	String[] parts = adminService.getFaqParts();
  	model.addAttribute("pageVO", pageVO);
  	model.addAttribute("parts", parts);
  	model.addAttribute("vos", vos);
		return "service/faqList";
	}
}
