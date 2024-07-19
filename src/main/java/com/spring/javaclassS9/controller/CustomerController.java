package com.spring.javaclassS9.controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.javaclassS9.pagination.PageProcess;
import com.spring.javaclassS9.service.BoardService;
import com.spring.javaclassS9.service.CustomerService;
import com.spring.javaclassS9.service.EngineerService;
import com.spring.javaclassS9.vo.AsRequestVO;
import com.spring.javaclassS9.vo.BoardLikeVO;
import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.FreeBoardVO;
import com.spring.javaclassS9.vo.NewsVO;
import com.spring.javaclassS9.vo.PageVO;
import com.spring.javaclassS9.vo.ProductLikeVO;
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
		if(vo.getContent().indexOf("src=\"/") != -1) boardService.imgCheck(vo.getContent());
		vo.setContent(vo.getContent().replace("/data/ckeditor", "/data/board/"));
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
			if(originVO.getContent().indexOf("src=\"/")!= -1) boardService.imgDelete(originVO.getContent());
			vo.setContent(vo.getContent().replace("/data/board/", "data/ckeditor"));
			if(vo.getContent().indexOf("src=\"/")!= -1) boardService.imgCheck(vo.getContent());
			vo.setContent(vo.getContent().replace("/data/ckeditor/", "/data/board/"));
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
	
	// 게시판 글 삭제(댓글도 모두 삭제하기)
	@RequestMapping(value = "/board/freeBoardDelete", method = RequestMethod.GET)
	public String freeBoardDeleteGet(
			@RequestParam(name = "idx", defaultValue = "0", required = false) int idx
			) {
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
		}
		return res+"";
	}
	
	
	
}
