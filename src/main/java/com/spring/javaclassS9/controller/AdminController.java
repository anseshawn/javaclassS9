package com.spring.javaclassS9.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS9.common.JavaclassProvide;
import com.spring.javaclassS9.pagination.PageProcess;
import com.spring.javaclassS9.service.AdminService;
import com.spring.javaclassS9.service.EngineerService;
import com.spring.javaclassS9.service.MemberService;
import com.spring.javaclassS9.service.ProductService;
import com.spring.javaclassS9.vo.AsRequestVO;
import com.spring.javaclassS9.vo.ChartVO;
import com.spring.javaclassS9.vo.DeleteMemberVO;
import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.MemberVO;
import com.spring.javaclassS9.vo.PageVO;
import com.spring.javaclassS9.vo.ProductSaleVO;
import com.spring.javaclassS9.vo.ProductVO;
import com.spring.javaclassS9.vo.ReportVO;
import com.spring.javaclassS9.vo.ScheduleVO;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired
	JavaclassProvide javaclassProvide;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	EngineerService engineerService;
	
	@Autowired
	ProductService productService;
	
	
	@RequestMapping(value = "/adminMain", method = RequestMethod.GET)
	public String adminMainGet(Model model) {
		int joinCount = adminService.getJoinMemberCount();
		int estimateCount = adminService.getProductEstimateCount();
		model.addAttribute("joinCount", joinCount);
		model.addAttribute("estimateCount", estimateCount);
		return "admin/adminMain";
	}
	
	// 회원리스트(검색어 포함)
	@RequestMapping(value = "/member/memberList", method = RequestMethod.GET)
	public String memberListGet(Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString,
			@RequestParam(name = "m_group", defaultValue = "", required = false) String m_group
			) {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "member", "", "");
		
		ArrayList<MemberVO> vos = null;
		if(!m_group.equals("")) {
			pageVO = pageProcess.totRecCnt(pag, pageSize, "member", "m_group", m_group);
			vos = adminService.getMemberLevelList(pageVO.getStartIndexNo(),pageSize,m_group);
		}
		else if(!part.equals("")) {
			pageVO = pageProcess.totRecCnt(pag, pageSize, "member", part, searchString);
			vos = adminService.getMemberSearchList(pageVO.getStartIndexNo(),pageSize,part,searchString);
		}
		else vos = adminService.getAllMemberList(pageVO.getStartIndexNo(),pageSize);
		
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
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
	
	// 메일 전송 창 연결
	@RequestMapping(value = "/emailInput/{mids}", method = RequestMethod.GET)
	public String emailInputGet(Model model,
			@PathVariable String mids
			) {
		ArrayList<MemberVO> mVos = adminService.getAllMemberList(0, 0);
		model.addAttribute("mVos", mVos);
		
		if(!mids.equals("all")) model.addAttribute("toMail", mids);
		
		return "admin/emailInput";
	}
	
	// 메일 전송하기
	@RequestMapping(value = "/emailInput/{mids}", method = RequestMethod.POST)
	public String emailInputPost(String toMail, String title, String content,
			HttpServletRequest request, @PathVariable String mids) throws MessagingException {
		String res = "";
		MemberVO vo = null;
		if(toMail.contains(",")) { // 아이디로 여러명에게 전송
			String[] midStr = toMail.split(",");
			for(String mid : midStr) {
				vo = memberService.getMemberIdCheck(mid.trim());
				res = javaclassProvide.mailSend(vo.getEmail(), title, content, "adminSendEmail", request);
			}
		}
		else if(mids.equals("all") && toMail.contains("@")) { // 메일 주소로 한명에게 전송
			res = javaclassProvide.mailSend(toMail, title, content, "adminSendEmail", request);
		}
		else { // 멤버리스트에서 메일주소 클릭 시 한명에게 전송
			vo = memberService.getMemberIdCheck(toMail);
			res = javaclassProvide.mailSend(vo.getEmail(), title, content, "adminSendEmail", request);
		}
		
		if(res != "0") return "redirect:/message/emailInputOk";
		else return "redirect:/message/emailInputNo";
	}
	
	// 아이디로 멤버 검색
	@ResponseBody
	@RequestMapping(value = "/midSearch", method = RequestMethod.POST)
	public ArrayList<MemberVO> midSearchPost(Model model, String mid) {
		ArrayList<MemberVO> mVos = adminService.getMemberSearchList(0, 0, "mid", mid);
		//model.addAttribute("mVos", mVos);
		return mVos;
	}
	
	// 엔지니어 등록 창 출력
	@RequestMapping(value = "/engineer/engineerInput", method = RequestMethod.GET)
	public String engineerInputGet() {
		return "admin/engineer/engineerInput";
	}
	// 엔지니어 아이디 중복 검사
	@ResponseBody
	@RequestMapping(value = "/engineer/engineerIdCheck", method = RequestMethod.POST)
	public String engineerIdCheckPost(String mid) {
		EngineerVO vo = engineerService.getEngineerIdCheck(mid);
		MemberVO mVo = memberService.getMemberIdCheck(mid);
		if(vo != null || mVo != null) return "1";
		else return "0";
	}
	
	// 엔지니어 등록하기
	@RequestMapping(value = "/engineer/engineerInput", method = RequestMethod.POST)
	public String engineerInputPost(MultipartFile fName, EngineerVO vo) {
		if(engineerService.getEngineerIdCheck(vo.getMid()) != null) return "redirect:/message/engineerIdCheckNo";
		vo.setPwd(passwordEncoder.encode(vo.getPwd()));
		
		int res = engineerService.setEngineerJoinOk(fName,vo);
		if(res != 0) return "redirect:/message/engineerJoinOk";
		else return "redirect:/message/engineerJoinNo";
	}
	

	// 엔지니어리스트(검색어 포함)
	@RequestMapping(value = "/engineer/engineerList", method = RequestMethod.GET)
	public String engineerListGet(Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
			) {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "engineer", "", "");
		
		ArrayList<EngineerVO> vos = null;
		if(!part.equals("")) {
			pageVO = pageProcess.totRecCnt(pag, pageSize, "engineer", part, searchString);
			vos = engineerService.getEngineerSearchList(pageVO.getStartIndexNo(),pageSize, part, searchString);
		}
		else vos = engineerService.getAllEngineerList(pageVO.getStartIndexNo(),pageSize);
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		return "admin/engineer/engineerList";
	}
	
	// 개별사원모달
	@ResponseBody
	@RequestMapping(value = "/engineer/engineerList/{mid}", method = RequestMethod.POST)
	public EngineerVO engineerListPost(@PathVariable String mid) {
		EngineerVO mVo = engineerService.getEngineerIdCheck(mid);
		return mVo; 
	}
	
	// 개별사원 DB에서 영구삭제처리
	@ResponseBody
	@RequestMapping(value = "/engineer/engineerDeleteAll", method = RequestMethod.POST)
	public String engineerDeleteAllPost(@RequestParam(name = "mid", defaultValue = "", required = false) String mid) {
		EngineerVO vo = engineerService.getEngineerIdCheck(mid);
		ArrayList<AsRequestVO> vos = engineerService.getAsRequestList(vo.getIdx(), 0, 0);
		int res = 0;
		if(vos == null) res = adminService.setEngineerDeleteAll(vo.getIdx());
		return res+"";
	}
	
	//엔지니어 수정 창 연결
	@RequestMapping(value = "/engineer/engineerUpdate", method = RequestMethod.GET)
	public String engineerUpdateGet(int idx, Model model) {
		EngineerVO vo = engineerService.getEngineerIdxCheck(idx);
		model.addAttribute("vo", vo);
		return "admin/engineer/engineerUpdate";
	}
	//엔지니어 수정 창 연결
	@RequestMapping(value = "/engineer/engineerUpdate", method = RequestMethod.POST)
	public String engineerUpdatePost(MultipartFile fName, EngineerVO vo) {
		EngineerVO eVo = engineerService.getEngineerIdxCheck(vo.getIdx());
		if(eVo != null && !eVo.getMid().equals(vo.getMid())) {
			engineerService.setEngineerMidChange(vo.getMid(), vo.getIdx());
		}
		else if(eVo != null && eVo.getIdx() != vo.getIdx()) {
			return "redirect:/message/engineerIdCheckNo";
		}
		
		int res = engineerService.setEngineerUpdateOk(fName, vo);
		if(res != 0)	return "redirect:/message/engineerUpdateOk?pathFlag=admin";
		else return "redirect:/message/engineerUpdateNo?pathFlag=admin";
	}
	
	// 제품 등록 창 출력
	@RequestMapping(value = "/product/productInput", method = RequestMethod.GET)
	public String productInputGet() {
		return "admin/product/productInput";
	}
	// 기기 등록하기
	@RequestMapping(value = "/product/productInput", method = RequestMethod.POST)
	public String productInputPost(MultipartFile fName, ProductVO vo) {
		int res = productService.setProductInputOk(fName,vo);
		if(res != 0) return "redirect:/message/productInputOk";
		else return "redirect:/message/productInputNo";
	}
	
	// 장비 리스트 창 출력
	@RequestMapping(value = "/product/productList", method = RequestMethod.GET)
	public String productListGet(Model model) {
		ArrayList<ProductVO> vos = productService.getAllProductList(0, 0);
		model.addAttribute("vos", vos);
		return "admin/product/productList";
	}
	
	// 장비 수정 창 출력
	@RequestMapping(value = "/product/productEdit", method = RequestMethod.GET)
	public String productEditGet(int idx, Model model) {
		ProductVO vo = productService.getProductContent(idx);
		model.addAttribute("vo", vo);
		return "admin/product/productEdit";
	}
	// 장비 수정하기
	@RequestMapping(value = "/product/productEdit", method = RequestMethod.POST)
	public String productEditPost(MultipartFile fName, ProductVO vo) {
		int res = productService.setProductContentEdit(fName, vo);
		if(res != 0) return "redirect:/message/productEditOk";
		else return "redirect:/message/productEditNo?idx="+vo.getIdx();
	}
	
	// 관리자 화면에서 장비 상세 보기
	@RequestMapping(value = "/product/productContent", method = RequestMethod.GET)
	public String productContentGet(Model model, int idx) {
		ProductVO vo = productService.getProductContent(idx);
		model.addAttribute("vo", vo);
		return "admin/product/productContent";
	}
	
	// 장비 삭제하기
	@ResponseBody
	@RequestMapping(value = "/product/productDelete", method = RequestMethod.POST)
	public String productDeletePost(int idx, String photo) {
		if(!photo.equals("noimage2.png")) javaclassProvide.deleteFile(photo, "product");
		return adminService.setProductDeleteOk(idx)+"";
	}
	
	// 관리자 화면에서 장비 견적 요청 확인하기
	@RequestMapping(value = "/product/productEstimate", method = RequestMethod.GET)
	public String productEstimateGet(Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
		) {
		ArrayList<ProductSaleVO> vos = null;
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "productEstimate", part, searchString);
		if(part.equals("")) vos = productService.getAllProductEstimateList(pageVO.getStartIndexNo(),pageSize);
		else vos = productService.getSearchProductEstimateList(pageVO.getStartIndexNo(),pageSize,part,searchString);
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vos", vos);
		return "admin/product/productEstimate";
	}
	// 견적 건 상태 변경하기
	@ResponseBody
	@RequestMapping(value = "/product/productEstimateChange", method = RequestMethod.POST)
	public String productEstimateChangePost(int idx, String statement) {
		return adminService.setProductEstimateChange(idx,statement)+"";
	}
	
	// 견적 상세 건
	@RequestMapping(value = "/product/productEstimateDetail", method = RequestMethod.GET)
	public String productEstimateDetailGet(Model model,
			@RequestParam(name="idx",defaultValue = "0", required = false) int idx,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
		) {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "productEstimate", part, searchString);
		ProductSaleVO saleVO = productService.getProductSaleContent(idx);
		ProductVO vo = productService.getProductContent(saleVO.getProductIdx());
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("saleVO", saleVO);
		model.addAttribute("vo", vo);
		return "admin/product/productEstimateDetail";
	}
	
	// ---------- 캘린더 관련 ------------
	//전체 일정 불러오기
	@ResponseBody
	@RequestMapping(value = "/schedule/scheduleListAll", method = RequestMethod.POST)
	public ArrayList<ScheduleVO> scheduleListAllPost() {
		ArrayList<ScheduleVO> vos = engineerService.getScheduleListAll();
		for(int i=0; i<vos.size(); i++) {
			ScheduleVO scheduleVO = vos.get(i);
			EngineerVO vo = engineerService.getEngineerIdxCheck(vos.get(i).getEngineerIdx());
			if(vo != null) scheduleVO.setEngineerName(vo.getName());
		}
		return vos;
	}
	
	// 일정 삭제
	@ResponseBody
	@RequestMapping(value = "/schedule/scheduleDelete", method = RequestMethod.POST)
	public String scheduleDeletePost(
	    @RequestParam(name="title", defaultValue = "", required = false) String title,
	    @RequestParam(name="start", defaultValue = "", required = false) String startTime,
	    @RequestParam(name="end", defaultValue = "", required = false) String endTime,
	    @RequestParam(name="allDay", defaultValue = "false" , required = false) Boolean allDay
   ) throws ParseException {
		// 엔지니어 idx / title 분리하기
		String[] nameTitle = title.split("-");
		String engineerName = nameTitle[0];
		EngineerVO vo = engineerService.getEngineerNameCheck(engineerName);
		int engineerIdx = vo.getIdx();
		title = nameTitle[1];
		
		// 날짜 형식을 한국어 패턴으로 변경
		SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd-a hh:mm:ss", Locale.KOREAN);
		SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		    
		Date startDate = inputFormat.parse(startTime);
		Date endDate = inputFormat.parse(endTime);
		    
		// UTC 시간대로 변환 (필요시)
		inputFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
		 
		// 파싱된 날짜를 출력 형식으로 변환
		String formattedStartTime = outputFormat.format(startDate);
		String formattedEndTime = outputFormat.format(endDate);
		int res = 0;
		startTime = startTime.replace("-오전", "");
		startTime = startTime.replace("-오후", "");
		endTime = endTime.replace("-오전", "");
		endTime = endTime.replace("-오후", "");
		if(allDay == true) {
			String startTimeChange = startTime.substring(10,19);
		  startTime = startTime.replace(startTimeChange, " 00:00:00");
		  res = engineerService.setScheduleDeleteTrue(title,engineerIdx,formattedStartTime);                        
		}
		else {            
			System.out.println("들어옴2");
		  System.out.println(title+","+formattedStartTime+","+formattedEndTime+","+allDay);
		  res = engineerService.setScheduleDelete(title,engineerIdx,formattedStartTime,formattedEndTime, allDay);            
		}
   
   return res+"";
 }
 
 // 일정 추가
 @ResponseBody
 @RequestMapping(value = "/schedule/scheduleInput", method = RequestMethod.POST)
 public String scheduleInputPost(
         ScheduleVO vo,
         @RequestParam(name="title", defaultValue = "", required = false) String title,
         @RequestParam(name="start", defaultValue = "", required = false) String startTime,
         @RequestParam(name="end", defaultValue = "", required = false) String endTime,
         @RequestParam(name="allDay", defaultValue = "false" , required = false) Boolean allDay,
 				@RequestParam(name="sw", defaultValue = "" , required = false) String sw) {
	 
			// 엔지니어 idx / title 분리하기
			String[] nameTitle = title.split("-");
			String engineerName = nameTitle[0].trim();
			EngineerVO eVo = engineerService.getEngineerNameCheck(engineerName);
			int engineerIdx = eVo.getIdx();
			title = nameTitle[1];
			
			int res = 0;
		
     System.out.println("startTime: "+startTime);
     System.out.println("endTime: "+endTime);

     SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.ENGLISH);
     inputFormat.setTimeZone(TimeZone.getTimeZone("UTC")); // 입력된 날짜는 UTC 시간대로 설정
     SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
     SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
     
     String formattedStartTime = "";
     String formattedEndTime = "";
     try {
     	if(sw.equals("")) {
     		Date startDate = inputFormat.parse(startTime);
     		Date endDate = inputFormat.parse(endTime);
     		formattedStartTime = outputFormat.format(startDate);
     		formattedEndTime = outputFormat.format(endDate);
     	}
     	else if(sw.equals("engineerAsRequest")) { // endTime 없이 다른 폼에서 입력할 때
     		formattedStartTime = startTime;
         Date endDate = sdf.parse(startTime);
         Calendar calendar = Calendar.getInstance();
         calendar.setTime(endDate);
         calendar.add(Calendar.HOUR_OF_DAY, 24);
         formattedEndTime = outputFormat.format(calendar.getTime());
     	}
         
       vo.setAllDay(allDay);
       vo.setStartTime(formattedStartTime);
       vo.setEndTime(formattedEndTime);
       vo.setTitle(title);
       if(engineerIdx != 0) vo.setEngineerIdx(engineerIdx);

       res = engineerService.setScheduleInput(vo);

     } catch (ParseException e) {
         e.printStackTrace();
     }

     return String.valueOf(res);
 }
 
 // 일정 수정하기
 @ResponseBody
 @RequestMapping(value = "/schedule/scheduleUpdate", method = RequestMethod.POST)
 public String  scheduleUpdatePost(
       @RequestParam(name="idx", defaultValue = "", required = false) int idx,
       @RequestParam(name="title", defaultValue = "", required = false) String title,
		    @RequestParam(name="start", defaultValue = "", required = false) String startTime,
		    @RequestParam(name="end", defaultValue = "", required = false) String endTime,
		    @RequestParam(name="allDay", defaultValue = "false" , required = false) Boolean allDay
     ) throws ParseException {
			// 엔지니어 idx / title 분리하기
			String[] nameTitle = title.split("-");
			String engineerName = nameTitle[0].trim();
			EngineerVO eVo = engineerService.getEngineerNameCheck(engineerName);
			int engineerIdx = eVo.getIdx();
			title = nameTitle[1];
			int res = 0;
     
     SimpleDateFormat inputFormat = new SimpleDateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z", Locale.ENGLISH);
     SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
     
     Date startDate = null;
     Date endDate = null;
     ScheduleVO vo = new ScheduleVO();
     
     startDate = inputFormat.parse(startTime);
     String formattedStartTime = outputFormat.format(startDate);
     
     if(allDay) {
         endDate = inputFormat.parse(startTime);
         Calendar calendar = Calendar.getInstance();
         calendar.setTime(endDate);
         calendar.add(Calendar.HOUR_OF_DAY, 24);
         endDate = calendar.getTime();
     }
     else if(endTime == null || endTime.isEmpty()) {
         // startTime 파싱하여 endDate에 저장
		      System.out.println(startTime+" "+ endTime);
		      endDate = inputFormat.parse(startTime);
		      // endDate에 1시간을 더함
		      Calendar calendar = Calendar.getInstance();
		      calendar.setTime(endDate);
		      calendar.add(Calendar.HOUR_OF_DAY, 1);
		      endDate = calendar.getTime();
     } 
     else {
       	endDate = inputFormat.parse(endTime);
     }
     // 포맷팅하여 formattedEndTime에 저장
     String formattedEndTime = outputFormat.format(endDate);
     vo.setTitle(title);
     vo.setStartTime(formattedStartTime);
     vo.setEndTime(formattedEndTime);
     vo.setAllDay(allDay);
     vo.setIdx(idx);
     if(engineerIdx != 0) vo.setEngineerIdx(engineerIdx);
     // 여기서 데이터베이스 업데이트 로직을 수행
     res = engineerService.setScheduleUpdate(vo);
		
     // 예시: 일정 업데이트 성공 여부에 따라 응답    
     
 		return res+"";
 	}
 
  // 일정 현황 페이지
  @RequestMapping(value = "/engineer/schedule", method = RequestMethod.GET)
  public String scheduleGet() {
  	return "admin/engineer/schedule";
  }
  
  // A/S 현황 전체 리스트
  @RequestMapping(value = "/engineer/asRequestList", method = RequestMethod.GET)
  public String asRequestListGet(Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
			) {
  	// 엔지니어 이름 or 신청한 회사명으로만 검색 가능
  	if(part.equals("engineerName")) part = "e.name";
  	else if(part.equals("asName")) part = "r.asName";
  	else if(part.equals("progress")) part = "progress";
  	PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "adminAsRequestList", part, searchString);
  	ArrayList<AsRequestVO> vos = engineerService.getAllAsRequestList(pageVO.getStartIndexNo(),pageSize,part,searchString);
  	model.addAttribute("pageVO", pageVO);
  	model.addAttribute("vos", vos);
  	return "admin/engineer/asRequestList";
  }
  
  // A/S 현황 기간 검색
	@RequestMapping(value = "/engineer/asRequestList", method = RequestMethod.POST)
	public String asRequestListPost(HttpSession session, Model model, String startSearchDate, String endSearchDate,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize
		) throws ParseException {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "adminAsRequestList", "", "");
		ArrayList<AsRequestVO> vos = engineerService.getAllAsRequestList(pageVO.getStartIndexNo(),pageSize,"","");
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date endDate = null;
		Date startDate = null;
		for(int i=0; i<vos.size(); i++) {
			if(vos.get(i).getEndDate() != null)	{
				endDate = sdf.parse(vos.get(i).getEndDate());
			}
			startDate = sdf.parse(vos.get(i).getRequestDate());
			Date sSearchDate = sdf.parse(startSearchDate);
			Date eSearchDate = sdf.parse(endSearchDate);
			if(startDate.before(sSearchDate) || startDate.after(eSearchDate)) vos.remove(i);
			if(endDate != null) {
				if(endDate.before(sSearchDate) || endDate.after(eSearchDate)) vos.remove(i);
			}
		}
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vos", vos);
		
		return "admin/engineer/asRequestList";
	}
  
  // 신고 게시글 리스트 보기
  @RequestMapping(value = "/report/reportBoardList", method = RequestMethod.GET)
  public String reportBoardListGet(Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part
  		) {
  	PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "reportBoardList", part, "");
  	ArrayList<ReportVO> vos = adminService.getReportBoardList(pageVO.getStartIndexNo(), pageSize,"","");
  	if(!part.equals("")) {
			for(int i=0; i<vos.size(); i++) {
				if(part.equals("freeBoard") && !vos.get(i).getBoard().equals("freeBoard") ) {
					System.out.println(i+"free vos : "+vos.get(i).getBoard());
					vos.remove(i);
				}
				else if(part.equals("questionBoard") && !vos.get(i).getBoard().equals("questionBoard") ) {
					System.out.println(i+"question vos : "+i+"."+vos.get(i).getBoard());
					vos.remove(i);
				}
			}
		}
  	model.addAttribute("pageVO", pageVO);
  	model.addAttribute("vos", vos);
  	return "admin/report/reportBoardList";
  }
  
  // 신고된 게시글 일괄 삭제
  @ResponseBody
  @RequestMapping(value = "/report/reportBoardDeleteAll", method = RequestMethod.POST)
  public String reportBoardDeleteAllPost(String idx) {
  	int res = 0;
  	String[] idxs = idx.split(",");
  	
  	for(String i : idxs) {
  		String[] boardIdx = i.split("/"); // report idx / board 종류
  		int reportIdx = Integer.parseInt(boardIdx[0]);
  		res = adminService.setReportBoardDelete(reportIdx,boardIdx[1]);
  	}
  	return res + "";
  }
  
  // 사이트 통계
  @RequestMapping(value = "/siteChart", method = RequestMethod.GET)
  public String siteChartGet(Model model) {
  	// 탈퇴 현황 pie chart
  	ArrayList<DeleteMemberVO> vos = adminService.getMemberDeleteReason();
  	int[] deleteReasons = new int[6];
  	String[] reasonDetails = new String[6];
  	int[] reasonCnts = new int[6];
  	for(int i=0; i<vos.size(); i++) {
  		deleteReasons[i] = vos.get(i).getDeleteReason();
  		reasonDetails[i] = vos.get(i).getReasonDetail();
  		reasonCnts[i] = vos.get(i).getReasonCnt();
  	}
  	ChartVO vo = new ChartVO();
  	vo.setTitle("탈퇴 사유 현황");
  	vo.setXtitle("탈퇴 사유");
  	vo.setLegend1("비율");
  	model.addAttribute("vo", vo);
  	model.addAttribute("deleteReasons",deleteReasons);
  	model.addAttribute("reasonDetails", reasonDetails);
  	model.addAttribute("reasonCnts", reasonCnts);
  	
  	// 회원 가입 현황 line chart
  	ArrayList<MemberVO> memberVOS = adminService.getMemberJoinDate();
  	int mVosLength = memberVOS.size();
  	String[] joinDates = new String[mVosLength];
  	int[] joinCnts = new int[mVosLength];
  	for(int i=0; i<mVosLength; i++) {
  		joinDates[i] = memberVOS.get(i).getJoinDate();
  		joinCnts[i] = memberVOS.get(i).getJoinCnt();
  	}
  	ChartVO lineVO = new ChartVO();
  	lineVO.setTitle("회원 가입 현황");
  	lineVO.setSubTitle("날짜 별 회원 가입 현황");
  	lineVO.setXtitle("가입자 수");
  	model.addAttribute("lineVO", lineVO);
  	model.addAttribute("joinDates", joinDates);
  	model.addAttribute("joinCnts", joinCnts);
  	model.addAttribute("size", mVosLength);
  	return "admin/siteChart";
  }
	
}
