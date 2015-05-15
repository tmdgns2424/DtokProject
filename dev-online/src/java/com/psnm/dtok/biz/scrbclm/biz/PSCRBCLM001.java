package com.psnm.dtok.biz.scrbclm.biz;

import java.util.Map;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.IResultMessage;
import nexcore.framework.core.data.ResultMessage;
import nexcore.framework.core.exception.BizRuntimeException;
import nexcore.framework.core.util.StringUtils;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: [PU]비정상영업소명 관리</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-02-16 09:45:08</li>
 * <li>작성자 : 안진갑 (ahnjingap)</li>
 * </ul>
 *
 * @author 안진갑 (ahnjingap)
 */
public class PSCRBCLM001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PSCRBCLM001(){
		super();
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 09:45:08
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchScrbClm(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FSCRBCLM001 fu = (FSCRBCLM001)lookupFunctionUnit(FSCRBCLM001.class);
	    	responseData = fu.fSearchScrbClm(requestData, onlineCtx);
			responseData.setOkResultMessage("PSNM-I000", null);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}

	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 09:45:08
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveScrbClm(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FSCRBCLM001 fu = (FSCRBCLM001)lookupFunctionUnit(FSCRBCLM001.class);
	    	if( StringUtils.isEmpty(requestData.getField("RCV_MGMT_NUM"))){
		        responseData = fu.fInsertScrbClm(requestData, onlineCtx);	
	    	}else{
	    		responseData = fu.fUpdateScrbClm(requestData, onlineCtx);
	    	}

			responseData.setOkResultMessage("PSNM-I000", null);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 13:34:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchScrbClmDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FSCRBCLM001 fu = (FSCRBCLM001)lookupFunctionUnit(FSCRBCLM001.class);
	    	responseData = fu.fSearchScrbClmDtl(requestData, onlineCtx);	
			responseData.setOkResultMessage("PSNM-I000", null);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 09:45:08
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteScrbClm(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FSCRBCLM001 fu = (FSCRBCLM001)lookupFunctionUnit(FSCRBCLM001.class);
	    	responseData = fu.fDeleteScrbClm(requestData, onlineCtx);	
			responseData.setOkResultMessage("PSNM-I000", null);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 15:36:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveScrbClmOp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FSCRBCLM001 fu = (FSCRBCLM001)lookupFunctionUnit(FSCRBCLM001.class);
	    	if( StringUtils.isEmpty(requestData.getField("OP_SEQ"))){
		        responseData = fu.fInsertScrbClmOp(requestData, onlineCtx);	
	    	}else{
	    		responseData = fu.fUpdateScrbClmOp(requestData, onlineCtx);
	    	}

			responseData.setOkResultMessage("PSNM-I000", null);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 09:45:08
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchScrbClmOpDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FSCRBCLM001 fu = (FSCRBCLM001)lookupFunctionUnit(FSCRBCLM001.class);
		    responseData = fu.fSearchScrbClmOpDtl(requestData, onlineCtx);	
			responseData.setOkResultMessage("PSNM-I000", null);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 17:07:43
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteScrbClmOp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FSCRBCLM001 fu = (FSCRBCLM001)lookupFunctionUnit(FSCRBCLM001.class);
		    responseData = fu.fDeleteScrbClmOp(requestData, onlineCtx);	
			responseData.setOkResultMessage("PSNM-I000", null);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-17 09:58:37
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pFnshOrRevokScrbClm(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FSCRBCLM001 fu = (FSCRBCLM001)lookupFunctionUnit(FSCRBCLM001.class);
	    	if( requestData.getField("DIV").equals("fnsh") ){ //최종완료
	    		responseData = fu.fFnshScrbClm(requestData, onlineCtx);
	    	}else if( requestData.getField("DIV").equals("rvk") ){ //완료취소
	    		responseData = fu.fRevokScrbClm(requestData, onlineCtx);
	    	}
			responseData.setOkResultMessage("PSNM-I000", null);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 09:45:08
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchScrbClmPrst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FSCRBCLM001 fu = (FSCRBCLM001)lookupFunctionUnit(FSCRBCLM001.class);
	    	responseData = fu.fSearchScrbClmPrst(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-04-23 16:55:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchIsMa(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FSCRBCLM001 fu = (FSCRBCLM001)lookupFunctionUnit(FSCRBCLM001.class);
	    	responseData = fu.fSearchIsMa(requestData, onlineCtx);

			responseData.setOkResultMessage("PSNM-I000", null);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	    return responseData;
	}
  
}
