package com.spring.javaclassS9.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/company")
public class CompanyController {
	
	@RequestMapping(value = "/aboutUs", method = RequestMethod.GET)
	public String aboutUsGet() {
		
		return "company/aboutUs";
	}
	
}
