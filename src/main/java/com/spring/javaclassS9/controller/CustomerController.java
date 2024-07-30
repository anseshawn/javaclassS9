package com.spring.javaclassS9.controller;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType0Font;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.javaclassS9.pagination.PageProcess;
import com.spring.javaclassS9.service.BoardService;
import com.spring.javaclassS9.service.CustomerService;
import com.spring.javaclassS9.service.EngineerService;
import com.spring.javaclassS9.service.MemberService;
import com.spring.javaclassS9.vo.AsChargeVO;
import com.spring.javaclassS9.vo.AsRequestVO;
import com.spring.javaclassS9.vo.BoardLikeVO;
import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.FreeBoardVO;
import com.spring.javaclassS9.vo.NewsVO;
import com.spring.javaclassS9.vo.PageVO;
import com.spring.javaclassS9.vo.QuestionBoardVO;
import com.spring.javaclassS9.vo.RecruitBoardVO;
import com.spring.javaclassS9.vo.ReplyVO;
import com.spring.javaclassS9.vo.ReportVO;
import com.spring.javaclassS9.vo.ReviewVO;

@Controller
@RequestMapping("/customer")
public class CustomerController {
	
	@Autowired
	EngineerService engineerService;
	
	@Autowired
	CustomerService customerService;
	
	@Autowired
	BoardService boardService;
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	PageProcess pageProcess;
	
	@RequestMapping(value = "/cmain", method = RequestMethod.GET)
	public String cmainGet() {
		return "customer/cmain";
	}
	/*
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
		*//*
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
	*/
	
	@ResponseBody
	@RequestMapping(value = "/cmain", method = RequestMethod.POST)
	public ArrayList<NewsVO> cmainPost(String search) throws IOException {
		Connection conn = Jsoup.connect(search);
		Document document = conn.get();
		
		Elements selects = null;
		
		ArrayList<NewsVO> vos = new ArrayList<NewsVO>();
		selects = document.select("div.sa_text");
		
		NewsVO vo = null;
		for(Element select : selects) {
			vo = new NewsVO();
			Element title = select.selectFirst("a.sa_text_title");
			if(title != null) {
				vo.setItem1(title.html().replace("b>", "div>"));
				vo.setItem1Url(title.attr("href"));
			}
			
			Element content = select.selectFirst("div.sa_text_lede");
			if(content != null) {
				vo.setItem2(content.html()+" ……");
			}
			
			Element images = select.selectFirst("div.sa_thumb._LAZY_LOADING");
			if(images != null) {
				vo.setItem3(images.attr("_LAZY_LOADING"));
			}
			else vo.setItem3("");
			
			Element broadcast = select.selectFirst("div.sa_text_press");
			if(broadcast != null) {
				vo.setItem4(broadcast.html());
			}
			Element time = select.selectFirst("div.sa_text_datetime");
			if(time != null) {
				vo.setItem5(time.html());
			}
			
			//System.out.println("vo1: "+vo.getItem1());
			//System.out.println("url: "+vo.getItem1Url());
			//System.out.println("vo2: "+vo.getItem2());
			//System.out.println("vo3: "+vo.getItem3());
			//System.out.println("vo4: "+vo.getItem4());
			//System.out.println("vo5: "+vo.getItem5());
			
			vos.add(vo);
		}
		return vos;
	}
	
	// A/S 신청
	@RequestMapping(value = "requests/asRequest", method = RequestMethod.GET)
	public String asRequestGet(Model model) {
		ArrayList<EngineerVO> vos = engineerService.getAllEngineerList(-1, 0);
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
		for(int i=vos.size()-1; i>=0; i--) {
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
		model.addAttribute("sw", sw);
		return "customer/requests/asContent";
	}
	
	// A/S 완료 시 별점 남기기
	@ResponseBody
	@RequestMapping(value = "/reviewInput", method = RequestMethod.POST)
	public String reviewInputPost(ReviewVO vo) {
		return customerService.setReviewInput(vo)+"";
	}
	
	// A/S 창에서 엔지니어 별점 보기
	@ResponseBody
	@RequestMapping(value = "/requests/engineerStarShow", method = RequestMethod.POST)
	public ArrayList<ReviewVO> engineerStarShowPost(int engineerIdx) {
		ArrayList<ReviewVO> vos = customerService.getReviewList(engineerIdx);
		return vos;
	}
	
	// 자유게시판 연결
	@RequestMapping(value = "/board/freeBoardList", method = RequestMethod.GET)
	public String freeBoardListGet(Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
			) {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "freeBoard", part, searchString);
		ArrayList<FreeBoardVO> vos = null;
		if(part.equals(""))	vos = boardService.getFreeBoardList(pageVO.getStartIndexNo(),pageSize, "", "");
		else {
			vos = boardService.getFreeBoardList(pageVO.getStartIndexNo(), pageSize, part, searchString);
			if(part.equals("title")) part = "제목";
			else if(part.equals("nickName")) part = "작성자";
			else if(part.equals("content")) part = "내용";
			model.addAttribute("part", part);
			model.addAttribute("searchString", searchString);
			model.addAttribute("searchCount", vos.size());
		}
		ArrayList<FreeBoardVO> gVos = boardService.getFreeBoardBestList();
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vos", vos);
		model.addAttribute("gVos", gVos);
		return "customer/board/freeBoardList";
	}
	
	// 자유게시판 글 작성창 띄우기
	@RequestMapping(value = "/board/freeBoardInput", method = RequestMethod.GET)
	public String freeBoardInputGet() {
		return "customer/board/freeBoardInput";
	}
	// 자유게시판 글 작성
	@RequestMapping(value = "/board/freeBoardInput", method = RequestMethod.POST)
	public String freeBoardInputPost(FreeBoardVO vo) {
		if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgCheck(vo.getContent(),"freeBoard");
		vo.setContent(vo.getContent().replace("/data/ckeditor", "/data/freeBoard/"));
		int res = boardService.setFreeBoardInput(vo);
		if(res != 0) return "redirect:/message/boardInputOk?pathFlag=freeBoard";
		else return "redirect:/message/boardInputNo?pathFlag=freeBoard";
	}
	
	// 자유게시판 글 수정창 띄우기
	@RequestMapping(value = "/board/freeBoardEdit", method = RequestMethod.GET)
	public String freeBoardEditGet(Model model,
			@RequestParam(name="idx",defaultValue = "0", required = false) int idx,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize
		) {
		FreeBoardVO vo = boardService.getFreeBoardContent(idx);
		model.addAttribute("vo", vo);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		return "customer/board/freeBoardEdit";
	}
	// 자유게시판 글 수정하기
	@RequestMapping(value = "/board/freeBoardEdit", method = RequestMethod.POST)
	public String freeBoardEditPost(FreeBoardVO vo) {
		FreeBoardVO originVO = boardService.getFreeBoardContent(vo.getIdx());
		if(!originVO.getContent().equals(vo.getContent())) {
			if(originVO.getContent().indexOf("src=\"/")!= -1) boardService.imgDelete(originVO.getContent(),"freeBoard");
			vo.setContent(vo.getContent().replace("/data/freeBoard/", "/data/ckeditor/"));
			if(vo.getContent().indexOf("src=\"/")!= -1) boardService.imgCheck(vo.getContent(),"freeBoard");
			vo.setContent(vo.getContent().replace("/data/ckeditor/", "/data/freeBoard/"));
		}
		int res = boardService.setFreeBoardEdit(vo);
		if(res != 0) return "redirect:/message/boardEditOk?pathFlag=freeBoard";
		else return "redirect:/message/boardEditNo?pathFlag=freeBoard&idx="+vo.getIdx();
	}
	
	// 자유게시판 내용 보기
	@RequestMapping(value = "/board/freeBoardContent", method = RequestMethod.GET)
	public String freeBoardContentGet(Model model, HttpSession session, HttpServletRequest request,
			@RequestParam(name="idx",defaultValue = "0", required = false) int idx,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
			) {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "freeBoard", part, searchString);
		FreeBoardVO vo = boardService.getFreeBoardContent(idx);
		if(vo==null) return "redirect:/message/boardContentNo?pathFlag=freeBoard";
		ArrayList<FreeBoardVO> gVos = boardService.getFreeBoardBestList();
		ArrayList<ReplyVO> replyVos = boardService.getBoardReply("freeBoard",idx);
		
		String mid = (String) session.getAttribute("sMid");
		if(mid != null) {
			ArrayList<BoardLikeVO> vos = boardService.getBoardLikeList("freeBoard",mid);
			if(vos.size()!=0) {
				for(int i=0; i<vos.size(); i++) {
					if(vos.get(i).getBoardIdx() == idx) model.addAttribute("likeSw", "act");
				}
			}
		}
		// 게시글 조회수 1씩 증가시키기
		session = request.getSession();
		ArrayList<String> contentReadNum = (ArrayList<String>)session.getAttribute("sContentIdx");
		if(contentReadNum==null) contentReadNum = new ArrayList<String>();
		String imsiContentReadNum = "freeBoard"+idx;
		if(!contentReadNum.contains(imsiContentReadNum)) {
			boardService.setFreeBoardReadNumPlus(idx);
			contentReadNum.add(imsiContentReadNum);
		}
		session.setAttribute("sContentIdx", contentReadNum);
		
		model.addAttribute("vo", vo);
		model.addAttribute("gVos", gVos);
		model.addAttribute("replyVos", replyVos);
		model.addAttribute("pageVO", pageVO);
		return "customer/board/freeBoardContent";
	}
	
	// 게시판 원댓글 달기
	@ResponseBody
	@RequestMapping(value = "/board/replyInput", method = RequestMethod.POST)
	public String replyInputPost(ReplyVO vo) {
		// 1. 부모댓글의 re_step=0, re_order=1(원본글의 첫번째 부모댓글은 re_order=1이고 그 다음 댓글은 마지막 부모댓글보다 +1처리시켜준다)
		ReplyVO parentReplyVO = boardService.getBoardParentReplyCheck(vo.getBoard(),vo.getBoardIdx());
		if(parentReplyVO==null) vo.setRe_order(1);
		else vo.setRe_order(parentReplyVO.getRe_order()+1);
		vo.setRe_step(0);
		int res = boardService.setBoardReplyInput(vo);
		return res+"";
	}
	// 게시판 대댓글 달기
	@ResponseBody
	@RequestMapping(value = "/board/replyInputRe", method = RequestMethod.POST)
	public String replyInputRePost(ReplyVO vo) {
		// 대댓글의 re_step은 부모댓글의 re_step+1
		// re_order는 부모의 re_order보다 큰 댓글은 모두 +1 처리후, 부모댓글에 달린 답글 중 가장 큰 re_order+1
		vo.setRe_step(vo.getRe_step()+1); //1번
		ReplyVO otherReplyVO = boardService.getBoardOtherReplyCheck(vo.getBoard(),vo.getBoardIdx(),vo.getParentId());
		if(otherReplyVO==null) {
			boardService.setReplyOrderUpdate(vo.getBoard(),vo.getBoardIdx(),vo.getRe_order()); // 기존 댓글들 업데이트
			vo.setRe_order(vo.getRe_order()+1);
		}
		else {
			boardService.setReplyOrderUpdate(vo.getBoard(),vo.getBoardIdx(),otherReplyVO.getRe_order()); // 답글 이하 댓글들 업데이트
			vo.setRe_order(otherReplyVO.getRe_order()+1);
		}
		
		int res = boardService.setBoardReplyInput(vo);
		return res+"";
	}
	
	// 게시판 댓글&답글 삭제
	@ResponseBody
	@RequestMapping(value = "/board/replyDelete", method = RequestMethod.POST)
	public String replyDeletePost(String board, int boardIdx, int idx) {
		ReplyVO otherReplyVO = boardService.getBoardOtherReplyCheck(board, boardIdx, idx);
		int res = 0;
		if(otherReplyVO==null) { // 답글이 없으면 그냥 삭제
			res = boardService.setBoardReplyDelete(board,boardIdx,idx);
		}
		else { // 답글이 존재하면 삭제 대신 삭제된 댓글입니다 지정
			ReplyVO vo = boardService.getBoardReplyOne(board, boardIdx, idx);
			vo.setContent("삭제된 댓글입니다.");
			vo.setMid("");
			vo.setNickName("");
			res = boardService.setBoardReplyUpdate(vo);
		}
		return res+"";
	}
	
	// 게시판 댓글&답글 수정
	@ResponseBody
	@RequestMapping(value = "/board/replyUpdate", method = RequestMethod.POST)
	public String replyUpdatePost(ReplyVO vo) {
		int res = boardService.setBoardReplyUpdate(vo);
		return res+"";
	}
	
	// 자유게시판 글 삭제(댓글도 모두 삭제하기)
	@RequestMapping(value = "/board/freeBoardDelete", method = RequestMethod.GET)
	public String freeBoardDeleteGet(
			@RequestParam(name = "idx", defaultValue = "0", required = false) int idx
			) {
		FreeBoardVO vo = boardService.getFreeBoardContent(idx);
		if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgDelete(vo.getContent(), "freeBoard");
		int res = boardService.setFreeBoardDelete(idx);
		if(res != 0) return "redirect:/message/boardDeleteOk?pathFlag=freeBoard";
		else return "redirect:/message/boardDeleteNo?pathFlag=freeBoard&idx="+idx;
	}
	
	// 게시판 추천 누르기(좋아요 목록에 추가)
	@ResponseBody
	@RequestMapping(value = "/board/addBoardLike", method = RequestMethod.POST)
	public String addBoardLikePost(BoardLikeVO vo) {
		int res = boardService.setBoardLikeAdd(vo);
		int res2 = 0;
		if(res != 0) {
			if(vo.getBoard().equals("freeBoard")) res2 = boardService.setFreeBoardGoodUpdate(vo.getBoardIdx());
			else if(vo.getBoard().equals("questionBoard")) res2 = boardService.setQuestionBoardGoodUpdate(vo.getBoardIdx());
			else if(vo.getBoard().equals("recruitBoard")) res2 = boardService.setRecruitBoardGoodUpdate(vo.getBoardIdx());
		}
		return res2+"";
	}
	// 게시판 추천 제거(좋아요 목록에서 빼기) (이번엔 게시판 구별은 서비스에서 작업...)
	@ResponseBody
	@RequestMapping(value = "/board/removeBoardLike", method = RequestMethod.POST)
	public String removeBoardLikePost(BoardLikeVO vo) {
		int res = boardService.setBoardLikeDelete(vo);
		return res+"";
	}
	
	// 게시판 글 신고하기
	@ResponseBody
	@Transactional
	@RequestMapping(value = "/board/boardReport", method = RequestMethod.POST)
	public String boardReportPost(ReportVO vo) {
		int res = boardService.setBoardReportInput(vo);
		if(res != 0) {
			if(vo.getBoard().equals("freeBoard")) boardService.setFreeBoardReportUpdate(vo.getBoardIdx());
			else if(vo.getBoard().equals("questionBoard")) boardService.setQuestionBoardReportUpdate(vo.getBoardIdx());
			else if(vo.getBoard().equals("recruitBoard")) boardService.setRecruitBoardReportUpdate(vo.getBoardIdx());
		}
		return res+"";
	}
	
	// 질문게시판 연결
	@RequestMapping(value = "/board/questionBoardList", method = RequestMethod.GET)
	public String questionBoardListGet(Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
			) {
		//System.out.println("part : "+part);
		//System.out.println("searchString: "+searchString);
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "questionBoard", part, searchString);
		ArrayList<QuestionBoardVO> vos = null;
		vos = boardService.getQuestionBoardList(pageVO.getStartIndexNo(), pageSize, part, searchString);
		if(!part.equals(""))	{
			if(part.equals("title")) part = "제목";
			else if(part.equals("nickName")) part = "작성자";
			else if(part.equals("content")) part = "내용";
			else if(part.equals("part")) part = "분류";
			model.addAttribute("part", part);
			model.addAttribute("searchString", searchString);
			model.addAttribute("searchCount", vos.size());
		}
		ArrayList<QuestionBoardVO> recentVOS = boardService.getRecentReplyQuestionBoard();
		
		//System.out.println("vos : "+vos);
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vos", vos);
		model.addAttribute("recentVOS", recentVOS);
		return "customer/board/questionBoardList";
	}

	// 질문게시판 글 작성창 띄우기
	@RequestMapping(value = "/board/questionBoardInput", method = RequestMethod.GET)
	public String questionBoardInputGet() {
		return "customer/board/questionBoardInput";
	}
	// 질문게시판 글 작성
	@RequestMapping(value = "/board/questionBoardInput", method = RequestMethod.POST)
	public String questionBoardInputPost(QuestionBoardVO vo) {
		if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgCheck(vo.getContent(),"questionBoard");
		vo.setContent(vo.getContent().replace("/data/ckeditor", "/data/questionBoard/"));
		int res = boardService.setQuestionBoardInput(vo);
		if(res != 0) return "redirect:/message/boardInputOk?pathFlag=questionBoard";
		else return "redirect:/message/boardInputNo?pathFlag=questionBoard";
	}
	
	// 질문게시판 내용 보기
	@RequestMapping(value = "/board/questionBoardContent", method = RequestMethod.GET)
	public String questionBoardContentGet(Model model, HttpSession session, HttpServletRequest request,
			@RequestParam(name="idx",defaultValue = "0", required = false) int idx,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
			) {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "questionBoard", part, searchString);
		QuestionBoardVO vo = boardService.getQuestionBoardContent(idx);
		if(vo==null) return "redirect:/message/boardContentNo?pathFlag=questionBoard";
		ArrayList<QuestionBoardVO> recentVOS = boardService.getRecentReplyQuestionBoard();
		ArrayList<ReplyVO> replyVos = boardService.getBoardReply("questionBoard",idx);
		
		String mid = (String) session.getAttribute("sMid");
		if(mid != null) {
			ArrayList<BoardLikeVO> vos = boardService.getBoardLikeList("questionBoard",mid);
			if(vos.size()!=0) {
				for(int i=0; i<vos.size(); i++) {
					if(vos.get(i).getBoardIdx() == idx) model.addAttribute("likeSw", "act");
				}
			}
		}
		// 게시글 조회수 1씩 증가시키기
		session = request.getSession();
		ArrayList<String> contentReadNum = (ArrayList<String>)session.getAttribute("sContentIdx");
		if(contentReadNum==null) contentReadNum = new ArrayList<String>();
		String imsiContentReadNum = "questionBoard"+idx;
		if(!contentReadNum.contains(imsiContentReadNum)) {
			boardService.setQuestionBoardReadNumPlus(idx);
			contentReadNum.add(imsiContentReadNum);
		}
		session.setAttribute("sContentIdx", contentReadNum);
		
		model.addAttribute("vo", vo);
		model.addAttribute("recentVOS", recentVOS);
		model.addAttribute("replyVos", replyVos);
		model.addAttribute("pageVO", pageVO);
		return "customer/board/questionBoardContent";
	}
	
	// 질문 게시판 글 삭제 (댓글 있을 경우 삭제 불가능)
	@RequestMapping(value = "/board/questionBoardDelete", method = RequestMethod.GET)
	public String fquestionBoardDeleteGet(
			@RequestParam(name = "idx", defaultValue = "0", required = false) int idx
			) {
		int res = 0;
		ReplyVO rVo = boardService.getBoardParentReplyCheck("questionBoard", idx);
		if(rVo != null) res = 0;
		else {
			QuestionBoardVO vo = boardService.getQuestionBoardContent(idx);
			if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgDelete(vo.getContent(), "questionBoard");
			res = boardService.setQuestionBoardDelete(idx);
		}
		if(res != 0) return "redirect:/message/boardDeleteOk?pathFlag=questionBoard";
		else return "redirect:/message/boardDeleteNo?pathFlag=questionBoard&idx="+idx;
	}
	
	// 질문 게시판 글 수정창 띄우기
	@RequestMapping(value = "/board/questionBoardEdit", method = RequestMethod.GET)
	public String questionBoardEditGet(Model model,
			@RequestParam(name="idx",defaultValue = "0", required = false) int idx,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name="search",defaultValue = "10", required = false) String search,
			@RequestParam(name="searchString",defaultValue = "10", required = false) String searchString
		) {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "questionBoard", search, searchString);
		QuestionBoardVO vo = boardService.getQuestionBoardContent(idx);
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vo", vo);
		return "customer/board/questionBoardEdit";
	}
	
	// 질문 게시판 글 수정하기
	@RequestMapping(value = "/board/questionBoardEdit", method = RequestMethod.POST)
	public String questionBoardEditPost(QuestionBoardVO vo) {
		QuestionBoardVO originVO = boardService.getQuestionBoardContent(vo.getIdx());
		if(!originVO.getContent().equals(vo.getContent())) {
			if(originVO.getContent().indexOf("src=\"/")!= -1) boardService.imgDelete(originVO.getContent(),"questionBoard");
			vo.setContent(vo.getContent().replace("/data/questionBoard/", "/data/ckeditor/"));
			if(vo.getContent().indexOf("src=\"/")!= -1) boardService.imgCheck(vo.getContent(),"questionBoard");
			vo.setContent(vo.getContent().replace("/data/ckeditor/", "/data/questionBoard/"));
		}
		int res = boardService.setQuestionBoardEdit(vo);
		if(res != 0) return "redirect:/message/boardEditOk?pathFlag=questionBoard";
		else return "redirect:/message/boardEditNo?pathFlag=questionBoard&idx="+vo.getIdx();
	}
	
	// 채용공고 게시판 연결
	@RequestMapping(value = "/board/recruitBoardList", method = RequestMethod.GET)
	public String recruitBoardListGet(Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
			) {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "recruitBoard", part, searchString);
		ArrayList<RecruitBoardVO> vos = null;
		vos = boardService.getRecruitBoardList(pageVO.getStartIndexNo(), pageSize, part, searchString);
		if(!part.equals(""))	{
			if(part.equals("title")) part = "제목";
			else if(part.equals("nickName")) part = "작성자";
			else if(part.equals("content")) part = "내용";
			else if(part.equals("part")) part = "분류";
			model.addAttribute("part", part);
			model.addAttribute("searchString", searchString);
			model.addAttribute("searchCount", vos.size());
		}
		ArrayList<RecruitBoardVO> rcVos = boardService.getRecruitPartCount();
		LocalDate today = LocalDate.now();
		model.addAttribute("today", today);
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vos", vos);
		model.addAttribute("rcVos", rcVos);
		return "customer/board/recruitBoardList";
	}
	
	// 채용공고 게시판 글쓰기 창 연결
	@RequestMapping(value = "/board/recruitBoardInput", method = RequestMethod.GET)
	public String recruitBoardInputGet() {
		return "customer/board/recruitBoardInput";
	}
	
	// 채용공고 게시판 글쓰기 (파일 업로드)
	@RequestMapping(value = "/board/recruitBoardInput", method = RequestMethod.POST)
	public String recruitBoardInputPost(MultipartHttpServletRequest mFile, RecruitBoardVO vo) {
		int res = boardService.setRecruitBoardInput(mFile,vo);
		if(res != 0) return "redirect:/message/boardInputOk?pathFlag=recruitBoard";
		else return "redirect:/message/boardInputNo?pathFlag=recruitBoard";
	}
	
	// 채용공고 게시판 내용 보기
	@RequestMapping(value = "/board/recruitBoardContent", method = RequestMethod.GET)
	public String recruitBoardContentGet(Model model, HttpSession session, HttpServletRequest request,
			@RequestParam(name = "idx", defaultValue = "0", required = false) int idx,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString,
			@RequestParam(name = "end", defaultValue = "", required = false) String end
			) {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "recruitBoard", part, searchString);
		RecruitBoardVO vo = boardService.getRecruitBoardContent(idx);
		if(vo==null) return "redirect:/message/boardContentNo?pathFlag=recruitBoard";
		ArrayList<RecruitBoardVO> rcVos = boardService.getRecruitPartCount();
		ArrayList<ReplyVO> replyVos = boardService.getBoardReply("recruitBoard",idx);
		
		String mid = (String) session.getAttribute("sMid");
		if(mid != null) {
			ArrayList<BoardLikeVO> vos = boardService.getBoardLikeList("recruitBoard",mid);
			if(vos.size()!=0) {
				for(int i=0; i<vos.size(); i++) {
					if(vos.get(i).getBoardIdx() == idx) model.addAttribute("likeSw", "act");
				}
			}
		}
		// 게시글 조회수 1씩 증가시키기
		session = request.getSession();
		ArrayList<String> contentReadNum = (ArrayList<String>)session.getAttribute("sContentIdx");
		if(contentReadNum==null) contentReadNum = new ArrayList<String>();
		String imsiContentReadNum = "recruitBoard"+idx;
		if(!contentReadNum.contains(imsiContentReadNum)) {
			boardService.setRecruitBoardReadNumPlus(idx);
			contentReadNum.add(imsiContentReadNum);
		}
		session.setAttribute("sContentIdx", contentReadNum);
		
		model.addAttribute("end", end);
		model.addAttribute("vo", vo);
		model.addAttribute("rcVos", rcVos);
		model.addAttribute("replyVos", replyVos);
		model.addAttribute("pageVO", pageVO);
		return "customer/board/recruitBoardContent";
	}
	
	// 채용공고 게시판 글 삭제(댓글도 모두 삭제하기)
	@ResponseBody
	@RequestMapping(value = "/board/recruitBoardDelete", method = RequestMethod.POST)
	public String recruitBoardDeletePost(
			@RequestParam(name = "idx", defaultValue = "0", required = false) int idx,
			@RequestParam(name = "rcfSName", defaultValue = "", required = false) String rcfSName
			) {
		int res = boardService.setRecruitBoardDelete(idx,rcfSName);
		return res + "";
	}
	
	// 채용공고 게시판 글 수정창 띄우기
	@RequestMapping(value = "/board/recruitBoardEdit", method = RequestMethod.GET)
	public String recruitBoardEditGet(Model model,
			@RequestParam(name="idx",defaultValue = "0", required = false) int idx,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name="search",defaultValue = "10", required = false) String search,
			@RequestParam(name="searchString",defaultValue = "10", required = false) String searchString
		) {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "recruitBoard", search, searchString);
		RecruitBoardVO vo = boardService.getRecruitBoardContent(idx);
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vo", vo);
		return "customer/board/recruitBoardEdit";
	}
	
	// 채용공고 게시판 글 수정하기
	@RequestMapping(value = "/board/recruitBoardEdit", method = RequestMethod.POST)
	public String recruitBoardEditPost(MultipartHttpServletRequest mFile, RecruitBoardVO vo) {
		int res = boardService.setRecruitBoardEdit(mFile,vo);
		if(res != 0) return "redirect:/message/boardEditOk?pathFlag=recruitBoard";
		else return "redirect:/message/boardEditNo?pathFlag=recruitBoard&idx="+vo.getIdx();
	}
	
	// A/S 완료 후 결제 창 열기
	@RequestMapping(value = "/requests/paymentWindow", method = RequestMethod.GET)
	public String paymentWindowGet(int idx, Model model) {
		AsChargeVO chargeVO = customerService.getAsChargeContent(idx);
		model.addAttribute("chargeVO", chargeVO);
		return "customer/requests/paymentWindow";
	}
	
	// 결제하기 누르면 asCharge 상태 변경하기(이후 관리자가 확인 버튼 누르면 asRequest 상태 변경...)
	@ResponseBody
	@RequestMapping(value = "/requests/makePayment", method = RequestMethod.POST)
	public String makePaymentGet(
			@RequestParam(name = "asIdx", defaultValue = "0", required = false) int asIdx
			) {
		int res = customerService.setAsChargePaymentOk(asIdx);
		return res+"";
	}
	
	// PDF 생성하기
	@RequestMapping(value = "/requests/printChargeHistory", method = RequestMethod.GET)
	public ResponseEntity<ByteArrayResource> printChargeHistoryGet(int idx, HttpServletRequest request) throws IOException {
		String realPath = request.getSession().getServletContext().getRealPath("/resources/");
		AsChargeVO chargeVO = customerService.getAsChargeContent(idx);
		
		PDDocument document = new PDDocument();
		PDPage page = new PDPage(PDRectangle.A4);
		document.addPage(page);
		
    // 유니코드 폰트 사용
    File fontFile = new File(realPath+"fonts/NanumGothic-Bold.ttf");
    PDType0Font font = PDType0Font.load(document, fontFile);
		
		PDPageContentStream contentStream = new PDPageContentStream(document, page);
		contentStream.beginText();
		contentStream.setFont(font, 14);
		contentStream.newLineAtOffset(50, 750);
		contentStream.showText("수리 명세서");
		contentStream.newLineAtOffset(0, -20);
		contentStream.showText("====================================================");
		contentStream.newLineAtOffset(0, -50);
		if(chargeVO.getExpendableName() != null && chargeVO.getExpendableName() != "") {
			String[] expendables = chargeVO.getExpendableName().split(",");
			String[] quantities = chargeVO.getQuantity().split(",");
			// 테이블 헤더 추가
			contentStream.showText("소모품");
			contentStream.newLineAtOffset(300, 0);
			contentStream.showText("수량");
			contentStream.newLineAtOffset(-300, -20);
			contentStream.showText("====================================================");
			contentStream.newLineAtOffset(0, -20);
			
			// 테이블 데이터 추가
			for (int i = 0; i < expendables.length; i++) {
				contentStream.showText(expendables[i]);
				contentStream.newLineAtOffset(300, 0);
				contentStream.showText(quantities[i]);
				contentStream.newLineAtOffset(-300, -30);
			}
			contentStream.showText("소모품 총액: ");
			contentStream.newLineAtOffset(300, 0);
			contentStream.showText(chargeVO.getPrice() + " 원");
			contentStream.newLineAtOffset(-300, -30);
			contentStream.showText("====================================================");
			contentStream.newLineAtOffset(0, -50);
		}

    // 추가 정보
    contentStream.showText("출장비: ");
    contentStream.newLineAtOffset(300, 0);
    contentStream.showText(chargeVO.getLaborCharge() + " 원");
    contentStream.newLineAtOffset(-300, -20);
    contentStream.showText("vat: ");
    contentStream.newLineAtOffset(300, 0);
    contentStream.showText((chargeVO.getTotPrice()/11) + " 원");
    contentStream.newLineAtOffset(-300, -20);
    contentStream.showText("총액(V.A.T.포함): ");
    contentStream.newLineAtOffset(300, 0);
    contentStream.showText(chargeVO.getTotPrice() + " 원");
    contentStream.newLineAtOffset(-300, -20);

    contentStream.endText();
    contentStream.close();

    // PDF를 ByteArrayOutputStream에 저장
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    document.save(baos);
    document.close();

    // ByteArrayResource로 변환
    byte[] bytes = baos.toByteArray();
    ByteArrayResource resource = new ByteArrayResource(bytes);

    // HTTP 응답 설정
    return ResponseEntity.ok()
            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=as_charge_history.pdf")
            .contentType(MediaType.APPLICATION_PDF)
            .contentLength(bytes.length)
            .body(resource);
	}
	
	
	
}
