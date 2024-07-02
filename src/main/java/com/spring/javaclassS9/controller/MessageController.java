package com.spring.javaclassS9.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MessageController {
	
	@RequestMapping(value = "/message/{msgFlag}", method = RequestMethod.GET)
	public String home(Model model,
			@PathVariable String msgFlag,
			@RequestParam(name="mid", defaultValue = "", required = false) String mid
			) {
		
		if(msgFlag.equals("idCheckNo")) {
			model.addAttribute("msg", "이미 사용중인 아이디입니다.");
			model.addAttribute("url", "/member/memberJoin");
		}
		else if(msgFlag.equals("nickCheckNo")) {
			model.addAttribute("msg", "이미 사용중인 닉네임입니다.");
			model.addAttribute("url", "/member/memberJoin");
		}
		else if(msgFlag.equals("memberJoinOk")) {
			model.addAttribute("msg", "회원가입이 완료되었습니다.\\n로그인하여 다양한 서비스를 이용해보세요.");
			model.addAttribute("url", "/member/memberLogin");
		}
		else if(msgFlag.equals("memberJoinNo")) {
			model.addAttribute("msg", "회원가입에 실패했습니다. 입력 정보를 다시 한번 확인해주세요.");
			model.addAttribute("url", "/member/memberJoin");
		}
		else if(msgFlag.equals("memberLogout")) {
			model.addAttribute("msg", mid+"님, 로그아웃 되었습니다.");
			model.addAttribute("url", "/");
		}
		
		return "include/message";
	}
	
}
