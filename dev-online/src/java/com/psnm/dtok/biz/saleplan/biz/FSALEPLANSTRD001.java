package com.psnm.dtok.biz.saleplan.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: FSALEPLANSTRD001</li>
 * <li>설  명 : 영업계획기준관리 FU</li>
 * <li>작성일 : 2015-01-29 10:38:52</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class FSALEPLANSTRD001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FSALEPLANSTRD001(){
		super();
	}

	/**
	 * 영업계획기준관리상품유형 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-29 14:52:05
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSalePlanStrdProd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DSALEPLANSTRD001 du = (DSALEPLANSTRD001) lookupDataUnit(DSALEPLANSTRD001.class);
	    	
			responseData = du.dSearchSalePlanStrdProd(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 영업계획기준관리상품유형 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-29 14:52:33
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertSalePlanStrdProd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DSALEPLANSTRD001 du = (DSALEPLANSTRD001) lookupDataUnit(DSALEPLANSTRD001.class);
			
	    	IRecordSet rs =  requestData.getRecordSet("gridprod");
			if(rs != null && rs.getRecordCount()!=0) {
				for(int i = 0 ; i < rs.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs.getRecordMap(i));
		    		
		    		if("D".equals(listData.getField("FLAG"))){
		    			du.dDeleteSalePlanStrdProd(listData, onlineCtx);
		    		}else{
		    			du.dInsertSalePlanStrdProd(listData, onlineCtx);
		    		}
				}
			}

			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 영업계획기준관리기준제목 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-29 14:53:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSalePlanStrdCtt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DSALEPLANSTRD001 du = (DSALEPLANSTRD001) lookupDataUnit(DSALEPLANSTRD001.class);
	    	
			responseData = du.dSearchSalePlanStrdCtt(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 영업계획기준관리기준제목 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-29 14:54:18
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertSalePlanStrdCtt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DSALEPLANSTRD001 du = (DSALEPLANSTRD001) lookupDataUnit(DSALEPLANSTRD001.class);
	    	
	    	IRecordSet rs =  requestData.getRecordSet("gridctt");
			if(rs != null && rs.getRecordCount()!=0) {
				for(int i = 0 ; i < rs.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs.getRecordMap(i));
		    		
		    		if("D".equals(listData.getField("FLAG"))){
		    			du.dDeleteSalePlanStrdCtt(listData, onlineCtx);
		    		}else{
		    			du.dInsertSalePlanStrdCtt(listData, onlineCtx);
		    		}
				}
			}
	    	
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 영업계획기준관리정보를 복사하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-09 14:12:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fCopySalePlanStrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DSALEPLANSTRD001 du = (DSALEPLANSTRD001) lookupDataUnit(DSALEPLANSTRD001.class);
	    	
	    	IRecordSet rs =  requestData.getRecordSet("gridprod");
			if(rs != null && rs.getRecordCount()!=0) {
				for(int i = 0 ; i < rs.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs.getRecordMap(i));
		    		
		    		listData.putField("SALES_YM", requestData.getField("COPY_YM"));
		    		du.dInsertSalePlanStrdProd(listData, onlineCtx);
				}
			}
			
			IRecordSet rs2 =  requestData.getRecordSet("gridctt");
			if(rs2 != null && rs2.getRecordCount()!=0) {
				for(int i = 0 ; i < rs2.getRecordCount() ; i++){
					IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs2.getRecordMap(i));
		    		
		    		listData.putField("SALES_YM", requestData.getField("COPY_YM"));
		    		du.dInsertSalePlanStrdCtt(listData, onlineCtx);
				}
			}
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}
  
}
