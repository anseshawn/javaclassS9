package com.spring.javaclassS9.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.Locale;
import java.util.TimeZone;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
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
import com.spring.javaclassS9.service.BoardService;
import com.spring.javaclassS9.service.CustomerService;
import com.spring.javaclassS9.service.EngineerService;
import com.spring.javaclassS9.service.MemberService;
import com.spring.javaclassS9.service.ProductService;
import com.spring.javaclassS9.vo.AsChargeVO;
import com.spring.javaclassS9.vo.AsRequestVO;
import com.spring.javaclassS9.vo.AsRequestVO.Machine;
import com.spring.javaclassS9.vo.AsRequestVO.Progress;
import com.spring.javaclassS9.vo.ChartVO;
import com.spring.javaclassS9.vo.ConsultingVO;
import com.spring.javaclassS9.vo.DeleteMemberVO;
import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.ExpendableVO;
import com.spring.javaclassS9.vo.MemberVO;
import com.spring.javaclassS9.vo.MessageVO;
import com.spring.javaclassS9.vo.NoticeVO;
import com.spring.javaclassS9.vo.PageVO;
import com.spring.javaclassS9.vo.ProductEstimateVO;
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
	
	@Autowired
	BoardService boardService;
	
	@Autowired
	CustomerService customerService;
	
	
	@RequestMapping(value = "/adminMain", method = RequestMethod.GET)
	public String adminMainGet(Model model) {
		int joinCount = adminService.getJoinMemberCount();
		int estimateCount = adminService.getProductEstimateCount();
		int consultingCount = adminService.getNewConsultingCount();
		int newPaymentCount = adminService.getNewPaymentCount();
		model.addAttribute("joinCount", joinCount);
		model.addAttribute("estimateCount", estimateCount);
		model.addAttribute("consultingCount", consultingCount);
		model.addAttribute("newPaymentCount", newPaymentCount);
		return "admin/adminMain";
	}
	
	@ResponseBody
	@RequestMapping(value = "/adminHeader", method = RequestMethod.POST)
	public String adminHeaderPost() {
		int joinCount = adminService.getJoinMemberCount();
		int estimateCount = adminService.getProductEstimateCount();
		int consultingCount = adminService.getNewConsultingCount();
		int newPaymentCount = adminService.getNewPaymentCount();
		
		int res = joinCount+estimateCount+consultingCount+newPaymentCount;
		return res+"";
	}
	@ResponseBody
	@RequestMapping(value = "/adminMessage", method = RequestMethod.POST)
	public String adminMessagePost() {
		int msgCount = adminService.getNewMessageCount();
		return msgCount+"";
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
		ArrayList<MemberVO> mVos = adminService.getAllMemberList(-1, 0);
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
		ArrayList<MemberVO> mVos = adminService.getMemberSearchList(-1, 0, "mid", mid);
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
	
	// 개별사원 DB에서 삭제처리
	@ResponseBody
	@RequestMapping(value = "/engineer/engineerDelete", method = RequestMethod.POST)
	public String engineerDeletePost(@RequestParam(name = "mid", defaultValue = "", required = false) String mid) {
		EngineerVO vo = engineerService.getEngineerIdCheck(mid);
		ArrayList<AsRequestVO> vos = engineerService.getAsRequestList(vo.getIdx(), -1, 0);
		vo.setMid("del_"+vo.getMid());
		vo.setPwd(passwordEncoder.encode("0000"));
		vo.setName(vo.getName()+"(퇴사)");
		vo.setTel("");
		vo.setEmail("");
		int res = 0;
		if(vos != null) {
			AsRequestVO asVo = null;
			for(int i=0; i<vos.size(); i++) {
				asVo = engineerService.getAsRequestContent(vos.get(i).getIdx());
				if(asVo.getProgress().equals(Progress.COMPLETE)) {
					res = adminService.setEngineerDelete(vo);
				}
			}
		}
		else {
			res = adminService.setEngineerDelete(vo);
		}
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
	
	// 소모품 등록 창 출력
	@RequestMapping(value = "/product/expendableInput", method = RequestMethod.GET)
	public String expendableInputGet(Model model) {
		Machine[] categoryMain = Machine.values();
		ArrayList<ExpendableVO> vos = productService.getExpendableList();
		model.addAttribute("vos", vos);
		model.addAttribute("categoryMain", categoryMain);
		return "admin/product/expendableInput";
	}
	
	// 소모품 등록하기
	@RequestMapping(value = "/product/expendableInput", method = RequestMethod.POST)
	public String expendableInputPost(ExpendableVO vo) {
		ExpendableVO exCodeVO = productService.getExpendableCode(vo);
		if(exCodeVO != null) return "redirect:/message/expendableCodeNo";
		int res = productService.setExpendableInput(vo);
		if(res != 0) return "redirect:/message/expendableInputOk";
		else return "redirect:/message/expendableInputNo";
	}
	
	// 소모품 삭제하기
	@RequestMapping(value = "/product/expendableDelete", method = RequestMethod.POST)
	public String expendableDeletePost(ExpendableVO vo) {
		int res = productService.setExpendableDelete(vo);
		return res+"";
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
		ArrayList<ProductVO> vos = productService.getAllProductList(-1, 0);
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
		if(part.equals("")) vos = productService.getAllProductSaleList(pageVO.getStartIndexNo(),pageSize);
		else vos = productService.getSearchProductEstimateList(pageVO.getStartIndexNo(),pageSize,part,searchString);
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vos", vos);
		return "admin/product/productEstimate";
	}
	// 견적 건 상태 변경하기
	@ResponseBody
	@RequestMapping(value = "/product/productSaleChange", method = RequestMethod.POST)
	public String productSaleChangePost(int saleIdx, String statement) {
		ProductEstimateVO vo = productService.getProductEstimateContent(saleIdx);
		if(vo != null) productService.setProductEstimateChange(vo.getIdx(),statement);
		return adminService.setProductSaleChange(saleIdx,statement)+"";
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
	
	// 견적서 작성하기
	@RequestMapping(value = "/product/estimateInput", method = RequestMethod.GET)
	public String estimateInputGet(Model model,
			@RequestParam(name="idx",defaultValue = "0", required = false) int idx
			) {
		ProductSaleVO saleVO = productService.getProductSaleContent(idx);
		ProductVO vo = productService.getProductContent(saleVO.getProductIdx());
		MemberVO mVo = memberService.getMemberIdCheck(saleVO.getMemberMid());
		model.addAttribute("saleVO", saleVO);
		model.addAttribute("vo", vo);
		model.addAttribute("name", mVo.getName());
		return "admin/product/estimateInput";
	}
	
	// 견적서 작성하기
	@Transactional
	@RequestMapping(value = "/product/estimateInput", method = RequestMethod.POST)
	public String estimateInputPost(ProductEstimateVO vo) {
		vo.setUnitPrice(vo.getProPrice() * vo.getQuantity());
		vo.setVat((vo.getUnitPrice() * 10)/100);
		vo.setTotPrice(vo.getUnitPrice() + vo.getVat());
		productService.setProductSaleStatementChange(vo.getSaleIdx(),"check");
		int res = productService.setProductEstimateInput(vo);
		if(res != 0) return "redirect:/message/estimateInputOk";
		else return "redirect:/message/estimateInputNo?idx="+vo.getSaleIdx();
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
	public String asRequestListPost(Model model, String startSearchDate, String endSearchDate,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize
		) throws ParseException {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "adminAsRequestList", "", "");
		ArrayList<AsRequestVO> vos = engineerService.getAllAsRequestList(pageVO.getStartIndexNo(),pageSize,"","");
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date endDate = null;
		Date startDate = null;
		Iterator<AsRequestVO> it = vos.iterator();
		while(it.hasNext()) {
			AsRequestVO vo = it.next();
			if(vo.getEndDate() != null)	{
				endDate = sdf.parse(vo.getEndDate());
			}
			startDate = sdf.parse(vo.getRequestDate());
			
			// 조건 없이 검색버튼 누르면 자동으로 한달전 부터
			String monthBefore = LocalDate.now().minusMonths(1).toString();
			if(startSearchDate.equals("")) startSearchDate = monthBefore;
			
			Date sSearchDate = sdf.parse(startSearchDate);
			Date eSearchDate = sdf.parse(endSearchDate);
			if(endDate != null) {
				if(endDate.before(sSearchDate) || endDate.after(eSearchDate)) it.remove();
			}
			else if(startDate.before(sSearchDate) || startDate.after(eSearchDate)) {
				it.remove();
				//continue;
			}
			// 반복전에 다시 초기화
			startDate = null;
			endDate = null;
		}
		/*
		for(int i=vos.size()-1; i>=0; i--) {
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
		*/
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vos", vos);
		
		return "admin/engineer/asRequestList";
	}
	
	// A/S 현황 내용 보기
	@RequestMapping(value = "/engineer/asRequestContent", method = RequestMethod.GET)
	public String asRequestContentGet(Model model, 
			@RequestParam(name="idx",defaultValue = "1", required = false) int idx,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize
			) throws ParseException {
		AsRequestVO vo = customerService.getAsRequestContent(idx);
		String progress = "";
		if(vo.getProgress().toString().equals("REGIST")) progress = "신청완료";
		else if(vo.getProgress().toString().equals("ACCEPT")) progress = "접수완료";
		else if(vo.getProgress().toString().equals("PROGRESS")) progress = "진행중";
		else if(vo.getProgress().toString().equals("PAYMENT")) progress = "입금대기";
		else if(vo.getProgress().toString().equals("COMPLETE")) progress = "진행완료";
		
		AsChargeVO chargeVO = customerService.getAsChargeContent(idx);
		if(chargeVO != null) {
			String[] expendables = chargeVO.getExpendableName().split(",");
			String[] quantities = chargeVO.getQuantity().split(",");
			model.addAttribute("quantities", quantities);
			model.addAttribute("expendables", expendables);
			model.addAttribute("chargeVO", chargeVO);
		}
		model.addAttribute("vo", vo);
		model.addAttribute("progress", progress);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		
		return "admin/engineer/asRequestContent";
	}
	
	// A/S 결제 내용 확인하기
	@ResponseBody
	@RequestMapping(value = "/engineer/asPaymentCheck", method = RequestMethod.POST)
	public String asPaymentCheckPost(
			@RequestParam(name="idx",defaultValue = "1", required = false) int idx
			) throws ParseException {
		int res = customerService.setAsCompleteStatement(idx);
		return res+"";
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
			for(int i=vos.size()-1; i>=0; i--) {
				if(part.equals("freeBoard") && !vos.get(i).getBoard().equals("freeBoard")) vos.remove(i);
				else if(part.equals("questionBoard") && !vos.get(i).getBoard().equals("questionBoard")) vos.remove(i);
				else if(part.equals("recruitBoard") && !vos.get(i).getBoard().equals("recruitBoard")) vos.remove(i);
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
  	System.out.println("idx(제일 마지막에 쉼표 여부): "+idx);
  	String[] idxs = idx.split(",");
  	for(String i : idxs) {
  		String[] boardIdx = i.split("/"); // report idx / board 종류
  		int reportIdx = Integer.parseInt(boardIdx[0]); // [0]: 신고 테이블의 idx, [1]: 신고된 게시판 종류
  		res = adminService.setReportBoardDelete(reportIdx,boardIdx[1]);
  	}
  	return res + "";
  }
  
  // 신고된 게시글 하나만 삭제
  @ResponseBody
  @RequestMapping(value = "/report/reportBoardDeleteOne", method = RequestMethod.POST)
  public String reportBoardDeleteOnePost(int idx, String board) {
  	int res = adminService.setReportBoardDelete(idx,board);
  	return res + "";
  }
  
  // 신고된 게시글 내용 보기
  @ResponseBody
  @RequestMapping(value = "/report/reportBoardContent", method = RequestMethod.POST)
  public ReportVO reportContentPost(int idx, String board) {
  	ReportVO vo = adminService.getReportBoardContent(idx, board);
  	return vo;
  }
  
  // 문의 내역 리스트 보기
  @RequestMapping(value = "/consultingList", method = RequestMethod.GET)
  public String consultingListGet(Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
			) {
  	PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "consulting", part, searchString);
  	ArrayList<ConsultingVO> vos = adminService.getConsultingList(pageVO.getStartIndexNo(),pageSize,part,searchString);
  	model.addAttribute("pageVO", pageVO);
  	model.addAttribute("vos", vos);
  	return "admin/consultingList";
  }
  // 문의 내역 리스트 보기(기간 검색)
  @RequestMapping(value = "/consultingList", method = RequestMethod.POST)
  public String consultingListPost(Model model, String startSearchDate, String endSearchDate,
  		@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
  		@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
  		@RequestParam(name = "part", defaultValue = "", required = false) String part,
  		@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
  		) throws ParseException {
  	PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "consulting", part, searchString);
  	ArrayList<ConsultingVO> vos = adminService.getConsultingList(pageVO.getStartIndexNo(),pageSize,part,searchString);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date writeDate = null;
		for(int i=vos.size()-1; i>=0; i--) {
			writeDate = sdf.parse(vos.get(i).getWriteDate());
			Date sSearchDate = sdf.parse(startSearchDate);
			Date eSearchDate = sdf.parse(endSearchDate);
			if(writeDate.before(sSearchDate) || writeDate.after(eSearchDate)) vos.remove(i);
		}
		model.addAttribute("pageVO", pageVO);
  	model.addAttribute("vos", vos);
  	return "admin/consultingList";
  }
  // 문의 내역 내용 보기
  @ResponseBody
  @RequestMapping(value = "/consultingContent", method = RequestMethod.POST)
  public ConsultingVO consultingContentPost(
  		@RequestParam(name="idx",defaultValue = "0", required = false) int idx
  		) {
  	ConsultingVO vo = adminService.getConsultingContent(idx);
  	return vo;
  }
  // 문의 답변하기
  @Transactional
  @ResponseBody
  @RequestMapping(value = "/consultingAnswer", method = RequestMethod.POST)
  public String consultingAnswerPost(HttpServletRequest request,
  		@RequestParam(name="idx",defaultValue = "0", required = false) int idx,
  		@RequestParam(name="answer",defaultValue = "", required = false) String answer,
  		@RequestParam(name="email",defaultValue = "", required = false) String email
  		) throws MessagingException {
  	int res = adminService.setConsultingAnswer(idx,answer);
  	javaclassProvide.mailSend(email, "문의에 대한 답변이 등록되었습니다.", answer, "consultingAnswer", request);
  	return res + "";
  }
  
  // 공지사항 입력 폼 띄우기
  @RequestMapping(value = "/notice/noticeInput", method = RequestMethod.GET)
  public String noticeInputGet() {
  	return "admin/notice/noticeInput";
  }
  
  // 팝업 공지 존재 여부 체크
  @ResponseBody
  @RequestMapping(value = "/notice/popupCheck", method = RequestMethod.POST)
  public String popupCheckGet() {
  	int res = 0;
  	NoticeVO vo = adminService.getPopupNoticeContent();
  	if(vo != null) res = 1;
  	return res + "";
  }
  // 기존의 팝업 공지 팝업여부 삭제
  @ResponseBody
  @RequestMapping(value = "/notice/popupChange", method = RequestMethod.POST)
  public String popupChangeGet() {
  	int res = adminService.setPopupNoticeDelete();
  	return res + "";
  }
  
  // 공지사항 입력하기
  @RequestMapping(value = "/notice/noticeInput", method = RequestMethod.POST)
  public String noticeInputPost(NoticeVO vo) {
  	if(vo.getPopup()==null) vo.setPopup("NO");
  	if(vo.getImportant()==null) vo.setImportant("NO");
  	if(vo.getPart().equals("notices")) vo.setEndDate(null);
  	if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgCheck(vo.getContent(),"notice");
		vo.setContent(vo.getContent().replace("/data/ckeditor", "/data/notice/"));
  	int res = adminService.setNoticeInputOk(vo);
  	if(res != 0) return "redirect:/message/noticeInputOk";
  	else return "redirect:/message/noticeInputNo";
  }
  
  // 공지사항 내용보기
  @RequestMapping(value = "/notice/noticeContent", method = RequestMethod.GET)
  public String noticeContentGet(Model model,
  		@RequestParam(name = "idx", defaultValue = "0", required = false) int idx
  		) {
  	NoticeVO vo = adminService.getNoticeContent(idx);
  	model.addAttribute("vo", vo);
  	return "admin/notice/noticeContent";
  }
  
  // 공지사항 삭제하기
  @RequestMapping(value = "/notice/noticeDelete", method = RequestMethod.GET)
  public String noticeDeleteGet(
  		@RequestParam(name = "idx", defaultValue = "0", required = false) int idx
  		) {
  	NoticeVO vo = adminService.getNoticeContent(idx);
  	if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgDelete(vo.getContent(), "notice");
  	int res = adminService.setNoticeDelete(idx);
  	if(res != 0) return "redirect:/message/noticeDeleteOk";
  	else return "redirect:/message/noticeDeleteNo";
  }
  
  // 공지사항 수정창 띄우기
  @RequestMapping(value = "/notice/noticeEdit", method = RequestMethod.GET)
  public String noticeEditGet(Model model,
  		@RequestParam(name = "idx", defaultValue = "0", required = false) int idx
  		) {
  	NoticeVO vo = adminService.getNoticeContent(idx);
		LocalDate today = LocalDate.now();
		model.addAttribute("today", today);
  	model.addAttribute("vo", vo);
  	return "admin/notice/noticeEdit";
  }
  
  // 공지사항 수정하기
  @RequestMapping(value = "/notice/noticeEdit", method = RequestMethod.POST)
  public String noticeEditPost(NoticeVO vo) {
  	if(vo.getPopup()==null) vo.setPopup("NO");
  	if(vo.getImportant()==null) vo.setImportant("NO");
  	if(vo.getPart().equals("notices")) vo.setEndDate(null);
  	// 기존 데이터 삭제
  	NoticeVO orignVO = adminService.getNoticeContent(vo.getIdx());
  	if(orignVO.getContent().indexOf("src=\"/") != -1) boardService.imgDelete(orignVO.getContent(), "notice");
  	// 수정한 글에 이미지 있으면 업데이트
  	if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgCheck(vo.getContent(),"notice");
		vo.setContent(vo.getContent().replace("/data/ckeditor", "/data/notice/"));
  	int res = adminService.setNoticeEdit(vo);
  	if(res != 0) return "redirect:/message/noticeEditOk?idx="+vo.getIdx();
  	else return "redirect:/message/noticeEditNo?idx="+vo.getIdx();
  }
  
  // 공지사항 리스트 보기
  @RequestMapping(value = "/notice/noticeList", method = RequestMethod.GET)
	public String noticeListGet(Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
		) {
		ArrayList<NoticeVO> imVos = adminService.getImportantNoticeList();
		
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "notice", part, searchString);
		ArrayList<NoticeVO> vos = adminService.getNoticeListAll(pageVO.getStartIndexNo(),pageSize,part,searchString);
		if(!part.equals(""))	{
			if(part.equals("title")) part = "제목";
			else if(part.equals("content")) part = "내용";
			else if(part.equals("part")) part = "분류";
			model.addAttribute("part", part);
			model.addAttribute("searchString", searchString);
			model.addAttribute("searchCount", vos.size());
		}
		LocalDate today = LocalDate.now();
		model.addAttribute("today", today);
		model.addAttribute("imVos", imVos);
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		return "admin/notice/noticeList";
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
  	
  	// 회원 가입 사유 bar chart
  	String[] joinReason = new String[5];
  	int[] joinReasonCnts = new int[5];
  	for(int i=0; i<mVosLength; i++) {
  		String purpose = memberVOS.get(i).getPurpose();
  		String[] pur = purpose.split(",");
  	}
  	return "admin/siteChart";
  }
  
  // 관리자 비밀번호 변경
  @RequestMapping(value = "/changeAdminPwd", method = RequestMethod.GET)
  public String changeAdminPwdGet() {
  	return "admin/changeAdminPwd";
  }
  // 관리자 비밀번호 변경
	@RequestMapping(value = "/changeAdminPwd", method = RequestMethod.POST)
	public String changeAdminPwdPost(String mid, String pwdNew, HttpSession session) {
		int res = 0;
		res = memberService.setMemberPwdUpdate(mid, passwordEncoder.encode(pwdNew));
		if(res != 0) {
			session.invalidate();
			return "redirect:/message/pwdChangeOk";
		}
		else return "redirect:/message/pwdChangeNo";
	}
	
	
	// 관리자 쪽지 확인
	@RequestMapping(value = "/messageList", method = RequestMethod.GET)
	public String messageListGet(HttpSession session, Model model) {
		String mid = (String) session.getAttribute("sMid");
		ArrayList<MessageVO> receiveVOS = memberService.getAllReceiveMessageList(mid);
		ArrayList<MessageVO> sendVOS = memberService.getAllSendMessageList(mid);
		for(int i=0; i<receiveVOS.size(); i++) {
			if(receiveVOS.get(i).getReceiveSw().equals("n")) model.addAttribute("newMsg", "OK");
		}
		ArrayList<MemberVO> mVos = adminService.getAllMemberList(-1, 0);
		model.addAttribute("mVos", mVos);
		model.addAttribute("receiveVOS", receiveVOS);
		model.addAttribute("sendVOS", sendVOS);
		return "admin/messageList";
	}
	// 쪽지 수신확인 상태로 만들기
	@ResponseBody
	@RequestMapping(value = "/messageCheck", method = RequestMethod.POST)
	public void messageCheckPost(int idx) {
		memberService.setMessageCheck(idx);
	}
	// 받은 메세지 / 보낸 메세지 삭제하기
	@ResponseBody
	@RequestMapping(value = "/messageDelete", method = RequestMethod.POST)
	public String messageDeletePost(int idx, String sw) {
		int res =	memberService.setMessageDelete(idx, sw);
		return res + "";
	}
	
	// 쪽지 보내기 창
	@RequestMapping(value = "/sendMessage", method = RequestMethod.GET)
	public String sendMessageGet(Model model,
			@RequestParam(name = "receiveMid", defaultValue = "", required = false) String receiveMid
			) {
		model.addAttribute("receiveMid", receiveMid);
		return "member/sendMessage";
	}
	// 쪽지 보내기
	@ResponseBody
	@RequestMapping(value = "/sendMessage", method = RequestMethod.POST)
	public String sendMessagePost(MessageVO vo) {
		MemberVO mVo = memberService.getMemberIdCheck(vo.getReceiveMid());
		int res = 0;
		if(mVo==null) return res+"";
		else {
			vo.setSendSw("s");
			vo.setReceiveSw("n");
			res = memberService.setMessageInputOk(vo);
		}
		return res + "";
	}
}
