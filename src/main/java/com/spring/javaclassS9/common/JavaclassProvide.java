package com.spring.javaclassS9.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

@Service
public class JavaclassProvide {
	@Autowired
	JavaMailSender mailSender;
	
	
	public String mailSend(String toMail, String title, String imsiContent, String mailFlag, HttpServletRequest request) throws MessagingException {
		String content = "";
		
		MimeMessage message = mailSender.createMimeMessage();
		MimeMessageHelper messageHelper = new MimeMessageHelper(message, true,  "UTF-8");
		
		messageHelper.setTo(toMail);
		messageHelper.setSubject(title);
		messageHelper.setText(content);
		
		if(mailFlag.equals("pwdSearch")) {
			content += "<br><hr><h3>임시 비밀번호 발급</h3><hr><br>";
			content += imsiContent+"<br>";
			content += "<div>로그인 후 비밀번호를 변경해주세요.</div><br><hr><br>";
		}
		else if(mailFlag.equals("adminSendEmail")) {
			content += "<h3>그린 엔지니어링에서 전해드립니다.</h3><br>";
			content += imsiContent+"<br><br><hr><br>";
		}
		else if(mailFlag.equals("consultingAnswer")) {
			content += "<h3>답변 내용 : </h3><br>";
			content += imsiContent+"<br><br><hr><br>";
			content += "마이페이지 문의 내역에서도 답변을 확인할 수 있습니다. <br>";
		}
		
		content += "<p><img src='cid:emaillogo.png'></p>";
		content += "<p>사이트 방문하기 : <a href='http://localhost:9090/javaclassS9/main'>javaclass</a>";
		// content += "<hr>";
		content = content.replace("\n", "<br>");
		messageHelper.setText(content, true);
		
		FileSystemResource file = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images/emaillogo.png"));
		messageHelper.addInline("emaillogo.png", file);
		
		mailSender.send(message);
		
		return "1";
	}
	
	// 파일 이름 변경하기(중복방지)
	public String saveFileName(String oFileName) {
		String fileName = "";
		
		Calendar cal = Calendar.getInstance(); // 싱글톤 객체랑 같은 형식(객체 생성 x)
		fileName += cal.get(Calendar.YEAR);
		fileName += cal.get(Calendar.MONTH)+1;
		fileName += cal.get(Calendar.DATE);
		fileName += cal.get(Calendar.HOUR_OF_DAY);
		fileName += cal.get(Calendar.MINUTE);
		fileName += cal.get(Calendar.SECOND);
		fileName += "_" + oFileName;
		
		return fileName;
	}
	
	// 파일 업로드
	public void writeFile(MultipartFile fName, String sFileName, String urlPath) throws IOException {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/"+urlPath+"/");
		FileOutputStream fos = new FileOutputStream(realPath+sFileName);
		if(fName.getBytes().length != -1) {
			fos.write(fName.getBytes());
		}
		fos.flush();
		fos.close();
	}
	
	// 파일 삭제
	public void deleteFile(String photo, String urlPath) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/"+urlPath+"/");
		
		File file = new File(realPath+photo);
		if(file.exists()) file.delete();
	}
	
	// 파일 복사처리
	public void fileCopyCheck(String origFilePath, String copyFilePath) {
		try {
			FileInputStream fis = new FileInputStream(new File(origFilePath));
			FileOutputStream fos = new FileOutputStream(new File(copyFilePath));
			
			byte[] b = new byte[2048];
			int cnt = 0;
			while((cnt = fis.read(b)) != -1) {
				fos.write(b,0,cnt);
			}
			fos.flush();
			fos.close();
			fis.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	// 랜덤 이름 생성
	public String newNameCreate(int len) {
		Date today = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmm");
		String newName = sdf.format(today);
		newName += "_"+ RandomStringUtils.randomAlphanumeric(len);
		return newName;
	}
	
	// 탈퇴 회원 랜덤 아이디 생성
	public String randomMidCreate(String str) {
		String randomMid = str+"_"+ RandomStringUtils.randomNumeric(4);
		return randomMid;
	}
	
}
