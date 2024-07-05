package com.spring.javaclassS9.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/customer")
public class CustomerController {
	
	@RequestMapping(value = "/cmain", method = RequestMethod.GET)
	public String cmainGet() {
		
		return "customer/cmain";
	}
	
}