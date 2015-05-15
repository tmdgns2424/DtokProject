package com.psnm.dtok.biz.prfisue.biz;

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
 * <li>단위업무명: 증명서발급</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-02-25 10:38:37</li>
 * <li>작성자 : 안진갑 (ahnjingap)</li>
 * </ul>
 *
 * @author 안진갑 (ahnjingap)
 */
public class FPRFISUEMGMT001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FPRFISUEMGMT001(){
		super();
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-26 10:36:45
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSavePrfIsue(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    IDataSet parameterData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DPRFISUEMGMT001 du = (DPRFISUEMGMT001)lookupDataUnit(DPRFISUEMGMT001.class);
	    
	    IRecordSet rs = requestData.getRecordSet("gridPrfIsue");
	    
	    if( rs == null){
	    	return responseData;
	    }
	    
	    for( int index=0; index<rs.getRecordCount(); ++index){
	    	parameterData.initField();
	    	parameterData.putFieldMap( rs.getRecordMap(index) );
	    	if( parameterData.getField("FLAG").equals("D") ){
	    		if( StringUtils.isNotEmpty(parameterData.getField("PRF_MGMT_NUM")) ){
	    			responseData = du.dDeletePrfIsue(parameterData, onlineCtx);
	    		}
	    	}else if( StringUtils.isEmpty(parameterData.getField("PRF_MGMT_NUM")) ){
		    	responseData = du.dInsertPrfIsue(parameterData, onlineCtx);
		    }else{
		    	responseData = du.dUpdatePrfIsue(parameterData, onlineCtx);
		    }
	    }
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-26 13:53:23
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchPrfIsue(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DPRFISUEMGMT001 du = (DPRFISUEMGMT001)lookupDataUnit(DPRFISUEMGMT001.class);
	    responseData = du.dSearchPrfIsue(requestData, onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-27 09:48:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSavePrfIsueStCd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    IDataSet parameterData = new DataSet();
	    
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DPRFISUEMGMT001 du = (DPRFISUEMGMT001)lookupDataUnit(DPRFISUEMGMT001.class);
	    
	    IRecordSet rs = requestData.getRecordSet("gridPrfIsue");
	    
	    if( rs == null){
	    	return responseData;
	    }
	    
	    for( int index=0; index<rs.getRecordCount(); ++index){
	    	parameterData.initField();
	    	parameterData.putFieldMap( rs.getRecordMap(index) );
	    	if( parameterData.getField("FLAG").equals("02") ){ //발급의뢰
	    		parameterData.putField("PRF_ISUE_ST_CD", "02");
	    		if( StringUtils.isEmpty(parameterData.getField("PRF_MGMT_NUM")) ){
	    			responseData = du.dInsertPrfIsue(parameterData, onlineCtx);
	    			parameterData.putField("PRF_MGMT_NUM", responseData.getField("PRF_MGMT_NUM"));
	    			responseData = du.dUpdatePrfIsue(parameterData, onlineCtx);
	    		}else{
	    			responseData = du.dUpdatePrfIsue(parameterData, onlineCtx);
	    		}
	    	}else if( parameterData.getField("FLAG").equals("03") ){ //의뢰취소
	    		parameterData.putField("PRF_ISUE_ST_CD", "03");
		    	responseData = du.dUpdatePrfIsue(parameterData, onlineCtx);
		    }else if( parameterData.getField("FLAG").equals("04") ){ //발급승인
		    	parameterData.putField("PRF_ISUE_ST_CD", "04");
		    	responseData = du.dUpdatePrfIsue(parameterData, onlineCtx);
		    }else if( parameterData.getField("FLAG").equals("05") ){ //반려
		    	parameterData.putField("PRF_ISUE_ST_CD", "05");
		    	responseData = du.dUpdatePrfIsue(parameterData, onlineCtx);
		    }else if( parameterData.getField("FLAG").equals("06") ){ //발급완료
		    	parameterData.putField("PRF_ISUE_ST_CD", "06");
		    	responseData = du.dUpdatePrfIsue(parameterData, onlineCtx);
		    }
	    }
	    return responseData;
	}
  
}
