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
 * <li>단위업무명: [FU]비정상영업소명 관리</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-02-16 09:45:48</li>
 * <li>작성자 : 안진갑 (ahnjingap)</li>
 * </ul>
 *
 * @author 안진갑 (ahnjingap)
 */
public class FSCRBCLM001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FSCRBCLM001(){
		super();
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 09:47:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchScrbClm(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DSCRBCLM001 du = (DSCRBCLM001)lookupDataUnit(DSCRBCLM001.class);

		responseData = du.dSearchScrbClm(requestData, onlineCtx);
		
		IRecordSet rs = responseData.getRecordSet("gridScrbClm");
		int totalCount = 0;
		if( rs.getRecordCount() != 0 ){
			totalCount = rs.getRecord(0).getInt("COUNT");
		}
		rs.setTotalRecordCount( totalCount );
		rs.setPageNo(requestData.getIntField("page"));
		rs.setRecordCountPerPage(requestData.getIntField("page_size"));

		IDataSet reponseCnt = du.dSearchScrbClmStCnt(requestData, onlineCtx);
		responseData.putField("TOT_CNT", reponseCnt.getField("TOT_CNT"));			
		responseData.putField("PRC_CNT", reponseCnt.getField("PRC_CNT"));
		responseData.putField("REPRC_CNT", reponseCnt.getField("REPRC_CNT"));
		responseData.putField("END_CNT", reponseCnt.getField("END_CNT"));
		
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 09:45:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertScrbClm(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DSCRBCLM001 du = (DSCRBCLM001)lookupDataUnit(DSCRBCLM001.class);
	    responseData = du.dInsertScrbClm(requestData, onlineCtx);
	    
		/*
		 * sms발송처리(국장, 영업국cs담당)
		 * div파라미터가 agnt이면 국장, 영업국cs담당자, emp이면 sms관리지정 계약직담당 직원
		 */		
		requestData.putField("div", "agnt");
		responseData = du.dSearchSmsRecordSet(requestData, onlineCtx);

	    responseData.putField("TRAN_MENU_ID", "6302"); 
	    responseData.putField("TRAN_TYP_CD", "01");
	    responseData.putField("TRAN_SYS", "TKEY");
	    
	    callSharedBizComponentByDirect("com.SHARE", "fSendSms", responseData, onlineCtx);
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 11:41:57
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateScrbClm(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DSCRBCLM001 du = (DSCRBCLM001)lookupDataUnit(DSCRBCLM001.class);
	    responseData = du.dUpdateScrbClm(requestData, onlineCtx);
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 09:45:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchScrbClmDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DSCRBCLM001 du = (DSCRBCLM001)lookupDataUnit(DSCRBCLM001.class);
	    DSCRBCLMOP001 du2 = (DSCRBCLMOP001)lookupDataUnit(DSCRBCLMOP001.class);
	    //접수(완료) 정보 조회
		responseData = du.dSearchScrbClmDtl(requestData, onlineCtx);
		//처리결과 조회
		responseData.putRecordSet( du2.dSearchScrbClmOp(requestData, onlineCtx).getRecordSet("gridScrbClmOp") );
		//최종완료 첨부파일조회		
		requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM")+"FN");
		requestData.putField("FILE_GRP_ID", "SCR");
		IDataSet fileDataset = callSharedBizComponentByDirect("com.SHARE", "fSearchFileMapping", requestData, onlineCtx);
		responseData.putRecordSet("gridfile2", fileDataset.getRecordSet("ds"));
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 09:45:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteScrbClm(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DSCRBCLM001 du = (DSCRBCLM001)lookupDataUnit(DSCRBCLM001.class);
	    
	    du.dDeleteScrbClm(requestData, onlineCtx);
	    fDeleteScrbClmOp(requestData, onlineCtx);
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 15:37:06
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertScrbClmOp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DSCRBCLMOP001 du = (DSCRBCLMOP001)lookupDataUnit(DSCRBCLMOP001.class);
	    DSCRBCLM001 du2 = (DSCRBCLM001)lookupDataUnit(DSCRBCLM001.class);
	    
	    responseData = du.dInsertScrbClmOp(requestData, onlineCtx);
	    
	    //파일첨부
		if( requestData.getRecordSet("gridfile") != null ){
			requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM")+"OP"+responseData.getField("OP_SEQ"));
			requestData.putField("FILE_GRP_ID", "SCR");
			callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
		}
		
		requestData.putField("div", "emp");
		responseData = du2.dSearchSmsRecordSet(requestData, onlineCtx);

	    responseData.putField("TRAN_MENU_ID", "1703");
	    responseData.putField("TRAN_TYP_CD", "42");
	    responseData.putField("TRAN_SYS", "TKEY");
	    
	    callSharedBizComponentByDirect("com.SHARE", "fSendSms", responseData, onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 09:45:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateScrbClmOp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    DSCRBCLMOP001 du = (DSCRBCLMOP001)lookupDataUnit(DSCRBCLMOP001.class);
	    responseData = du.dUpdateScrbClmOp(requestData, onlineCtx);
	    
	    //파일첨부
		if( requestData.getRecordSet("gridfile") != null ){
			requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM")+"OP"+requestData.getField("OP_SEQ"));
			requestData.putField("FILE_GRP_ID", "SCR");
			callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
		}
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 09:45:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchScrbClmOpDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DSCRBCLMOP001 du = (DSCRBCLMOP001)lookupDataUnit(DSCRBCLMOP001.class);
	    
	    responseData = du.dSearchScrbClmOpDtl( requestData, onlineCtx);
	    
		//첨부파일조회
		requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM")+"OP"+requestData.getField("OP_SEQ"));
		requestData.putField("FILE_GRP_ID", "SCR");
		IDataSet fileDataset = callSharedBizComponentByDirect("com.SHARE", "fSearchFileMapping", requestData, onlineCtx);
		responseData.putRecordSet("gridfile", fileDataset.getRecordSet("ds"));
		
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 17:10:08
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteScrbClmOp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DSCRBCLMOP001 du = (DSCRBCLMOP001)lookupDataUnit(DSCRBCLMOP001.class);
	    
	    // 첨부파일맵핑 삭제
	    if( StringUtils.isEmpty(requestData.getField("OP_SEQ")) ){
	    	responseData = du.dSearchScrbClmOp( requestData, onlineCtx);
	    	
	    	IRecordSet rs = responseData.getRecordSet("gridScrbClmOp");
	    	
	    	for(int i=0; i<rs.getRecordCount(); ++i){
			    requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM")+"OP"+rs.get(i, "OP_SEQ"));
			    callSharedBizComponentByDirect("com.SHARE", "fDeleteFileByMgmtId", requestData, onlineCtx); 	
	    	}
	    }else{
		    requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM")+"OP"+requestData.getField("OP_SEQ"));
		    callSharedBizComponentByDirect("com.SHARE", "fDeleteFileByMgmtId", requestData, onlineCtx); 	
	    }
	    
	    responseData = du.dDeleteScrbClmOp( requestData, onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-16 09:45:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fFnshScrbClm(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DSCRBCLM001 du = (DSCRBCLM001)lookupDataUnit(DSCRBCLM001.class);
	    requestData.putField("SCRB_CLM_ST_CD", "Y");
	    responseData = du.dUpdateScrbClm(requestData, onlineCtx);
	    
	    //파일첨부
		if( requestData.getRecordSet("gridfile") != null ){
			requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM")+"FN");
			requestData.putField("FILE_GRP_ID", "SCR");
			callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
		}
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-17 10:00:45
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fRevokScrbClm(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DSCRBCLM001 du = (DSCRBCLM001)lookupDataUnit(DSCRBCLM001.class);
	    DSCRBCLMHST001 du2 = (DSCRBCLMHST001)lookupDataUnit(DSCRBCLMHST001.class);
	    
	    responseData = du.dSearchScrbClmDtl(requestData, onlineCtx);
	    responseData.putField("RERCV_CTT", requestData.getField("RERCV_CTT"));
	    du2.dInsertScrbClmHst(responseData, onlineCtx);
	    
	    requestData.putField("SCRB_CLM_ST_CD", "R");
	    requestData.putField("RE_RCV_YN", "Y");
	    responseData = du.dUpdateScrbClm(requestData, onlineCtx);
	    
	    requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM")+"FN");
	    callSharedBizComponentByDirect("com.SHARE", "fDeleteFileByMgmtId", requestData, onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-17 12:34:38
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchScrbClmPrst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DSCRBCLM001 du = (DSCRBCLM001)lookupDataUnit(DSCRBCLM001.class);

		responseData = du.dSearchScrbClmPrst(requestData, onlineCtx);
		
		IRecordSet rs = responseData.getRecordSet("gridScrbClmPrst");
		int totalCount = 0;
		if( rs.getRecordCount() != 0 ){
			totalCount = rs.getRecord(0).getInt("COUNT");
		}
		rs.setTotalRecordCount( totalCount );
		rs.setPageNo(requestData.getIntField("page"));
		rs.setRecordCountPerPage(requestData.getIntField("page_size"));
		
		IDataSet reponseCnt = du.dSearchScrbClmStCnt(requestData, onlineCtx);
		responseData.putField("TOT_CNT", reponseCnt.getField("TOT_CNT"));			
		responseData.putField("PRC_CNT", reponseCnt.getField("PRC_CNT"));
		responseData.putField("REPRC_CNT", reponseCnt.getField("REPRC_CNT"));
		responseData.putField("END_CNT", reponseCnt.getField("END_CNT"));

	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-04-23 16:55:54
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchIsMa(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DSCRBCLM001 du = (DSCRBCLM001)lookupDataUnit(DSCRBCLM001.class);
	    responseData = du.dSearchIsMa(requestData, onlineCtx);
	    return responseData;
	}
  
}
