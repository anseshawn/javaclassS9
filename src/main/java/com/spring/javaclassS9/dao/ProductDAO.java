package com.spring.javaclassS9.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS9.vo.ProductLikeVO;
import com.spring.javaclassS9.vo.ProductSaleVO;
import com.spring.javaclassS9.vo.ProductVO;

public interface ProductDAO {

	public int setProductInputOk(@Param("vo") ProductVO vo);

	public int totRecCnt();

	public ArrayList<ProductVO> getAllProductList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public ProductVO getProductContent(@Param("idx") int idx);

	public int setProductAddLike(@Param("idx") int idx, @Param("mid") String mid);

	public int setProductRemoveLike(@Param("idx") int idx, @Param("mid") String mid);

	public ArrayList<ProductLikeVO> getProductLikeList(@Param("mid") String mid);

	public int setProductSaleCustomerInput(@Param("vo") ProductSaleVO vo);

	public int setProductContentEdit(@Param("vo") ProductVO vo);

	public ArrayList<ProductSaleVO> getAllProductEstimateList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public int estimateTotRecCntSearch(@Param("search") String search, @Param("searchString") String searchString);

	public int estimateTotRecCnt();

	public ArrayList<ProductSaleVO> getSearchProductEstimateList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("search") String part,
			@Param("searchString") String searchString);

	public ProductSaleVO getProductSaleContent(@Param("idx") int idx);

}
