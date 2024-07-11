package com.spring.javaclassS9.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.javaclassS9.service.EngineerService;
import com.spring.javaclassS9.vo.EngineerVO;

@Controller
@RequestMapping("/engineer")
public class EngineerController {
	
	@Autowired
	EngineerService engineerService;
	
	// 엔지니어 개인 정보 모달(A/S신청 탭에서)
	@ResponseBody
	@RequestMapping(value = "/engineerContent", method = RequestMethod.POST)
	public EngineerVO engineerContentGet(
			@RequestParam(name = "idx", defaultValue = "0", required = false) int idx
		) {
		EngineerVO eVo = engineerService.getEngineerIdxCheck(idx);
		return eVo;
	}
	
}
