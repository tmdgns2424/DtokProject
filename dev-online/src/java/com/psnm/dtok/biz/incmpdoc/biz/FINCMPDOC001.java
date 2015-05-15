package com.psnm.dtok.biz.incmpdoc.biz;

import java.util.Map;

import com.psnm.common.util.PsnmStringUtil;
import org.apache.commons.logging.Log;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.IResultMessage;
import nexcore.framework.core.data.ResultMessage;
import nexcore.framework.core.exception.BizRuntimeException;
import nexcore.framework.core.util.BaseUtils;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: FINCMPDOC001</li>
 * <li>설  명 : 미비서류접수 관련 업무 Function Unit</li>
 * <li>작성일 : 2015-01-22 14:09:00</li>
 * <li>작성자 : 김지홍 (kimjihong)</li>
 * </ul>
 *
 * @author 김지홍 (kimjihong)
 */
public class FINCMPDOC001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FINCMPDOC001(){
		super();
	}

	/**
	 * 미비서류접수 정보를 조회하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-22 14:09:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchIncmpDoc(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DINCMPDOC001 du = (DINCMPDOC001) lookupDataUnit(DINCMPDOC001.class);	    	
			
	    	requestData.putField("NEW_PRD", BaseUtils.getConfiguration("brd.new.prd")); 
	    	String DUTY_USER_TYP = onlineCtx.getUserInfo().get("DUTY_USER_TYP").toString();
	    	String DUTY 		 = onlineCtx.getUserInfo().get("DUTY").toString();
			
			//관리자나 도급직이 아니라면 해당 작성자글만 조회한다.
			//MA나 팀장 국장 as_is : if( dutyTypCd.startsWith("4") || dutyCd.equals("14") ) {
		    if( DUTY_USER_TYP.startsWith("4") || DUTY.equals("14") ){
		    	requestData.putField("MA_USER_ID", onlineCtx.getUserInfo().get("loginId").toString());
			} 
		  
			responseData = du.dSearchIncmpDoc(requestData, onlineCtx);
						
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 미비서류접수 정보를 추가하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-22 14:09:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSaveIncmpDoc(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	   
	    try {	    	
	    	DINCMPDOC001 du1 = (DINCMPDOC001) lookupDataUnit(DINCMPDOC001.class);
	    	DINCMPDOCTYPHST001 du2 = (DINCMPDOCTYPHST001) lookupDataUnit(DINCMPDOCTYPHST001.class);
	    	
	    	//1-1. 신규 저장
	    	if( PsnmStringUtil.isEmpty(requestData.getField("DSM_INCMP_DOC_ID")) ) {				
	    		//신규 시퀀스 조회 (KEY_NAME은 SQL에서 INC로 코딩...)	    	
		    	requestData.putField("DSM_INCMP_DOC_ID", du1.dSearchIncmpDocIdSeq(requestData, onlineCtx).getField("DSM_INCMP_DOC_ID"));
		    	responseData =  du1.dInsertIncmpDoc(requestData, onlineCtx);
			//1-2. 정보 수정
	    	} else {
				responseData = du1.dUpdateIncmpDoc(requestData, onlineCtx);
				//첨부유형 일단 삭제.
				du2.dDeleteIncmpDocTypHst(requestData, onlineCtx);
			}	    		    	
			
			IDataSet inputData = new DataSet();
			inputData.putField("DSM_INCMP_DOC_ID", requestData.getField("DSM_INCMP_DOC_ID"));
		
			//2. 첨부유형 저장			
			String type;
			for( int i = 1; i <= 5; i++) {
				type = requestData.getField("DOC_TYP_CD" + i);				
				if( type == null || "".equals(type) ) {
					continue;
				}
				inputData.removeField("DOC_TYP_CD" );
				inputData.putField("DOC_TYP_CD", type);
				
				du2.dInsertIncmpDocTypHst(inputData, onlineCtx);				
			}
			
			//3. 첨부파일 저장
			//파일첨부id셋팅
			requestData.putField("DSM_CONT_ID", requestData.getField("DSM_INCMP_DOC_ID") );
			if(requestData.getRecordSet("gridfile") != null){
				//첨부파일 정보를 저장(등록 | 삭제) : 공유컴포넌트 호출
				callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
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
	 * 미비서류접수 정보 상세조회 FM
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-23 14:27:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailIncmpDoc(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
	    try {	    	
	    	DINCMPDOC001 du = (DINCMPDOC001) lookupDataUnit(DINCMPDOC001.class);	    				
			responseData = du.dDetailIncmpDoc(requestData, onlineCtx);
			if(!PsnmStringUtil.isEmpty(requestData.getField("DSM_INCMP_DOC_ID"))){	    		
	    		//첨부파일 조회
				requestData.putField("ATCH_MGMT_ID", requestData.getField("DSM_INCMP_DOC_ID"));
	    		IDataSet fileDataset = callSharedBizComponentByDirect("com.SHARE", "fSearchFileMapping", requestData, onlineCtx);
	    		responseData.putRecordSet("gridfile", fileDataset.getRecordSet("ds"));			  
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
	 * 미비서류접수처리결과저장 FM
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-28 15:28:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSaveIncmpDocResult(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {	    	
	    	DINCMPDOC001 du = (DINCMPDOC001) lookupDataUnit(DINCMPDOC001.class);	    				
			responseData = du.dSaveIncmpDocResult(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
  
}
