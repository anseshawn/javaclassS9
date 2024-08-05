package com.spring.javaclassS9.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.Locale;
import java.util.TimeZone;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS9.common.JavaclassProvide;
import com.spring.javaclassS9.pagination.PageProcess;
import com.spring.javaclassS9.service.CustomerService;
import com.spring.javaclassS9.service.EngineerService;
import com.spring.javaclassS9.service.MemberService;
import com.spring.javaclassS9.service.ProductService;
import com.spring.javaclassS9.vo.AsChargeVO;
import com.spring.javaclassS9.vo.AsRequestVO;
import com.spring.javaclassS9.vo.AsRequestVO.Machine;
import com.spring.javaclassS9.vo.AsRequestVO.Progress;
import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.ExpendableVO;
import com.spring.javaclassS9.vo.MemberVO;
import com.spring.javaclassS9.vo.Message2VO;
import com.spring.javaclassS9.vo.MessageVO;
import com.spring.javaclassS9.vo.PageVO;
import com.spring.javaclassS9.vo.ScheduleVO;

@Controller
@RequestMapping("/engineer")
public class EngineerController {
	
	@Autowired
	EngineerService engineerService;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	JavaclassProvide javaclassProvide;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	CustomerService customerService;
	
	@Autowired
	ProductService productService;
	
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
	
	// 일정관리 화면
	@RequestMapping(value = "/schedule", method = RequestMethod.GET)
	public String scheduleGet(HttpSession session, Model model) {
		String mid = (String)session.getAttribute("sMid");
		EngineerVO mVo = engineerService.getEngineerIdCheck(mid);
		model.addAttribute("mVo", mVo);
		return "engineer/schedule";
	}

	// 전체 일정 불러오기
	@ResponseBody
	@RequestMapping(value = "/scheduleListAll", method = RequestMethod.POST)
	public ArrayList<ScheduleVO> scheduleListAllPost(
			@RequestParam(name = "engineerIdx", defaultValue = "0", required = false) int engineerIdx
			) {
		return engineerService.getScheduleListOne(engineerIdx);
	}
	
	// 일정 삭제
  @ResponseBody
  @RequestMapping(value = "/scheduleDelete", method = RequestMethod.POST)
  public String scheduleDeletePost(
	    @RequestParam(name="title", defaultValue = "", required = false) String title,
	    @RequestParam(name="engineerIdx", defaultValue = "0", required = false) int engineerIdx,
	    @RequestParam(name="start", defaultValue = "", required = false) String startTime,
	    @RequestParam(name="end", defaultValue = "", required = false) String endTime,
	    @RequestParam(name="allDay", defaultValue = "false" , required = false) Boolean allDay
    ) throws ParseException {
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
	  System.out.println("formattedStartTime : " + formattedStartTime);
    int res = 0;
    startTime = startTime.replace("-오전", "");
    startTime = startTime.replace("-오후", "");
    endTime = endTime.replace("-오전", "");
    endTime = endTime.replace("-오후", "");
    if(allDay == true) {
        System.out.println("들어옴1");
        String startTimeChange = startTime.substring(10,19);
        startTime = startTime.replace(startTimeChange, " 00:00:00");
        res = engineerService.setScheduleDeleteTrue(title,engineerIdx,formattedStartTime);                        
    } else {            
        System.out.println("들어옴2");
        System.out.println(title+","+formattedStartTime+","+formattedEndTime+","+allDay);
        res = engineerService.setScheduleDelete(title,engineerIdx,formattedStartTime,formattedEndTime, allDay);            
    }
    
    return res+"";
  }
  
  // 일정 추가
  @ResponseBody
  @RequestMapping(value = "/scheduleInput", method = RequestMethod.POST)
  public String scheduleInputPost(
          ScheduleVO vo,
          @RequestParam(name="title", defaultValue = "", required = false) String title,
          @RequestParam(name="engineerIdx", defaultValue = "0", required = false) int engineerIdx,
          @RequestParam(name="start", defaultValue = "", required = false) String startTime,
          @RequestParam(name="end", defaultValue = "", required = false) String endTime,
          @RequestParam(name="allDay", defaultValue = "false" , required = false) Boolean allDay,
  				@RequestParam(name="sw", defaultValue = "" , required = false) String sw) {
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
        vo.setEngineerIdx(engineerIdx);

        res = engineerService.setScheduleInput(vo);

      } catch (ParseException e) {
          e.printStackTrace();
      }

      return String.valueOf(res);
  }
  
  // 일정 수정하기
  @Transactional
  @ResponseBody
  @RequestMapping(value = "/scheduleUpdate", method = RequestMethod.POST)
  public String  scheduleUpdatePost(
        @RequestParam(name="idx", defaultValue = "", required = false) int idx,
        @RequestParam(name="title", defaultValue = "", required = false) String title,
        @RequestParam(name="engineerIdx", defaultValue = "0", required = false) int engineerIdx,
		    @RequestParam(name="start", defaultValue = "", required = false) String startTime,
		    @RequestParam(name="end", defaultValue = "", required = false) String endTime,
		    @RequestParam(name="allDay", defaultValue = "false" , required = false) Boolean allDay
      ) throws ParseException {
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
      AsRequestVO asVO = customerService.getAsRequestScheduleName(title);
      if(asVO != null) {
      	customerService.setAsAppointmentChange(title,formattedStartTime);
      }
      vo.setTitle(title);
      vo.setStartTime(formattedStartTime);
      vo.setEndTime(formattedEndTime);
      vo.setAllDay(allDay);
      vo.setIdx(idx);
      vo.setEngineerIdx(engineerIdx);
		  System.out.println(vo);
      res = engineerService.setScheduleUpdate(vo);
		
      // 예시: 일정 업데이트 성공 여부에 따라 응답    
      
  		return res+"";
  }
  
  // A/S요청 들어온 현황 보기
	@RequestMapping(value = "/asRequestList", method = RequestMethod.GET)
	public String asRequestListGet(HttpSession session, Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
		) {
		String mid = (String)session.getAttribute("sMid");
		EngineerVO mVo = engineerService.getEngineerIdCheck(mid);
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "asRequest", "engineerIdx", mVo.getIdx()+"");
		ArrayList<AsRequestVO> vos = engineerService.getAsRequestList(mVo.getIdx(),pageVO.getStartIndexNo(),pageSize);
		model.addAttribute("mVo", mVo);
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		return "engineer/asRequestList";
	}
	
	// A/S요청 들어온 현황 기간으로 검색
	@RequestMapping(value = "/asRequestList", method = RequestMethod.POST)
	public String asRequestListPost(HttpSession session, Model model, String startSearchDate, String endSearchDate,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize
		) throws ParseException {
		String mid = (String) session.getAttribute("sMid");
		EngineerVO mVo = engineerService.getEngineerIdCheck(mid);
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "asRequest", "engineerIdx", mVo.getIdx()+"");
		ArrayList<AsRequestVO> vos = engineerService.getAsRequestList(mVo.getIdx(),pageVO.getStartIndexNo(),pageSize);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if(!startSearchDate.equals("") && !endSearchDate.equals("")) {
			for(int i=vos.size()-1; i>=0; i--) {
				Date endDate = null;
				Date startDate = null;
				if(vos.get(i).getEndDate() != null)	{
					endDate = sdf.parse(vos.get(i).getEndDate());
				}
				startDate = sdf.parse(vos.get(i).getRequestDate());
				Date sSearchDate = sdf.parse(startSearchDate);
				Date eSearchDate = sdf.parse(endSearchDate);
				if(startDate.before(sSearchDate) || startDate.after(eSearchDate)) {
					vos.remove(i);
					continue;
				}
				if(endDate != null) {
					if(endDate.before(sSearchDate) || endDate.after(eSearchDate)) {
						vos.remove(i);
					}
				}
			}
		}
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vos", vos);
		
		return "engineer/asRequestList";
	}
	
	// A/S요청 상세 내용 1건 보기
	@RequestMapping(value = "/asRequestContent", method = RequestMethod.GET)
	public String asRequestContentGet(Model model,
			@RequestParam(name = "idx", defaultValue = "0", required = false) int idx,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize
		) {
		AsRequestVO vo = engineerService.getAsRequestContent(idx);
		//if(vo.getDate_diff() == 0) vo.setProgress(Progress.PROGRESS);
		// 엔지니어가 일정이 있으면 제외처리(datePicker로 가져가기...)
		ArrayList<ScheduleVO> dateVOS = engineerService.getEngineerSchedule(vo.getEngineerIdx());
		HashSet<String> dateSet = new HashSet<String>();
		for(int i=0; i<dateVOS.size(); i++) {
			dateSet.add(dateVOS.get(i).getStartDate());
			dateSet.add(dateVOS.get(i).getEndDate());
		}
		String[] dates = dateSet.toArray(new String[0]);
		model.addAttribute("dates", dates);
		model.addAttribute("datesSize", dates.length);
		ArrayList<ExpendableVO> exVos = productService.getExpendableListOne(vo.getMachine());
		AsChargeVO chargeVO = customerService.getAsChargeContent(idx);
		if(chargeVO != null) {
			String[] expendables = chargeVO.getExpendableName().split(",");
			String[] quantities = chargeVO.getQuantity().split(",");
			model.addAttribute("quantities", quantities);
			model.addAttribute("expendables", expendables);
			model.addAttribute("chargeVO", chargeVO);
		}
		model.addAttribute("vo", vo);
		model.addAttribute("exVos", exVos);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		return "engineer/asRequestContent";
	}
	
	// A/S요청 상세 내용 신청자 정보 보기
	@ResponseBody
	@RequestMapping(value = "/getMemberContent", method = RequestMethod.POST)
	public MemberVO getMemberContentPost(String mid) {
		MemberVO mVo = memberService.getMemberIdCheck(mid);
		return mVo;
	}
	
	// A/S요청 날짜 고정하고 진행 상태 바꾸기
	@ResponseBody
	@RequestMapping(value = "/asRequestDateFixed", method = RequestMethod.POST)
	public String asRequestDateFixedPost(int idx, String asDate, Progress progress) {
		int res = customerService.setAsChangeStatement(idx, asDate, progress);
		return res+"";
	}
	
	// A/S요청 취소하기(일정 있으면 일정 삭제도)
	@Transactional
	@ResponseBody
	@RequestMapping(value = "/asRequestDelete", method = RequestMethod.POST)
	public String asRequestDeletePost(
	    @RequestParam(name="idx", defaultValue = "", required = false) int idx,
	    @RequestParam(name="title", defaultValue = "", required = false) String title,
	    @RequestParam(name="engineerIdx", defaultValue = "0", required = false) int engineerIdx,
	    @RequestParam(name="startTime", defaultValue = "", required = false) String startTime
			) {
		int res = 0;
		AsRequestVO vo = customerService.getAsRequestContent(idx);
		if(!vo.getProgress().equals(Progress.REGIST) && !vo.getProgress().equals(Progress.ACCEPT)) res = 0;
		else if(vo.getProgress().equals(Progress.ACCEPT)){
			startTime = startTime.substring(0,startTime.length()-2);
			res = customerService.setAsDeleteOk(idx);
			engineerService.setScheduleDeleteTrue(title, engineerIdx, startTime);
		}
		else {
			res = customerService.setAsDeleteOk(idx);
		}
		return res+"";
	}
	
	// A/S요청 코멘트 적기(이후 입금대기로 상태 변경)
	@ResponseBody
	@RequestMapping(value = "/asCommentInput", method = RequestMethod.POST)
	public String asCommentInputPost(AsRequestVO vo) {
		vo.setProgress(Progress.PAYMENT);
		int res = customerService.setAsAppointmentComplete(vo);
		return res+"";
	}
	
	// A/S 진행시에 이용한 소모품 입력(이후 입금대기로 상태 변경)
	@ResponseBody
	@RequestMapping(value = "/expendableUseInput", method = RequestMethod.POST)
	public String expendableUseInputPost(int asIdx, Machine categoryMain, 
			String[] expendableNames, String[] quantities) {
		AsChargeVO vo = new AsChargeVO();
		vo.setAsIdx(asIdx);
		vo.setCategoryMain(categoryMain);
		int price = 0;
		String expendableName = "";
		String quantity = "";
		if(expendableNames != null && expendableNames.length != 0) { // 소모품 사용한 게 있다면 계산
			ExpendableVO exVO = null;
			for(int i=0; i<expendableNames.length; i++) {
				expendableName += expendableNames[i]+",";
				quantity += quantities[i]+",";
				exVO = productService.getExpendableNameCheck(expendableNames[i]);
				price += exVO.getPrice() * Integer.parseInt(quantities[i]);
			}
			expendableName = expendableName.substring(0,expendableName.length()-1);
			quantity = quantity.substring(0, quantity.length()-1);
		}
		// 엔지니어 idx
		AsRequestVO asVO = customerService.getAsRequestContent(asIdx);
		vo.setEngineerIdx(asVO.getEngineerIdx());
		vo.setExpendableName(expendableName);
		vo.setPrice(price);
		vo.setQuantity(quantity);
		int tot = price+100000; //인건비포함
		int totPrice = tot+ ((tot * 10) / 100);
		vo.setTotPrice(totPrice);
		int res = customerService.setAsChargeInput(vo);
		return res+"";
	}
	
	// 받은 메세지/보낸 메세지 리스트
	@RequestMapping(value = "/messageList", method = RequestMethod.GET)
	public String messageListGet(HttpSession session, Model model) {
		String mid = (String) session.getAttribute("sMid");
		ArrayList<Message2VO> receiveVOS = engineerService.getAllReceiveMessageList(mid);
		ArrayList<Message2VO> sendVOS = engineerService.getAllSendMessageList(mid);
		for(int i=0; i<receiveVOS.size(); i++) {
			if(receiveVOS.get(i).getReceiveSw().equals("n")) model.addAttribute("newMsg", "OK");
		}
		ArrayList<EngineerVO> eVos = engineerService.getAllEngineerList(-1, 0);
		model.addAttribute("receiveVOS", receiveVOS);
		model.addAttribute("sendVOS", sendVOS);
		model.addAttribute("eVos", eVos);
		return "engineer/messageList";
	}
	// 아이디로 사원 검색
	@ResponseBody
	@RequestMapping(value = "/midSearch", method = RequestMethod.POST)
	public ArrayList<EngineerVO> midSearchPost(Model model, String mid) {
		ArrayList<EngineerVO> eVos = engineerService.getEngineerSearchList(-1, 0, "mid", mid);
		return eVos;
	}
	// 쪽지 수신확인 상태로 만들기
	@ResponseBody
	@RequestMapping(value = "/messageCheck", method = RequestMethod.POST)
	public void messageCheckPost(int idx) {
		engineerService.setMessageCheck(idx);
	}
	// 받은 메세지 / 보낸 메세지 삭제하기
	@ResponseBody
	@RequestMapping(value = "/messageDelete", method = RequestMethod.POST)
	public String messageDeletePost(int idx, String sw) {
		int res =	engineerService.setMessageDelete(idx, sw);
		return res + "";
	}
	
	// 쪽지 보내기 창
	@RequestMapping(value = "/sendMessage", method = RequestMethod.GET)
	public String sendMessageGet(Model model,
			@RequestParam(name = "receiveMid", defaultValue = "", required = false) String receiveMid
			) {
		model.addAttribute("receiveMid", receiveMid);
		return "engineer/sendMessage";
	}
	// 쪽지 보내기
	@ResponseBody
	@RequestMapping(value = "/sendMessage", method = RequestMethod.POST)
	public String sendMessagePost(Message2VO vo, HttpSession session) {
		EngineerVO eVo = engineerService.getEngineerIdCheck(vo.getReceiveMid());
		int level = (int) session.getAttribute("sLevel");
		int res = 0;
		if(eVo==null || level>1) return res+"";
		else {
			vo.setSendSw("s");
			vo.setReceiveSw("n");
			res = engineerService.setMessageInputOk(vo);
		}
		return res + "";
	}
	// 쪽지 완전 삭제하기 (DB삭제)
	@ResponseBody
	@RequestMapping(value = "/messageDeleteDB", method = RequestMethod.POST)
	public String messageDeleteDBPost(int idx) {
		int res =	engineerService.setMessageDeleteDB(idx);
		return res + "";
	}
}
