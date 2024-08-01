package com.spring.javaclassS9.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS9.common.JavaclassProvide;
import com.spring.javaclassS9.dao.ProductDAO;
import com.spring.javaclassS9.vo.AsRequestVO.Machine;
import com.spring.javaclassS9.vo.ExpendableVO;
import com.spring.javaclassS9.vo.OrderAddressVO;
import com.spring.javaclassS9.vo.ProductEstimateVO;
import com.spring.javaclassS9.vo.ProductLikeVO;
import com.spring.javaclassS9.vo.ProductSaleVO;
import com.spring.javaclassS9.vo.ProductSaleVO.Statement;
import com.spring.javaclassS9.vo.ProductVO;

@Service
public class ProductServiceImpl implements ProductService {
	
	@Autowired
	ProductDAO productDAO;
	
	@Autowired
	JavaclassProvide javaclassProvide;

	@Override
	public int setProductInputOk(MultipartFile fName, ProductVO vo) {
		int res = 0;
		String oFileName = fName.getOriginalFilename();
		String sFileName = "";
		if(fName != null && oFileName != "") {
			try {
				/*
				System.out.println("1. oFileName: "+oFileName);
				oFileName = URLEncoder.encode(oFileName,"UTF-8").replaceAll("\\+", "%20");
				System.out.println("2. 인코딩 oFileName: "+oFileName);
				if(oFileName.length() > 20) {
					String ext = oFileName.substring(oFileName.lastIndexOf("."));
					System.out.println("확장자 : "+ext);
					System.out.println("3. 서버들어가는 oFileName: "+oFileName);
					oFileName = oFileName.substring(0,10)+ext;
				}
				*/
				sFileName = javaclassProvide.saveFileName(oFileName);
				javaclassProvide.writeFile(fName, sFileName, "product");
				res = 1;
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if(res != 0) vo.setProPhoto(sFileName);
		else vo.setProPhoto("noimage2.png");
		return productDAO.setProductInputOk(vo);
	}

	@Override
	public ArrayList<ProductVO> getAllProductList(int startIndexNo, int pageSize) {
		return productDAO.getAllProductList(startIndexNo,pageSize);
	}

	@Override
	public ProductVO getProductContent(int idx) {
		return productDAO.getProductContent(idx);
	}

	@Override
	public int setProductAddLike(int idx, String mid) {
		return productDAO.setProductAddLike(idx, mid);
	}

	@Override
	public int setProductRemoveLike(int idx, String mid) {
		return productDAO.setProductRemoveLike(idx, mid);
	}

	// 장비 관심 등록 한 적 있는지 확인
	@Override
	public ArrayList<ProductLikeVO> getProductLikeList(String mid) {
		return productDAO.getProductLikeList(mid);
	}

	@Override
	public int setProductSaleCustomerInput(ProductSaleVO vo) {
		vo.setStatement(Statement.QUOTE);
		return productDAO.setProductSaleCustomerInput(vo);
	}

	// 장비 수정(사진 변경에 좀더 세련된 방법이 없을까??)
	@Transactional
	@Override
	public int setProductContentEdit(MultipartFile fName, ProductVO vo) {
		int res = 0;
		String oFileName = fName.getOriginalFilename();
		String sFileName = "";
		if(oFileName != "" && !oFileName.equals(vo.getOriginPhoto())) {
			sFileName = javaclassProvide.saveFileName(oFileName);
			try {
				javaclassProvide.deleteFile(vo.getOriginPhoto(), "product");
				javaclassProvide.writeFile(fName, sFileName, "product");
				res = 1;
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if(res != 0) vo.setProPhoto(sFileName);
		else vo.setProPhoto(vo.getOriginPhoto());
		
		return productDAO.setProductContentEdit(vo);
	}

	@Override
	public ArrayList<ProductSaleVO> getAllProductSaleList(int startIndexNo, int pageSize) {
		return productDAO.getAllProductSaleList(startIndexNo,pageSize);
	}

	@Override
	public ArrayList<ProductSaleVO> getSearchProductEstimateList(int startIndexNo, int pageSize, String part,
			String searchString) {
		return productDAO.getSearchProductEstimateList(startIndexNo,pageSize,part,searchString);
	}

	@Override
	public ProductSaleVO getProductSaleContent(int idx) {
		return productDAO.getProductSaleContent(idx);
	}

	@Override
	public ArrayList<ExpendableVO> getExpendableList() {
		return productDAO.getExpendableList();
	}

	@Override
	public ExpendableVO getExpendableCode(ExpendableVO vo) {
		return productDAO.getExpendableCode(vo);
	}

	@Override
	public int setExpendableInput(ExpendableVO vo) {
		int maxIdx = 1;
		ExpendableVO maxVO = productDAO.getExpendableMaxIdx();
		if(maxVO != null) maxIdx = maxVO.getIdx() + 1;
		vo.setIdx(maxIdx);
		return productDAO.setExpendableInput(vo);
	}

	@Override
	public int setExpendableDelete(ExpendableVO vo) {
		return productDAO.setExpendableDelete(vo);
	}

	@Override
	public ArrayList<ExpendableVO> getExpendableListOne(Machine machine) {
		return productDAO.getExpendableListOne(machine);
	}

	@Override
	public ExpendableVO getExpendableNameCheck(String expendableName) {
		return productDAO.getExpendableNameCheck(expendableName);
	}

	@Override
	public int setProductEstimateInput(ProductEstimateVO vo) {
		vo.setStatement(Statement.CHECK);
		return productDAO.setProductEstimateInput(vo);
	}

	@Override
	public void setProductSaleStatementChange(int saleIdx, String statement) {
		ProductSaleVO vo = productDAO.getProductSaleContent(saleIdx);
		if(statement.equals("check"))vo.setStatement(Statement.CHECK);
		else if(statement.equals("order"))vo.setStatement(Statement.ORDERING);
		else if(statement.equals("cancel"))vo.setStatement(Statement.CANCEL);
		productDAO.setProductSaleStatementChange(vo);
	}

	@Override
	public ProductEstimateVO getProductEstimateContent(int saleIdx) {
		return productDAO.getProductEstimateContent(saleIdx);
	}

	@Override
	public int setProductEstimateCancel(int idx) {
		return productDAO.setProductEstimateCancel(idx);
	}

	@Override
	public int setProductEstimateOrder(int idx) {
		return productDAO.setProductEstimateOrder(idx);
	}

	@Override
	public void setProductEstimateChange(int idx, String statement) {
		productDAO.setProductEstimateChange(idx, statement);
	}

	@Override
	public int setProductSaleChange(int saleIdx, String statement) {
		return productDAO.setProductSaleChange(saleIdx, statement);
	}

	@Override
	public void setProductEstimatePayDate(int idx) {
		productDAO.setProductEstimatePayDate(idx);
	}

	@Override
	public int setEstimateAddAddress(OrderAddressVO vo) {
		return productDAO.setEstimateAddAddress(vo);
	}

	@Override
	public OrderAddressVO getOrderAddress(int saleIdx) {
		return productDAO.getOrderAddress(saleIdx);
	}

	@Override
	public int setEstimateAddressUpdate(OrderAddressVO vo) {
		return productDAO.setEstimateAddressUpdate(vo);
	}

	
}
