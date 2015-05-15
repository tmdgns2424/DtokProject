package com.psnm.dtok.com.baseval.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;
import nexcore.framework.core.util.StringUtils;

import com.psnm.common.util.PsnmStringUtil;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PWEBBASVAL001</li>
 * <li>설  명 : 기본값관리 PU</li>
 * <li>작성일 : 2014-12-22 11:09:20</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PWEBBASVAL001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PWEBBASVAL001(){
		super();
	}

	/**
	 * 기본값관리 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-22 11:10:54
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchWebBasVal(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
		try {
			FWEBBASVAL001 fu = (FWEBBASVAL001) lookupFunctionUnit(FWEBBASVAL001.class);
		
			responseData = fu.fSearchWebBasVal(requestData, onlineCtx);
			
			IRecordSet rs = responseData.getRecordSet("ds");
			
			responseData.putRecordSet("grid", rs);
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 기본값관리 정보를 등록,수정 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-22 11:24:14
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveWebBasVal(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FWEBBASVAL001 fu = (FWEBBASVAL001) lookupFunctionUnit(FWEBBASVAL001.class);
	    	
	    	IRecordSet rs =  requestData.getRecordSet("grid");
	    	
	    	if(rs.getRecordCount()!= 0) {
	    		for(int i = 0 ; i < rs.getRecordCount() ; i++){
	    			IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs.getRecordMap(i));
		    		
		    		if( PsnmStringUtil.isEmpty(listData.getField("DSM_WEB_STRD_CD_VAL")) ) {
						fu.fInsertWebBasVal(listData, onlineCtx);
					} else {
						fu.fUpdateWebBasVal(listData, onlineCtx);
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
	 * 기본값관리 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-22 11:33:11
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteWebBasVal(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FWEBBASVAL001 fu = (FWEBBASVAL001) lookupFunctionUnit(FWEBBASVAL001.class);
	    	
	    	fu.fDeleteWebBasVal(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 팝업이미지정보를 수정하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-22 16:11:09
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pUpdateWebBasValImg(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FWEBBASVAL001 fu = (FWEBBASVAL001) lookupFunctionUnit(FWEBBASVAL001.class);
	    	
	    	//팝업이미지 변경
			requestData.putField("DSM_WEB_STRD_CD_VAL", "99");
			requestData.putField("MGMT_TYP_CD", "99");
			requestData.putField("STRD_APLY_VAL", requestData.getField("ATCH_FILE_ID"));
	    	fu.fUpdateWebBasVal(requestData, onlineCtx);
	    	
	    	//사진첨부
			if( StringUtils.isNotEmpty(requestData.getField("FILE_NM")) ){ //파일이름이 있는것만 사진파일이 변경된것으로 본다.
				requestData.putField("FILE_GRP_ID", "PIC");
				callSharedBizComponentByDirect("com.SHARE", "fSavePictuerFile", requestData, onlineCtx);
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
	 * @since 2015-01-22 15:08:31
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchWebBasValPic(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
		try {
			FWEBBASVAL001 fu = (FWEBBASVAL001) lookupFunctionUnit(FWEBBASVAL001.class);
		
			responseData = fu.fSearchWebBasValPic(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}
  
}
