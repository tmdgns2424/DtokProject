package com.psnm.dtok.com.baseval.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FWEBBASVAL001</li>
 * <li>설  명 : 기본값관리 FU</li>
 * <li>작성일 : 2014-12-22 11:09:43</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class FWEBBASVAL001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FWEBBASVAL001(){
		super();
	}

	/**
	 * 기본값관리 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-22 11:11:27
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchWebBasVal(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DWEBBASVAL001 du = (DWEBBASVAL001) lookupDataUnit(DWEBBASVAL001.class);
	    	
			responseData = du.dSearchWebBasVal(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 기본값관리 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-22 11:26:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertWebBasVal(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DWEBBASVAL001 du = (DWEBBASVAL001) lookupDataUnit(DWEBBASVAL001.class);
			
			du.dInsertWebBasVal(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 기본값관리 정보를 수정하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-22 11:27:06
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateWebBasVal(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DWEBBASVAL001 du = (DWEBBASVAL001) lookupDataUnit(DWEBBASVAL001.class);
			
			du.dUpdateWebBasVal(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}  
	
	    return responseData;
	}

	/**
	 * 기본값관리 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-22 11:33:33
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteWebBasVal(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	IRecordSet rs =  requestData.getRecordSet("grid");
			
	    	DWEBBASVAL001 du = (DWEBBASVAL001) lookupDataUnit(DWEBBASVAL001.class);
	    	
	    	for(int i = 0 ; i < rs.getRecordCount() ; i++){
				IDataSet listData = new DataSet();
	    		listData.putFieldMap(rs.getRecordMap(i));
	    		
	    		if("D".equals(listData.getField("FLAG"))){
	    			du.dDeleteWebBasVal(listData, onlineCtx);
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
	 * 팝업이미지관리정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-22 15:08:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchWebBasValPic(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DWEBBASVAL001 du = (DWEBBASVAL001) lookupDataUnit(DWEBBASVAL001.class);
	    	
			responseData = du.dSearchWebBasValPic(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}
  
}
