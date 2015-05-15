package com.psnm.dtok.com.bltnbrd.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import com.psnm.common.util.PsnmStringUtil;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FBLTNBRD001</li>
 * <li>설  명 : 커뮤니티 > 게시판 관련 FU</li>
 * <li>작성일 : 2015-01-30 17:03:35</li>
 * <li>작성자 : 김지홍 (kimjihong)</li>
 * </ul>
 *
 * @author 김지홍 (kimjihong)
 */
public class FBLTNBRD001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FBLTNBRD001(){
		super();
	}
	
	/**
	 *
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:10:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchBltnBrdTree(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		requestData.putField("BLTN_BRD_ID"		, requestData.getField("BLTN_BRD_ID"));
		requestData.putField("S_USER_ID"		, onlineCtx.getUserInfo().get("USER_ID").toString());
		requestData.putField("S_DUTY_TYP_CD"	, onlineCtx.getUserInfo().get("DUTY").toString());
		requestData.putField("S_DEPT_CD"		, onlineCtx.getUserInfo().get("SALE_DEPT_ORG_ID").toString());
		requestData.putField("S_ATTC_CAT"		, onlineCtx.getUserInfo().get("ATTC_CAT").toString());

	    try {
	    	DBLTNBRD001 du = (DBLTNBRD001) lookupDataUnit(DBLTNBRD001.class);

		    IRecordSet list = du.dSearchBltnBrdTree(requestData, onlineCtx).getRecordSet("ds"); 

			responseData.putRecordSet("tree", list);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * 해당 게시판 조회 FM
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:03:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchBltnBrdList(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	DBLTNBRD001 du = (DBLTNBRD001) lookupDataUnit(DBLTNBRD001.class);
	    	responseData = du.dSearchBltnBrdList(requestData, onlineCtx);	    	
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null); 
	
	    return responseData;
	}

	/**
	 * 해당 게시판 상세조회 FM
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-03 16:57:01
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDetailBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	if(!PsnmStringUtil.isEmpty(requestData.getField("BLTCONT_ID"))){
	    		
		    	DBLTNBRD001 du = (DBLTNBRD001) lookupDataUnit(DBLTNBRD001.class);
		    	//1. 상세내역
		    	responseData = du.dDetailBltnBrd(requestData, onlineCtx);
		    	
		    	//2. 첨부파일 조회
		    	requestData.putField("ATCH_MGMT_ID", requestData.getField("BLTCONT_ID"));
	    		IDataSet fileDataset = callSharedBizComponentByDirect("com.SHARE", "fSearchFileMapping", requestData, onlineCtx);
	    		responseData.putRecordSet("gridfile", fileDataset.getRecordSet("ds"));
	    		
	    		//3. 열람자 등록
			    callSharedBizComponentByDirect("com.SHARE", "fMergeReadrMgmt", requestData, onlineCtx);
	    	}
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);  
	
	    return responseData;
	}

	/**
	 * 게시판 신규 등록 및 수정하는  메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:03:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSaveBltnBrdInfo(IDataSet requestData, IOnlineContext onlineCtx) {
	    
		IDataSet responseData = new DataSet();
	
		try { 
	    	
	    	DBLTNBRD001 du = (DBLTNBRD001) lookupDataUnit(DBLTNBRD001.class);
	    	
	    	//수정가능 여부 체크 
	    	responseData = du.dCheckBltnBrd(requestData, onlineCtx) ;
	    	String AUTH_TYP_CD 	= responseData.getField("AUTH_TYP_CD");
			String RGSTR_YN 	= responseData.getField("RGSTR_YN");
			
	    	//1-1. 신규 저장
	    	if( PsnmStringUtil.isEmpty(requestData.getField("BLTCONT_ID")) ) {
	    		//신규 ID
	    		requestData.putField("BLTCONT_ID", du.dSearchBltnBrdIdSeq(requestData, onlineCtx).getField("BLTCONT_ID"));
	    		du.dInsertBltnBrdInfo(requestData, onlineCtx);	
	    		
	    		//담당자에게 SMS발송
	    		if("Y".equals(requestData.getField("SMS_RCV_YN"))){
	    			
	    			IDataSet _ds_sms = du.dSearchBltnBrdChrgrForSms(requestData, onlineCtx);			    	
		    			    		
			    	_ds_sms.putField("TRAN_MENU_ID" ,"5100");
			    	_ds_sms.putField("TRAN_TYP_CD"	,"01");
			    	_ds_sms.putField("TRAN_SYS", "TKEY");

			    	responseData = callSharedBizComponentByDirect("com.SHARE", "fSendSms", _ds_sms, onlineCtx);
	    		}   		
				
	    	}else{
	    	//1-2. 정보 수정
	    		if(!("Y".equals(RGSTR_YN) || "E".equals(AUTH_TYP_CD))){
		    		// 메세지 확인 필요
					throw new BizRuntimeException("PSNM-E000");
				}
	    		du.dUpdateBltnBrdInfo(requestData, onlineCtx);
	    	}
	    	
	    	//2. 첨부파일 저장
			requestData.putField("BLTCONT_ID", requestData.getField("BLTCONT_ID") );
			if(requestData.getRecordSet("gridfile") != null){				
				callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
			}
	    	responseData.setOkResultMessage("PSNM-I000", null);
	    		    	
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	     
	
	    return responseData;
	}

	/**
	 * 해당 게시글 삭제 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-05 09:45:14
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	  
	    try { 	    	
	    	DBLTNBRD001 du = (DBLTNBRD001) lookupDataUnit(DBLTNBRD001.class);
	    	
	    	//삭제가능 여부 체크 
	    	responseData = du.dCheckBltnBrd(requestData, onlineCtx) ;
	    	String AUTH_TYP_CD 	= responseData.getField("AUTH_TYP_CD");
			String RGSTR_YN 	= responseData.getField("RGSTR_YN");
						
	    	if(!("Y".equals(RGSTR_YN) || "E".equals(AUTH_TYP_CD))){
	    		// 메세지 확인 필요
				throw new BizRuntimeException("PSNM-E000");
			}
	    	du.dDeleteBltnBrdInfo(requestData, onlineCtx);
	    	responseData.setOkResultMessage("PSNM-I000", null);	    		    	
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 게시판 답글 저장하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-05 15:35:59
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertBltnBrdReply(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try { 	    	
	    	DBLTNBRD001 du = (DBLTNBRD001) lookupDataUnit(DBLTNBRD001.class);
	    	//1. 신규ID
	    	requestData.putField("BLTCONT_ID", du.dSearchBltnBrdIdSeq(requestData, onlineCtx).getField("BLTCONT_ID"));
	    	//2. 답글저장
	    	responseData = du.dInsertBltnBrdReply(requestData, onlineCtx) ;
	    	//3. 첨부파일 저장			
			requestData.putField("BLTCONT_ID", requestData.getField("BLTCONT_ID") );
			requestData.putField("FILE_GRP_ID", "BLT" );		
			if(requestData.getRecordSet("gridfile") != null){				
				callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
			}
	    	responseData.setOkResultMessage("PSNM-I000", null);	    		    	
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 게시판비밀번호가능여부 체크하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:03:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fCheckBltnBrdScrtNum(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try { 	    	
	    	DBLTNBRD001 du = (DBLTNBRD001) lookupDataUnit(DBLTNBRD001.class);
	    	
	    	responseData.putFieldMap(du.dCheckBltnBrdScrtNum(requestData, onlineCtx).getFieldMap());
	    	
	    	responseData.setOkResultMessage("PSNM-I000", null);	    		    	
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 게시글이동 관련하여 게시판 그룹조회하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-30 17:03:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchBltnBrdMoveInfo(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try { 	    	
	    	DBLTNBRD001 du = (DBLTNBRD001) lookupDataUnit(DBLTNBRD001.class);
	    	IRecordSet rs1 = null;
	    	
	    	// 상세내역
	    	responseData.putFieldMap(du.dDetailBltnBrdForMove(requestData, onlineCtx).getFieldMap());
	    	
	    	// 대그룹
	    	IRecordSet rs = du.dSearchBntlBrdLvl1(requestData, onlineCtx).getRecordSet("ds"); 
			responseData.putRecordSet("largeComboList", rs);
			
			if(rs.getRecordCount() > 0){
				requestData.putField("LVL1_ID", PsnmStringUtil.isNullToString(responseData.getField("LVL1_ID")));
				//중그룹
				rs1 = du.dSearchBltnBrdLvl2(requestData, onlineCtx).getRecordSet("ds"); //중그룹
				responseData.putRecordSet("mdlComboList", rs1);
			}
			
			if(rs1.getRecordCount() > 0){
				requestData.putField("LVL1_ID", PsnmStringUtil.isNullToString(responseData.getField("LVL1_ID")));
				requestData.putField("LVL2_ID", PsnmStringUtil.isNullToString(responseData.getField("LVL2_ID")));
				//게시판
				responseData.putRecordSet("brdComboList", du.dSearchBltnBrdLvl3(requestData, onlineCtx).getRecordSet("ds")); 
			}
			//답글목록
			responseData.putRecordSet("gridList", du.dSearchBltnBrdReplyList(requestData, onlineCtx).getRecordSet("ds")); 
			
	    	responseData.setOkResultMessage("PSNM-I000", null);	    		    	
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 게시글 이동하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-06 17:10:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateBltnBrdMove(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try { 	    	
	    	DBLTNBRD001 du = (DBLTNBRD001) lookupDataUnit(DBLTNBRD001.class);
	    	
	    	//이동가능여부 검증
	    	responseData = du.dCheckBltnBrd(requestData, onlineCtx) ;
	    	String AUTH_TYP_CD 	= responseData.getField("AUTH_TYP_CD");
						
			if(!("E".equals(AUTH_TYP_CD))){
				throw new BizRuntimeException("PSNM-E000");
			}			
			
	    	du.dUpdateBltnBrdMove(requestData, onlineCtx);
						
	    	responseData.setOkResultMessage("PSNM-I000", null);	    		    	
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * 주간.월간 게시글 추천하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-06 18:10:19
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fRcmndBtlnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try { 	    	
	    	DBLTNBRD001 du = (DBLTNBRD001) lookupDataUnit(DBLTNBRD001.class);
	    	
	    	String rcmndPsbl = "N" ;
	    	String rcmndYn = "" ;
	    	String RCMND_TYP_CD = PsnmStringUtil.isNullToString(requestData.getField("RCMND_TYP_CD")) ;
	    	
	    	//추천가능여부 검증	    	
	    	if("01".equals(RCMND_TYP_CD)){ //주간	    		
	    		rcmndPsbl = (String) du.dCheckWeekRcmndPsbl(requestData, onlineCtx).getField("WEEK_RCMND_PSBL_YN");	    		
	    	}else{ //월간
	    		rcmndPsbl = (String) du.dCheckMothRcmndPsbl(requestData, onlineCtx).getField("MTH_RCMND_PSBL_YN");
	    	}	    		    	
	    	
	    	if("Y".equals(rcmndPsbl)){
	    		rcmndYn = du.dInsertRcmnd(requestData, onlineCtx).getField("result");
	    	}
	    	responseData.putField("RCMND_PSBL_YN", rcmndPsbl) ;
	    	responseData.putField("RCMND_INSERT_YN", rcmndYn) ;
						
	    	responseData.setOkResultMessage("PSNM-I000", null);	    		    	
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}  
	
	    return responseData;
	}

	/**
	 * 글이동 관련 게시판 그룹조회 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-10 11:38:58
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchBltnBrdGrp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try { 	    	
	    	DBLTNBRD001 du = (DBLTNBRD001) lookupDataUnit(DBLTNBRD001.class);
	    	
	    	String LVL1 = PsnmStringUtil.isNullToString(requestData.getField("LVL1_ID")) ;
	    	String LVL2 = PsnmStringUtil.isNullToString(requestData.getField("LVL2_ID")) ;
	    	
	    	requestData.putField("LVL1_ID", LVL1);
	    	requestData.putField("LVL2_ID", LVL2);
	    	
	    	if( !"".equals(LVL1) && "".equals(LVL2)  ){  //중그룹 조회	    		 
				responseData.putRecordSet("mdlComboList", du.dSearchBltnBrdLvl2(requestData, onlineCtx).getRecordSet("ds"));	    		
	    	}else if( !"".equals(LVL1) && !"".equals(LVL2) ){ // 게시판 조회
	    		responseData.putRecordSet("brdComboList", du.dSearchBltnBrdLvl3(requestData, onlineCtx).getRecordSet("ds")); 
	    	}	    		    	
	    	responseData.setOkResultMessage("PSNM-I000", null);	    		    	
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}  
	
	    return responseData;
	}

	/**
	 * 해당 게시판 정보조회하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-02-10 16:28:29
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchBltnBrdInfo(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try { 	    	
	    	DBLTNBRD001 du = (DBLTNBRD001) lookupDataUnit(DBLTNBRD001.class);	    	
	    	responseData.putFieldMap(du.dSearchBltnBrdInfo(requestData, onlineCtx).getFieldMap());
	    	responseData.setOkResultMessage("PSNM-I000", null);	    		    	
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}  
	
	    return responseData;
	}

	/**
	 * 게시판삭제가능여부확인 FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-10 15:11:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fCheckBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try { 	    	
	    	DBLTNBRD001 du = (DBLTNBRD001) lookupDataUnit(DBLTNBRD001.class);
	    	
	    	//삭제가능 여부 체크 
	    	responseData = du.dCheckBltnBrd(requestData, onlineCtx) ;

	    	responseData.setOkResultMessage("PSNM-I000", null);	    		    	
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 게시판삭제(기간조회) FM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-03-18 11:03:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteBltnBrdSrchAll(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try { 	    	
	    	DBLTNBRD001 du = (DBLTNBRD001) lookupDataUnit(DBLTNBRD001.class);
	    	
	    	//삭제가능 여부 체크 
	    	responseData = du.dCheckBltnBrd(requestData, onlineCtx) ;
	    	
	    	String AUTH_TYP_CD = responseData.getField("AUTH_TYP_CD");
			String RGSTR_YN = responseData.getField("RGSTR_YN");
						
	    	if(!("Y".equals(RGSTR_YN) || "E".equals(AUTH_TYP_CD))){
	    		// 메세지 확인 필요
				throw new BizRuntimeException("PSNM-E000");
			}
	    	
	    	du.dDeleteBltnBrdSrchAll(requestData, onlineCtx);
	    	responseData.setOkResultMessage("PSNM-I000", null);	    		    	
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
  
}
