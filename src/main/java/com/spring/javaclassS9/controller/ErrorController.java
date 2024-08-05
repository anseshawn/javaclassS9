package com.spring.javaclassS9.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/errorPage")
public class ErrorController {
	
	// 400에러가 났을때 이동할 메세지 폼 보기(400번에러는 서버로 요청이 오지도 않은 경우이기에 이곳처리할것이 없다. 따라서 서버요청변수 타입을 잘 살펴봐야한다.)
	@RequestMapping(value = "/error400", method = RequestMethod.GET)
	public String error400Get() {
		return "";
	}
	
	// 404에러가 났을때 이동할 메세지 폼 보기(web.xml에 기술한다.)
	@RequestMapping(value = "/error404", method = RequestMethod.GET)
	public String error404Get() {
		return "errorPage/error404";
	}
	
	// 405에러가 났을때 이동할 메세지 폼 보기(web.xml에 기술한다.)
	@RequestMapping(value = "/error405", method = RequestMethod.GET)
	public String error405Get() {
		return "errorPage/error405";
	}
	
	// 500에러가 났을때 이동할 메세지 폼 보기(web.xml에 기술한다.)
	@RequestMapping(value = "/error500", method = RequestMethod.GET)
	public String error500Get() {
		return "errorPage/error500";
	}
	
	// 500에러(NumberFormatException)가 났을때 이동할 메세지 폼 보기(web.xml에 기술한다.)
	@RequestMapping(value = "/errorNumberFormat", method = RequestMethod.GET)
	public String errorNumberFormatGet() {
		return "errorPage/errorNumberFormat";
	}
	
	// NullPointerException에러가 났을때 이동할 메세지 폼 보기(web.xml에 기술한다.)
	@RequestMapping(value = "/errorNullPointer", method = RequestMethod.GET)
	public String errorNullPointerGet() {
		return "errorPage/errorNullPointer";
	}
	
	// 400번 에러 처리에 도움을 주기위한 예외처리...
	//@ExceptionHandler(value = Exception.class) // 예외오류는 무조건 여기를 거침 (활성화시 500번 에러도 여기를 거치게 된다)
	public ResponseEntity<Map<String, String>> ExceptionHandler(Exception e) {
		HttpHeaders responseHeaders = new HttpHeaders();
		HttpStatus httpStatus = HttpStatus.BAD_REQUEST;
		
		System.out.println("e : " + e.getMessage());
		
		Map<String, String> map = new HashMap<String, String>();
		map.put("error type", httpStatus.getReasonPhrase());
		map.put("code", "400");
		map.put("message", "에러 발생");		
		
		return new ResponseEntity<Map<String,String>>(map, responseHeaders, httpStatus);
	}
}
