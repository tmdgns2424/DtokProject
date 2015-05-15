package com.psnm.dtok.agn.agntmgmt.biz;

import org.apache.commons.logging.Log;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.user.IUserInfo;
import nexcore.framework.core.exception.BizRuntimeException;
import nexcore.framework.core.util.StringUtils;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/에이전트</li>
 * <li>단위업무명: PAGENTCNTRT001</li>
 * <li>설  명 : 에이전트 계약관리 PU</li>
 * <li>작성일 : 2014-11-26 09:56:44</li>
 * <li>작성자 : 한상곤 (hansanggon)</li>
 * </ul>
 *
 * @author 한상곤 (hansanggon)
 */
public class PAGENTCNTRT001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PAGENTCNTRT001(){
		super();
	}

	/**
	 * 에이전트정보 조회 PM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 09:56:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAgentInfo(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try{			
	    	
	    	FAGENTCNTRT001 fu = (FAGENTCNTRT001)lookupFunctionUnit(FAGENTCNTRT001.class);
	    
	    	responseData = fu.fSearchAgentInfo(requestData, onlineCtx);
	    	    	
	    	responseData.getRecordSet("grid").setPageNo(requestData.getIntField("page"));
	    	responseData.getRecordSet("grid").setRecordCountPerPage(requestData.getIntField("page_size"));
	    	responseData.getRecordSet("grid").setTotalRecordCount(responseData.getIntField("count"));
	    	
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 조회 PM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 09:56:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAgentCntrt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try{

	    	FAGENTCNTRT001 fu = (FAGENTCNTRT001)lookupFunctionUnit(FAGENTCNTRT001.class);
	    	
	    	requestData.putField("S_DUTY_TYP_CD", onlineCtx.getUserInfo().get("DUTY").toString());
	    	requestData.putField("S_DEPT_CD"	, onlineCtx.getUserInfo().get("SALE_DEPT_ORG_ID").toString());
	    	requestData.putField("S_ORG_CD"	    , onlineCtx.getUserInfo().get("HDQT_PART_ORG_ID").toString());
	    	
	    	responseData = fu.fSearchAgentCntrt(requestData, onlineCtx);
	    	    	
	    	responseData.getRecordSet("grid").setPageNo(requestData.getIntField("page"));
	    	responseData.getRecordSet("grid").setRecordCountPerPage(requestData.getIntField("page_size"));
	    	responseData.getRecordSet("grid").setTotalRecordCount(responseData.getIntField("count"));
	    	
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 상태수정 PM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 09:56:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pUpdateAgentCntrt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    Log log = getLog(onlineCtx);

	    IUserInfo iUserInfo = onlineCtx.getUserInfo();
	    requestData.putField("USER_ID", iUserInfo.getLoginId());
	    
	    try{

	    	FAGENTCNTRT001 fu = (FAGENTCNTRT001)lookupFunctionUnit(FAGENTCNTRT001.class);
	    	FAGENTINTHST001 fu3 = (FAGENTINTHST001)lookupFunctionUnit(FAGENTINTHST001.class);
	    	
	    	//접수(2),승인(3),반려(4), 관리국 or 관리팀수정
	    	if( "12".equals( requestData.getField("CNTRT_ST_FLAG")) || "23".equals( requestData.getField("CNTRT_ST_FLAG")) || 
	    		"24".equals( requestData.getField("CNTRT_ST_FLAG")) || "99".equals( requestData.getField("CNTRT_ST_FLAG")) ) {
	    		
	    		//사진 등록
	    		if( "Y".equals(requestData.getField("PIC_CHG_YN")) && StringUtils.isNotEmpty(requestData.getField("FILE_NM")) ) {	
		    		requestData.putField("PIC_FILE_ID", requestData.getField("ATCH_FILE_ID"));    		
					callSharedBizComponentByDirect("com.SHARE", "fSavePictuerFile", requestData, onlineCtx);
		    	}
		    	
	    		responseData = fu.fUpdateAgentCntrt(requestData, onlineCtx);
	    		
	    		//승인버튼은 클릭할 경우, 면접승인완료(3)
	    		if( "23".equals( requestData.getField("CNTRT_ST_FLAG")) ){
	    			//SMS전송 : SMS관리에서 지정된 메시지 구분이 면접승인완료의 임직원
	    			requestData.putField("SMS_CHK", "5");
	    			IDataSet requestSms = fu.fSelectAgentCntrtSmsSend(requestData, onlineCtx);	    			
	    			requestSms.putField("TRAN_MENU_ID", "1303");
	    			requestSms.putField("TRAN_TYP_CD", "43");
	    			requestSms.putField("TRAN_SYS", "BO");
					callSharedBizComponentByDirect("com.SHARE", "fSendSms", requestSms, onlineCtx);
	    		}
	    	}	    	
	    	//접수취소("")
	    	else if( "21".equals( requestData.getField("CNTRT_ST_FLAG")) ) {
	    		
	    		//1.SMS전송 : 지원자,
	    		requestData.putField("SMS_CHK", "2");
	    		IDataSet requestSms1 = fu.fSelectAgentCntrtSmsSend(requestData, onlineCtx);
	    		requestSms1.putField("TRAN_MENU_ID", "0000");
				requestSms1.putField("TRAN_TYP_CD", "03");
				requestSms1.putField("TRAN_SYS", "BO");
	    		callSharedBizComponentByDirect("com.SHARE", "fSendSms", requestSms1, onlineCtx);
	    		
	    		//2. 국장 : 지정영업국 존재시 발송
	    		if( StringUtils.isNotEmpty( requestData.getField("SALE_DEPT_ORG_ID") ) ){    			
	    		
		    		requestData.putField("SMS_CHK", "3");
		    		IDataSet requestSms2 = fu.fSelectAgentCntrtSmsSend(requestData, onlineCtx);
		    		requestSms2.putField("TRAN_MENU_ID", "0000");
					requestSms2.putField("TRAN_TYP_CD", "03");
					requestSms2.putField("TRAN_SYS", "BO");
		    		callSharedBizComponentByDirect("com.SHARE", "fSendSms", requestSms2, onlineCtx);
	    		}

	    		//에이전트계약정보 삭제(DSM_AGENT_CNTRT)
	    		fu.fDeleteAgentCntrt(requestData, onlineCtx);	    		

	    		//학력삭제	    		
	    		FAGENTSCHSHIPHST001 fu1 = (FAGENTSCHSHIPHST001)lookupFunctionUnit(FAGENTSCHSHIPHST001.class);
	    		fu1.fDeleteAgentSchshipHst(requestData, onlineCtx);
	    		
	    		//경력삭제
	    		FAGENTCAREERHST001 fu2 = (FAGENTCAREERHST001)lookupFunctionUnit(FAGENTCAREERHST001.class);
	    		fu2.fDeleteAgentCareerHst(requestData, onlineCtx);
	    		
	    		//면접결과 삭제	    		
	    		fu3.fDeleteAgentIntHst(requestData, onlineCtx);
	    		
	    		//첨부파일 테이블에 매핑된 ID 삭제
	    		try {
					callSharedBizComponentByDirect("com.SHARE", "fDeleteFileByFileId", requestData, onlineCtx);
				}
	    		catch (Exception e) {
					// (원인) 컨텐츠ID 없음! : log처리만 남겨둠.
	    			log.info("<첨부파일매핑삭제> (원인) 컨텐츠ID 없음! ");
				}
	    	}
	    	//승인취소(2), 반려취소(2)
	    	else if( "32".equals( requestData.getField("CNTRT_ST_FLAG")) || "42".equals( requestData.getField("CNTRT_ST_FLAG")) ) {
	    		
	    		//상태변경 및 지정부서 NULL 값으로 UPDATE
	    		fu.fUpdateAgentCntrtAppCan(requestData, onlineCtx);
	    		
	    		//면접결과 삭제
	    		fu3.fDeleteAgentIntHst(requestData, onlineCtx);
	    	}
	    	//저장클릭시(승인상태(3)에서 저장) : 에이전트매핑저장
	    	else if( "33".equals( requestData.getField("CNTRT_ST_FLAG")) ) {
	    		
	    		//담보현황건수취득(거래처여신정보건수)TBAS_DEAL_CO_CRD_MGMT
	    		int dealCoCdCnt = fu.fSelectAgentCntrtDealCnt(requestData, onlineCtx).getIntField("TOTCNT");
	    		
	    		if( dealCoCdCnt > 0) {
	    			
	    			//상태변경처리 : 조직도에 등록완료되고 담보등록 완료된 상태면 코드발급완료(5) 상태로 변경
	    			responseData = fu.fUpdateAgentCntrtAgentMap(requestData, onlineCtx);
	    			
	    			//sms전송:코드발급완료 상태 전환 시 지원자에게 SMS 자동 발송
	    			requestData.putField("SMS_CHK", "2");
	    			IDataSet requestSms = fu.fSelectAgentCntrtSmsSend(requestData, onlineCtx);	    			
	    			requestSms.putField("TRAN_MENU_ID", "0000");
	    			requestSms.putField("TRAN_TYP_CD", "05");
	    			requestSms.putField("TRAN_SYS", "BO");
					callSharedBizComponentByDirect("com.SHARE", "fSendSms", requestSms, onlineCtx);

	    		}
	    		else {
	    			//담보미등록
	    			throw new BizRuntimeException("PSNM-E999", new String[]{"등록된 담보가 없습니다."});
	    		}
	    		
	    	}
	    	//저장클릭시(접수(2),면접완료(21)상태에서 저장) : 면접결과 삭제
	    	else if( "34".equals( requestData.getField("CNTRT_ST_FLAG")) ) {
	    		
	    		//선택된 면접결과 삭제   	
				IRecordSet rs1 =  requestData.getRecordSet("gridIntHst");
				if(rs1 != null && rs1.getRecordCount() != 0) {
			    	
					for(int i = 0 ; i < rs1.getRecordCount() ; i++) {
			    		IDataSet listData = new DataSet();
			    		listData.putFieldMap(rs1.getRecordMap(i));
			    		
			    		if("D".equals( listData.getField("FLAG") )){
			    			
			    			listData.putField("CNTRT_MGMT_NUM", requestData.getField("CNTRT_MGMT_NUM"));
				    		listData.putField("HST_SEQ", listData.getField("HST_SEQ"));
				    		
			    			responseData = fu3.fDeleteAgentIntHst(listData, onlineCtx);
			    		}			    		
			    	}
				}
				
				//면접 횟수에 따라 처리 상태를 변경
				fu3.fUpdateAgentIntHst(requestData, onlineCtx);				
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
	 * 에이전트계약정보 상세조회 PM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-26 09:56:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailAgentCntrt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    try{

	    	FAGENTCNTRT001 fu1 = (FAGENTCNTRT001)lookupFunctionUnit(FAGENTCNTRT001.class);
	    	FAGENTSCHSHIPHST001 fu2 = (FAGENTSCHSHIPHST001)lookupFunctionUnit(FAGENTSCHSHIPHST001.class);
	    	FAGENTCAREERHST001 fu3 = (FAGENTCAREERHST001)lookupFunctionUnit(FAGENTCAREERHST001.class);
	    	FAGENTINTHST001 fu4 = (FAGENTINTHST001)lookupFunctionUnit(FAGENTINTHST001.class);
	    
	    	//에이전트계약정보
	    	responseData = fu1.fDetailAgentCntrt(requestData, onlineCtx);
	    	
	    	//학력사항
	    	responseData.putRecordSet("gridSchship", fu2.fSearchAgentSchshipHst(requestData, onlineCtx).getRecordSet("ds"));
	    	
	    	//경력사항
	    	responseData.putRecordSet("gridCareer", fu3.fSearchAgentCareerHst(requestData, onlineCtx).getRecordSet("ds"));
	    	
	    	//면접사항
	    	//requestData.putField("CNTRT_MGMT_NUM", "1000004286");	//TEST	    	
	    	responseData.putRecordSet("gridIntHst", fu4.fSearchAgentIntHst(requestData, onlineCtx).getRecordSet("ds"));
	    	
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	
	    return responseData;
	}

	/**
	 * 에이전트계약정보 저장 PM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2014-11-26 09:56:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pInsertAgentCntrt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try{
	    	FAGENTCNTRT001 fu1 = (FAGENTCNTRT001)lookupFunctionUnit(FAGENTCNTRT001.class);	//계약정보	    	
	    	
	    	//시퀀스번호 취득
	    	//int cntrtMgmtNum = fu.fSelectAgentCntrtNoSeq(requestData, onlineCtx).getIntField("DSM_CNTRT_MGMT_NUM");
	    	requestData.putField("CNTRT_MGMT_NUM", fu1.fSelectAgentCntrtNoSeq(requestData, onlineCtx).getField("CNTRT_MGMT_NUM"));
	    	
	    	//USER_ID
	    	requestData.putField("USER_ID", "SYS");
	    	
	    	//우편번호 변환
	    	if( StringUtils.isNotEmpty(requestData.getField("POST_NUM1")) && StringUtils.isNotEmpty(requestData.getField("POST_NUM2")) ) {
	    		requestData.putField("POST_NUM", requestData.getField("POST_NUM1") + "-" + requestData.getField("POST_NUM2"));
	    	}
	    	
	    	//사진 등록
	    	if( StringUtils.isNotEmpty(requestData.getField("FILE_NM")) ) {
	    		
	    		requestData.putField("PIC_FILE_ID", requestData.getField("ATCH_FILE_ID"));    		
				callSharedBizComponentByDirect("com.SHARE", "fSavePictuerFile", requestData, onlineCtx);
	    	}
	
	    	//메인 등록
	    	responseData = fu1.fInsertAgentCntrt(requestData, onlineCtx);
	    	
	    	//학력 등록
			IRecordSet rs1 =  requestData.getRecordSet("gridSchship");
			if(rs1 != null && rs1.getRecordCount() != 0) {
				
				FAGENTSCHSHIPHST001 fu2 = (FAGENTSCHSHIPHST001)lookupFunctionUnit(FAGENTSCHSHIPHST001.class);
				
		    	for(int i = 0 ; i < rs1.getRecordCount() ; i++){
		    		IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs1.getRecordMap(i));
		    		
		    		listData.putField("CNTRT_MGMT_NUM", requestData.getField("CNTRT_MGMT_NUM"));
		    		listData.putField("HST_SEQ", i+1);
		    		listData.putField("USER_ID", requestData.getField("USER_ID"));
		    		//insert 시에는 "-" 제거 필요
		    		listData.putField("APLY_STA_DT", listData.getField("APLY_STA_DT").replaceAll("-", ""));
		    		listData.putField("APLY_END_DT", listData.getField("APLY_END_DT").replaceAll("-", ""));
		    		
		    		responseData = fu2.fInsertAgentSchshipHst(listData, onlineCtx);
		    	}
			}
    	
	    	//경력 등록	    	
	    	IRecordSet rs2 =  requestData.getRecordSet("gridCareer");	    	
	    	if(rs2 != null && rs2.getRecordCount() != 0) {
	    		
	    		FAGENTCAREERHST001 fu3 = (FAGENTCAREERHST001)lookupFunctionUnit(FAGENTCAREERHST001.class);
	    		
	    		for(int i = 0 ; i < rs2.getRecordCount() ; i++){
		    		IDataSet listData = new DataSet();
		    		listData.putFieldMap(rs2.getRecordMap(i));
		    		
		    		listData.putField("CNTRT_MGMT_NUM", requestData.getField("CNTRT_MGMT_NUM"));
		    		listData.putField("HST_SEQ", i+1);
		    		listData.putField("USER_ID", requestData.getField("USER_ID"));
		    		//insert 시에는 "-" 제거 필요
		    		listData.putField("APLY_STA_DT", listData.getField("APLY_STA_DT").replaceAll("-", ""));
		    		listData.putField("APLY_END_DT", listData.getField("APLY_END_DT").replaceAll("-", ""));
		    		
		    		responseData = fu3.fInsertAgentCareerHst(listData, onlineCtx);
		    	}
	    	}

	    	//SMS전송:신규 에이전트계약시(요청:1) : 지원자발송
	    	requestData.putField("SMS_CHK", "1");
	    	IDataSet requestSms1 = fu1.fSelectAgentCntrtSmsSend(requestData, onlineCtx);	    	
			requestSms1.putField("TRAN_MENU_ID", "0000");
			requestSms1.putField("TRAN_TYP_CD", "02");
			requestSms1.putField("TRAN_SYS", "BO");
			callSharedBizComponentByDirect("com.SHARE", "fSendSms", requestSms1, onlineCtx);
			
			//SMS전송:신규 에이전트계약시(요청:1) : 국장발송, 지정영업국 존재시 발송
			if( StringUtils.isNotEmpty( requestData.getField("SALE_DEPT_ORG_ID") ) ){			
			
		    	requestData.putField("SMS_CHK", "4");
		    	IDataSet requestSms2 = fu1.fSelectAgentCntrtSmsSend(requestData, onlineCtx);	    	
				requestSms2.putField("TRAN_MENU_ID", "0000");
				requestSms2.putField("TRAN_TYP_CD", "06");
				requestSms2.putField("TRAN_SYS", "BO");
				callSharedBizComponentByDirect("com.SHARE", "fSendSms", requestSms2, onlineCtx);
			
			}
	    	
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	
	    responseData.setOkResultMessage("MSTAE00010", null);
	    return responseData;
	}

	/**
	 * 에이전트계약면접현황 조회
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2014-11-26 09:56:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAgentCntrtInt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try{

	    	FAGENTCNTRT001 fu = (FAGENTCNTRT001)lookupFunctionUnit(FAGENTCNTRT001.class);
	    
	    	responseData = fu.fSearchAgentCntrtInt(requestData, onlineCtx);
	    	
	    	responseData.getRecordSet("grid").setPageNo(requestData.getIntField("page"));
	    	responseData.getRecordSet("grid").setRecordCountPerPage(requestData.getIntField("page_size"));
	    	responseData.getRecordSet("grid").setTotalRecordCount(responseData.getIntField("count"));
	    	
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	
	    return responseData;
	}

	/**
	 * 에이전트면접정보 상세조회 PM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2014-11-26 09:56:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailAgentIntHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try{

	    	FAGENTINTHST001 fu = (FAGENTINTHST001)lookupFunctionUnit(FAGENTINTHST001.class);
	    
	    	responseData = fu.fDetailAgentIntHst(requestData, onlineCtx);
	    	
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	
	    return responseData;
	}

	/**
	 * 에이전트면접정보 저장 PM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-02-26 16:47:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pInsertAgentIntHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IUserInfo iUserInfo = onlineCtx.getUserInfo();
	    try{

	    	FAGENTINTHST001 fu = (FAGENTINTHST001)lookupFunctionUnit(FAGENTINTHST001.class);
	    	FAGENTCNTRT001 fu1 = (FAGENTCNTRT001)lookupFunctionUnit(FAGENTCNTRT001.class);	//계약정보	 
	    	
	    	//데이타편집 : USER_ID, 면접일(insert 시에는 "-" 제거 필요)
	    	requestData.putField("USER_ID", iUserInfo.getLoginId());
	    	requestData.putField("INT_DT", requestData.getField("INT_DT").replaceAll("-", ""));
	    	
	    	String INT_STA_TM = requestData.getField("INT_STA_H") + requestData.getField("INT_STA_M");
	    	String INT_END_TM = requestData.getField("INT_END_H") + requestData.getField("INT_END_M");
	    	requestData.putField("INT_STA_TM", INT_STA_TM);
	    	requestData.putField("INT_END_TM", INT_END_TM);
	    	
	    	//면접정보
	    	responseData = fu.fInsertAgentIntHst(requestData, onlineCtx);
	    	
	    	//면접횟수에 따라 처리상태 변경
	    	responseData = fu.fUpdateAgentIntHst(requestData, onlineCtx);
	    	
	    	//SMS전송 : 면접완료상태(21)이면 SMS발송(면접건수가 국직속1조직이면(2회), 일반조직이면(3회)를 판단하여 면접완료상태(21)로 변경되면 SMS발송.
	    	String CNTRT_ST_CD = fu1.fSelectAgentCntrtStCd(requestData, onlineCtx).getField("CNTRT_ST_CD");
	    	
	    	if( "21".equals( CNTRT_ST_CD ) ) {	    		
	    		
	    		requestData.putField("SALE_DEPT_ORG_ID", requestData.getField("APP_SALE_DEPT_ORG_ID"));
	    		
	    		requestData.putField("SMS_CHK", "6");
				IDataSet requestSms = fu1.fSelectAgentCntrtSmsSend(requestData, onlineCtx);	    			
				requestSms.putField("TRAN_MENU_ID", "1303");
				requestSms.putField("TRAN_TYP_CD", "46");
				requestSms.putField("TRAN_SYS", "BO");
				callSharedBizComponentByDirect("com.SHARE", "fSendSms", requestSms, onlineCtx);
	    	}	    	
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	
	    return responseData;
	}
  
}
