package com.spring.javaclassS9.controller;

import java.util.UUID;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS9.common.JavaclassProvide;
import com.spring.javaclassS9.service.EngineerService;
import com.spring.javaclassS9.vo.EngineerVO;

@Controller
@RequestMapping("/engineer")
public class EngineerController {
	
	@Autowired
	EngineerService engineerService;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	JavaclassProvide javaclassProvide;
	
	// 엔지니어 개인 정보 모달(A/S신청 탭에서)
	@ResponseBody
	@RequestMapping(value = "/engineerContent", method = RequestMethod.POST)
	public EngineerVO engineerContentGet(
			@RequestParam(name = "idx", defaultValue = "0", required = false) int idx
		) {
		EngineerVO eVo = engineerService.getEngineerIdxCheck(idx);
		return eVo;
	}
	
	// 마이페이지
	@RequestMapping(value = "/myPageMain", method = RequestMethod.GET)
	public String myPageMainGet(HttpSession session, Model model) {
		String mid = (String) session.getAttribute("sMid");
		EngineerVO vo = engineerService.getEngineerIdCheck(mid);
		model.addAttribute("vo", vo);
		return "engineer/myPageMain";
	}
	
	// 정보 수정 창
	@RequestMapping(value = "/engineerUpdate", method = RequestMethod.GET)
	public String engineerUpdateGet(HttpSession session, Model model) {
		String mid = (String) session.getAttribute("sMid");
		EngineerVO vo = engineerService.getEngineerIdCheck(mid);
		model.addAttribute("vo", vo);
		return "engineer/engineerUpdate";
	}
	// 정보 수정 처리
	// 중요한 건 관리자페이지에서만 수정 가능
	@RequestMapping(value = "/engineerUpdate", method = RequestMethod.POST)
	public String engineerUpdatePost(MultipartFile fName, EngineerVO vo) {
		int res = engineerService.setEngineerUpdateOk(fName,vo);
		if(res != 0) return "redirect:/message/engineerUpdateOk?pathFlag=engineer";
		else return "redirect:/message/engineerUpdateNo?pathFlag=engineer";
	}
	
	// 비밀번호 변경
	@RequestMapping(value = "/pwdChange", method = RequestMethod.GET)
	public String pwdChangeGet() {
		return "engineer/pwdChange";
	}
	@RequestMapping(value = "/pwdChange", method = RequestMethod.POST)
	public String pwdChangePost(String mid, String pwdNew, HttpSession session) {
		int res = 0;
		res = engineerService.setEngineerPwdUpdate(mid, passwordEncoder.encode(pwdNew));
		if(res != 0) {
			session.invalidate();
			return "redirect:/message/pwdChangeOk";
		}
		else return "redirect:/message/pwdChangeNo?pathFlag=engineer";
	}
	
	// 비밀번호 찾기
	@RequestMapping(value = "/pwdSearch", method = RequestMethod.GET)
	public String pwdSearchGet() {
		return "engineer/pwdSearch";
	}
	
	//임시 비밀번호 발급
	@ResponseBody
	@RequestMapping(value = "/pwdSearchOk", method = RequestMethod.POST)
	public String pwdSearchOkPost(String mid, String email, HttpSession session,
			HttpServletRequest request
			) throws MessagingException {
		EngineerVO vo = engineerService.getEngineerIdCheck(mid);
		if(vo != null && vo.getEmail().equals(email)) {
			UUID uid = UUID.randomUUID();
			String pwd = uid.toString().substring(0,8);
			
			int pwdUpdate = engineerService.setEngineerPwdUpdate(mid, passwordEncoder.encode(pwd));
			
			String title = "임시 비밀번호 발급";
			String imsiContent = "임시 비밀번호 : <b>"+pwd+"</b>";
			String mailFlag = "pwdSearch";
			
			String res = javaclassProvide.mailSend(email, title, imsiContent, mailFlag, request);
			session.setAttribute("sLogin", "OK"); // 쿠키에 비밀번호 저장해서 만료기간...???
			return res+pwdUpdate;
		}
		return "0";
	}
}
