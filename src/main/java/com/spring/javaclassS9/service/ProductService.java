package com.spring.javaclassS9.service;

import java.util.ArrayList;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS9.vo.AsRequestVO.Machine;
import com.spring.javaclassS9.vo.ProductSaleVO.Statement;
import com.spring.javaclassS9.vo.ExpendableVO;
import com.spring.javaclassS9.vo.ProductEstimateVO;
import com.spring.javaclassS9.vo.ProductLikeVO;
import com.spring.javaclassS9.vo.ProductSaleVO;
import com.spring.javaclassS9.vo.ProductVO;

public interface ProductService {

	public int setProductInputOk(MultipartFile fName, ProductVO vo);

	public ArrayList<ProductVO> getAllProductList(int startIndexNo, int pageSize);

	public ProductVO getProductContent(int idx);

	public int setProductAddLike(int idx, String mid);

	public int setProductRemoveLike(int idx, String mid);

	public ArrayList<ProductLikeVO> getProductLikeList(String mid);

	public int setProductSaleCustomerInput(ProductSaleVO vo);

	public int setProductContentEdit(MultipartFile fName, ProductVO vo);

	public ArrayList<ProductSaleVO> getAllProductSaleList(int startIndexNo, int pageSize);

	public ArrayList<ProductSaleVO> getSearchProductEstimateList(int startIndexNo, int pageSize, String part,
			String searchString);

	public ProductSaleVO getProductSaleContent(int idx);

	public ArrayList<ExpendableVO> getExpendableList();

	public ExpendableVO getExpendableCode(ExpendableVO vo);

	public int setExpendableInput(ExpendableVO vo);

	public int setExpendableDelete(ExpendableVO vo);

	public ArrayList<ExpendableVO> getExpendableListOne(Machine machine);

	public ExpendableVO getExpendableNameCheck(String expendableName);

	public int setProductEstimateInput(ProductEstimateVO vo);

	public void setProductSaleStatementChange(int saleIdx, String statement);

	public ProductEstimateVO getProductEstimateContent(int saleIdx);

	public int setProductEstimateCancel(int idx);

	public int setProductEstimateOrder(int idx);

	public void setProductEstimateChange(int idx, String statement);

	public int setProductSaleChange(int saleIdx, String statement);

	public void setProductEstimatePayDate(int idx);

}
