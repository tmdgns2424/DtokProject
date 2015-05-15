package com.psnm.dtok.biz.headchrgr.biz;

import com.psnm.common.util.PsnmStringUtil;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: PCHRGRHEADQ001</li>
 * <li>설  명 : 영업국별담당자관리 PU</li>
 * <li>작성일 : 2014-12-30 16:05:10</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class PCHRGRHEADQ001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PCHRGRHEADQ001(){
		super();
	}

	/**
	 * 영업국별담당자관리영업국 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-30 16:05:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchChrgrHeadq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FCHRGRHEADQ001 fu = (FCHRGRHEADQ001) lookupFunctionUnit(FCHRGRHEADQ001.class);
		
			IRecordSet rs = fu.fSearchChrgrHeadq(requestData, onlineCtx).getRecordSet("ds");
			IRecordSet rs2 = fu.fSearchChrgrHeadqUser(requestData, onlineCtx).getRecordSet("ds");
			
			responseData.putRecordSet("grid1", rs);
			responseData.putRecordSet("grid2", rs2);
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 영업국별담당자관리담당자 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-31 16:44:19
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchChrgrHeadqUser(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FCHRGRHEADQ001 fu = (FCHRGRHEADQ001) lookupFunctionUnit(FCHRGRHEADQ001.class);
		
			
			IRecordSet rs = fu.fSearchChrgrHeadqUser(requestData, onlineCtx).getRecordSet("ds");
			
			responseData.putRecordSet("grid2", rs);
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 영업국별담당자관리회원정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-05 09:56:28
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchChrgrHeadqApprove(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FCHRGRHEADQ001 fu = (FCHRGRHEADQ001) lookupFunctionUnit(FCHRGRHEADQ001.class);
		
			
			IRecordSet rs = fu.fSearchChrgrHeadqApprove(requestData, onlineCtx).getRecordSet("ds");
			
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
	 * 영업국별 담당자관리 정보를 등록,수정,삭제 하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-05 10:58:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveChrgrHeadq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	FCHRGRHEADQ001 fu = (FCHRGRHEADQ001) lookupFunctionUnit(FCHRGRHEADQ001.class);
	    	
	    	IRecordSet rs =  requestData.getRecordSet("grid2");
		
	    	for(int i = 0 ; i < rs.getRecordCount() ; i++){
				
				IDataSet listData = new DataSet();
	    		listData.putFieldMap(rs.getRecordMap(i));
	    		
	    		String FLAG = listData.getField("FLAG");
	    		
	    		listData.putField("CHRGR_ID", listData.getField("USER_ID").toString());
	    		listData.putField("DSM_HEADQ_CD", requestData.getField("DSM_HEADQ_CD").toString());
	    		
	    		if( !PsnmStringUtil.isEmpty(FLAG) ) {
	    			if("I".equals(FLAG)){ //영업국별담당자등록
		    			fu.fInsertChrgrHeadq(listData, onlineCtx);
		    		}else if("U".equals(FLAG)){ //영업국별담당자 수정
		    			fu.fUpdateChrgrHeadq(listData, onlineCtx);
		    		}else if("D".equals(FLAG)){ //영업국별담당자 삭제
		    			fu.fDeleteChrgrHeadq(listData, onlineCtx);
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
  
}
