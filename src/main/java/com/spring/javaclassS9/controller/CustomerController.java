package com.spring.javaclassS9.controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpSession;

import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.javaclassS9.pagination.PageProcess;
import com.spring.javaclassS9.service.CustomerService;
import com.spring.javaclassS9.service.EngineerService;
import com.spring.javaclassS9.vo.AsRequestVO;
import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.NewsVO;
import com.spring.javaclassS9.vo.PageVO;
import com.spring.javaclassS9.vo.ReviewVO;

@Controller
@RequestMapping("/customer")
public class CustomerController {
	
	@Autowired
	EngineerService engineerService;
	
	@Autowired
	CustomerService customerService;
	
	@Autowired
	PageProcess pageProcess;
	
	@RequestMapping(value = "/cmain", method = RequestMethod.GET)
	public String cmainGet() {
		return "customer/cmain";
	}
	
	@ResponseBody
	@RequestMapping(value = "/cmain", method = RequestMethod.POST)
	public ArrayList<NewsVO> cmainPost(String search) throws IOException {
		Connection conn = Jsoup.connect(search);
		Document document = conn.get();
		
		Elements selects = null;
		
		ArrayList<String> linkVos = new ArrayList<String>();
		selects = document.select("div.sa_text");
		
		for(Element select : selects) {
			linkVos.add(select.html().replace("b>", "div>"));
		}
		/*
		int cnt2 = 0;
		ArrayList<String> titleVos = new ArrayList<String>();
		selects = document.select("a.sa_text_title");
		for(Element select : selects) {
			System.out.println(cnt2+". "+select.html());
			titleVos.add(select.html());
		}
		
		ArrayList<String> ledeVos = new ArrayList<String>();
		selects = document.select("div.sa_text_lede");
		for(Element select : selects) {
			ledeVos.add(select.html()+"……");
		}
		
		ArrayList<String> broadcastVos = new ArrayList<String>();
		selects = document.select("div.sa_text_press");
		for(Element select : selects) {
			broadcastVos.add(select.html());
		}
		*/
		ArrayList<NewsVO> vos = new ArrayList<NewsVO>();
		NewsVO vo = null;
		for(int i=0; i<linkVos.size(); i++) {
			vo = new NewsVO();
			vo.setItem1(linkVos.get(i));
			//vo.setItem2(titleVos.get(i));
			//vo.setItem2(ledeVos.get(i));
			//vo.setItem3(broadcastVos.get(i));
			vos.add(vo);
		}
		
		return vos;
	}
	
	// A/S 신청
	@RequestMapping(value = "requests/asRequest", method = RequestMethod.GET)
	public String asRequestGet(Model model) {
		ArrayList<EngineerVO> vos = engineerService.getAllEngineerList(0, 0);
		model.addAttribute("vos", vos);
		return "customer/requests/asRequest";
	}
	
	@RequestMapping(value = "requests/asAppointment", method = RequestMethod.GET)
	public String asAppointmentGet(int idx, Model model) {
		EngineerVO eVo = engineerService.getEngineerIdxCheck(idx);
		model.addAttribute("eVo", eVo);
		return "customer/requests/asAppointment";
	}
	// A/S 신청 등록
	@RequestMapping(value = "requests/asAppointment", method = RequestMethod.POST)
	public String asAppointmentPost(AsRequestVO vo) {
		int res = customerService.setAsAppointmentOk(vo);
		if(res != 0) return "redirect:/message/asAppointmentOk";
		else return "redirect:/message/asAppointmentNo";
	}
	
	// A/S 진행현황 확인
	@RequestMapping(value = "/requests/asProgress", method = RequestMethod.GET)
	public String asProgressGet(HttpSession session, Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
			) {
		String asMid = (String) session.getAttribute("sMid");
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "asRequest", "mid", asMid);
		ArrayList<AsRequestVO> vos = customerService.getAsRequestList(asMid,pageVO.getStartIndexNo(),pageSize);
		
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vos", vos);
		return "customer/requests/asProgress";
	}
	
	// A/S 진행현황 기간으로 검색
	@RequestMapping(value = "/requests/asProgress", method = RequestMethod.POST)
	public String asProgressPost(HttpSession session, Model model, String startSearchDate, String endSearchDate,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize
		) throws ParseException {
		String asMid = (String) session.getAttribute("sMid");
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "asRequest", "mid", asMid);
		ArrayList<AsRequestVO> vos = customerService.getAsRequestList(asMid,pageVO.getStartIndexNo(),pageSize);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date endDate = null;
		Date startDate = null;
		//System.out.println("startSearchDate : " + startSearchDate);
		//System.out.println("endSearchDate : " + endSearchDate);
		for(int i=0; i<vos.size(); i++) {
			if(vos.get(i).getEndDate() != null)	{
				endDate = sdf.parse(vos.get(i).getEndDate());
			}
			startDate = sdf.parse(vos.get(i).getRequestDate());
			Date sSearchDate = sdf.parse(startSearchDate);
			Date eSearchDate = sdf.parse(endSearchDate);
			//System.out.println("endDate : " + vos.get(i).getEndDate());
			//System.out.println("startDate : " + startDate);
			//System.out.println("sSearchDate : " + sSearchDate);
			//System.out.println("eSearchDate : " + eSearchDate);
			if(startDate.before(sSearchDate) || startDate.after(eSearchDate)) vos.remove(i);
			if(endDate != null) {
				if(endDate.before(sSearchDate) || endDate.after(eSearchDate)) vos.remove(i);
			}
		}
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vos", vos);
		
		return "customer/requests/asProgress";
	}
	
	// A/S 개별 현황 확인
	@RequestMapping(value = "requests/asContent", method = RequestMethod.GET)
	public String asCheckGet(Model model, int idx,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize
			) {
		AsRequestVO vo = customerService.getAsRequestContent(idx);
		String progress = "";
		if(vo.getProgress().toString().equals("REGIST")) progress = "신청완료";
		else if(vo.getProgress().toString().equals("ACCEPT")) progress = "접수완료";
		else if(vo.getProgress().toString().equals("PROGRESS")) progress = "진행중";
		else if(vo.getProgress().toString().equals("PAYMENT")) progress = "입금대기";
		else if(vo.getProgress().toString().equals("COMPLETE")) progress = "진행완료";
		
		int sw = customerService.getReviewSearch(idx); // 해당 as에 리뷰 작성한 적 있는지 체크
		
		model.addAttribute("vo", vo);
		model.addAttribute("progress", progress);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("sw", sw);
		return "customer/requests/asContent";
	}
	
	// A/S 완료 시 별점 남기기
	@ResponseBody
	@RequestMapping(value = "/reviewInput", method = RequestMethod.POST)
	public String reviewInputPost(ReviewVO vo) {
		return customerService.setReviewInput(vo)+"";
	}
}
