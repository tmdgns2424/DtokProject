package com.psnm.dtok.com.userinfo.biz;

import java.util.Map;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.IResultMessage;
import nexcore.framework.core.data.ResultMessage;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PUSERSCRBREQ001</li>
 * <li>설  명 : 회원정보관리 PU</li>
 * <li>작성일 : 2014-12-03 18:01:20</li>
 * <li>작성자 : 한상곤 (hansanggon)</li>
 * </ul>
 *
 * @author 한상곤 (hansanggon)
 */
public class PUSERSCRBREQ001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PUSERSCRBREQ001(){
		super();
	}

	/**
	 * 에이전트 조회[팝업] PM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-12-03 18:03:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAgnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    try {
	    	FUSERSCRBREQ001 fu = (FUSERSCRBREQ001)lookupFunctionUnit(FUSERSCRBREQ001.class);
	    	responseData = fu.fSearchAgnt(requestData, onlineCtx);
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
	 * @since 2014-12-03 18:01:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchUserScrbReq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FUSERSCRBREQ001 fu = (FUSERSCRBREQ001)lookupFunctionUnit(FUSERSCRBREQ001.class);
	    	responseData = fu.fSearchUserScrbReq(requestData, onlineCtx);
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
	 * @since 2014-12-19 13:54:08
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchUserScrbReqDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FUSERSCRBREQ001 fu = (FUSERSCRBREQ001)lookupFunctionUnit(FUSERSCRBREQ001.class);
	    	responseData = fu.fSearchUserScrbReqDtl(requestData, onlineCtx);
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
	 * @since 2014-12-03 18:01:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pApprUserScrbReq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FUSERSCRBREQ001 fu = (FUSERSCRBREQ001)lookupFunctionUnit(FUSERSCRBREQ001.class);
	    	
	    	String div = requestData.getField("SCRB_ST_CD");
	    	if( div.equals("02") ){  //승인
	    		responseData = fu.fApprUserScrbReq(requestData, onlineCtx);
	    	}else if( div.equals("03") ){ //반려
	    		responseData = fu.fRetrunUserScrbReq(requestData, onlineCtx);
	    	}
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	    
		responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;	
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-01 10:51:03
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchNickNmChk(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FUSERSCRBREQ001 fu = (FUSERSCRBREQ001)lookupFunctionUnit(FUSERSCRBREQ001.class);
	    	responseData = fu.fSearchNickNmChk(requestData, onlineCtx);
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
	 * @since 2014-12-03 18:01:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchFaxNumChk(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FUSERSCRBREQ001 fu = (FUSERSCRBREQ001)lookupFunctionUnit(FUSERSCRBREQ001.class);
	    	responseData = fu.fSearchFaxNumChk(requestData, onlineCtx);
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
	 * @since 2015-01-01 15:32:58
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAddr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FUSERSCRBREQ001 fu = (FUSERSCRBREQ001)lookupFunctionUnit(FUSERSCRBREQ001.class);
	    	responseData = fu.fSearchAddr(requestData, onlineCtx);
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
	 * @since 2014-12-03 18:01:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pInsertUserScrbReq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FUSERSCRBREQ001 fu = (FUSERSCRBREQ001)lookupFunctionUnit(FUSERSCRBREQ001.class);

	    	responseData = fu.fInsertUserScrbReq(requestData, onlineCtx);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	    
		responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:01:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchEmailChk(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FUSERSCRBREQ001 fu = (FUSERSCRBREQ001)lookupFunctionUnit(FUSERSCRBREQ001.class);
	    	responseData = fu.fSearchEmailChk(requestData, onlineCtx);
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
	 * @since 2015-02-16 10:20:09
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSmember(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    try {
	    	FUSERSCRBREQ001 fu = (FUSERSCRBREQ001)lookupFunctionUnit(FUSERSCRBREQ001.class);
	    	responseData = fu.fSearchSmember(requestData, onlineCtx);
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
	 * @since 2014-12-03 18:01:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveChangedFaxNo(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    try {
	    	FUSERSCRBREQ001 fu = (FUSERSCRBREQ001)lookupFunctionUnit(FUSERSCRBREQ001.class);
	    	responseData = fu.fSaveChangedFaxNo(requestData, onlineCtx);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	    return responseData;
	}
}
