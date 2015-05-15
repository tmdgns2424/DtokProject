package com.psnm.dtok.biz.custpgcv.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.RecordHeader;
import nexcore.framework.core.data.RecordSet;
import nexcore.framework.core.util.StringUtils;



/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: [FU]고객민워관리</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-01-27 10:29:34</li>
 * <li>작성자 : 안진갑 (ahnjingap)</li>
 * </ul>
 *
 * @author 안진갑 (ahnjingap)
 */
public class FCUSTPGCV001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FCUSTPGCV001(){
		super();
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-27 10:58:38
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchCustPgcv(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DCUSTPGCV001 du = (DCUSTPGCV001)lookupDataUnit(DCUSTPGCV001.class);

		responseData = du.dSearchCustPgcv(requestData, onlineCtx);
		
		IRecordSet rs = responseData.getRecordSet("gridCustPgcv");
		
		int totalCount = 0;
		if( rs.getRecordCount() != 0 ){
			totalCount = rs.getRecord(0).getInt("COUNT");
		}
		rs.setTotalRecordCount( totalCount );
		rs.setPageNo(requestData.getIntField("page"));
		rs.setRecordCountPerPage(requestData.getIntField("page_size"));

		IDataSet reponseCnt = du.dSearchCustPgcvStCnt(requestData, onlineCtx);
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
	 * @since 2015-01-27 17:55:40
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertCustPgcv(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DCUSTPGCV001 du = (DCUSTPGCV001)lookupDataUnit(DCUSTPGCV001.class);
	    responseData = du.dInsertCustPgcv(requestData, onlineCtx);
	    
	    //파일첨부
		if( requestData.getRecordSet("gridfile") != null ){
			requestData.putField("ATCH_MGMT_ID", responseData.getField("RCV_MGMT_NUM"));
			requestData.putField("FILE_GRP_ID", "CST");
			callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
		}
		
		/*
		 * sms발송처리(국장, 영업국cs담당)
		 * div파라미터가 agnt이면 국장, 영업국cs담당자, emp이면 sms관리지정 계약직담당 직원
		 */		
		requestData.putField("div", "agnt");
		responseData = du.dSearchSmsRecordSet(requestData, onlineCtx);

	    responseData.putField("TRAN_MENU_ID", "6301"); 
	    responseData.putField("TRAN_TYP_CD", "01");
	    responseData.putField("TRAN_SYS", "TKEY");
	    
	    callSharedBizComponentByDirect("com.SHARE", "fSendSms", responseData, onlineCtx);
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-27 10:29:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertCustPgcvOp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DCUSTPGCVOP001 du = (DCUSTPGCVOP001)lookupDataUnit(DCUSTPGCVOP001.class);
	    DCUSTPGCV001 du2 = (DCUSTPGCV001)lookupDataUnit(DCUSTPGCV001.class);
	    
	    responseData = du.dInsertCustPgcvOp(requestData, onlineCtx);
	    
	    //파일첨부
		if( requestData.getRecordSet("gridfile") != null ){
			requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM")+"OP"+responseData.getField("OP_SEQ"));
			requestData.putField("FILE_GRP_ID", "CST");
			callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
		}
		
		requestData.putField("div", "emp");
		responseData = du2.dSearchSmsRecordSet(requestData, onlineCtx);

	    responseData.putField("TRAN_MENU_ID", "1701"); 
	    responseData.putField("TRAN_TYP_CD", "41");
	    responseData.putField("TRAN_SYS", "TKEY");
	    
	    callSharedBizComponentByDirect("com.SHARE", "fSendSms", responseData, onlineCtx);
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-27 10:29:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateCustPgcvOp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DCUSTPGCVOP001 du = (DCUSTPGCVOP001)lookupDataUnit(DCUSTPGCVOP001.class);
	    responseData = du.dUpdateCustPgcvOp(requestData, onlineCtx);
	    
	    //파일첨부
		if( requestData.getRecordSet("gridfile") != null ){
			requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM")+"OP"+requestData.getField("OP_SEQ"));
			requestData.putField("FILE_GRP_ID", "CST");
			callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
		}
		
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-09 17:43:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchCustPgcvDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DCUSTPGCV001 du = (DCUSTPGCV001)lookupDataUnit(DCUSTPGCV001.class);
	    DCUSTPGCVOP001 du2 = (DCUSTPGCVOP001)lookupDataUnit(DCUSTPGCVOP001.class);
	    //접수(완료) 정보 조회
		responseData = du.dSearchCustPgcvDtl(requestData, onlineCtx);
		//처리결과 조회
		responseData.putRecordSet( du2.dSearchCustPgcvOp(requestData, onlineCtx).getRecordSet("gridCustPgcvOp") );
		//첨부파일조회
		requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM"));
		requestData.putField("FILE_GRP_ID", "CST");
		IDataSet fileDataset = callSharedBizComponentByDirect("com.SHARE", "fSearchFileMapping", requestData, onlineCtx);
		responseData.putRecordSet("gridfile", fileDataset.getRecordSet("ds"));
		//최종완료 첨부파일조회		
		requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM")+"FN");
		requestData.putField("FILE_GRP_ID", "CST");
		fileDataset = callSharedBizComponentByDirect("com.SHARE", "fSearchFileMapping", requestData, onlineCtx);
		responseData.putRecordSet("gridfile2", fileDataset.getRecordSet("ds"));
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-10 14:32:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fUpdateCustPgcv(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DCUSTPGCV001 du = (DCUSTPGCV001)lookupDataUnit(DCUSTPGCV001.class);
	    responseData = du.dUpdateCustPgcv(requestData, onlineCtx);
	    
	    //파일첨부
		if( requestData.getRecordSet("gridfile") != null ){
			requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM"));
			requestData.putField("FILE_GRP_ID", "CST");
			callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
		}
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-10 15:35:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteCustPgcv(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DCUSTPGCV001 du = (DCUSTPGCV001)lookupDataUnit(DCUSTPGCV001.class);
	    // 첨부파일맵핑 삭제
	    requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM"));
	    callSharedBizComponentByDirect("com.SHARE", "fDeleteFileByMgmtId", requestData, onlineCtx);
	    
	    du.dDeleteCustPgcv(requestData, onlineCtx);
	    fDeleteCustPgcvOp(requestData, onlineCtx);
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-11 14:21:54
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchCustPgcvOpDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DCUSTPGCVOP001 du = (DCUSTPGCVOP001)lookupDataUnit(DCUSTPGCVOP001.class);
	    
	    responseData = du.dSearchCustPgcvOpDtl( requestData, onlineCtx);
	    
		//첨부파일조회
		requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM")+"OP"+requestData.getField("OP_SEQ"));
		requestData.putField("FILE_GRP_ID", "CST");
		IDataSet fileDataset = callSharedBizComponentByDirect("com.SHARE", "fSearchFileMapping", requestData, onlineCtx);
		responseData.putRecordSet("gridfile", fileDataset.getRecordSet("ds"));
		
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-11 15:51:33
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteCustPgcvOp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DCUSTPGCVOP001 du = (DCUSTPGCVOP001)lookupDataUnit(DCUSTPGCVOP001.class);
	    
	    // 첨부파일맵핑 삭제
	    if( StringUtils.isEmpty(requestData.getField("OP_SEQ")) ){
	    	responseData = du.dSearchCustPgcvOp( requestData, onlineCtx);
	    	
	    	IRecordSet rs = responseData.getRecordSet("gridCustPgcvOp");
	    	
	    	for(int i=0; i<rs.getRecordCount(); ++i){
			    requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM")+"OP"+rs.get(i, "OP_SEQ"));
			    callSharedBizComponentByDirect("com.SHARE", "fDeleteFileByMgmtId", requestData, onlineCtx); 	
	    	}
	    }else{
		    requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM")+"OP"+requestData.getField("OP_SEQ"));
		    callSharedBizComponentByDirect("com.SHARE", "fDeleteFileByMgmtId", requestData, onlineCtx); 	
	    }
	    
	    responseData = du.dDeleteCustPgcvOp( requestData, onlineCtx);
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-11 18:15:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchCustPgcvPrst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DCUSTPGCV001 du = (DCUSTPGCV001)lookupDataUnit(DCUSTPGCV001.class);

		responseData = du.dSearchCustPgcvPrst(requestData, onlineCtx);
		
		IRecordSet rs = responseData.getRecordSet("gridCustPgcvPrst");
		int totalCount = 0;
		if( rs.getRecordCount() != 0 ){
			totalCount = rs.getRecord(0).getInt("COUNT");
		}
		rs.setTotalRecordCount( totalCount );
		rs.setPageNo(requestData.getIntField("page"));
		rs.setRecordCountPerPage(requestData.getIntField("page_size"));
		
		IDataSet reponseCnt = du.dSearchCustPgcvStCnt(requestData, onlineCtx);
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
	 * @since 2015-01-27 10:29:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fFnshCustPgcv(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DCUSTPGCV001 du = (DCUSTPGCV001)lookupDataUnit(DCUSTPGCV001.class);
	    requestData.putField("CUST_PGCV_ST_CD", "Y");
	    responseData = du.dUpdateCustPgcv(requestData, onlineCtx);
	    
	    //파일첨부
		if( requestData.getRecordSet("gridfile") != null ){
			requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM")+"FN");
			requestData.putField("FILE_GRP_ID", "CST");
			callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
		}
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-12 12:40:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fRevokCustPgcv(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DCUSTPGCV001 du = (DCUSTPGCV001)lookupDataUnit(DCUSTPGCV001.class);
	    DCUSTPGCVHST001 du2 = (DCUSTPGCVHST001)lookupDataUnit(DCUSTPGCVHST001.class);
	    
	    responseData = du.dSearchCustPgcvDtl(requestData, onlineCtx);
	    responseData.putField("RERCV_CTT", requestData.getField("RERCV_CTT"));
	    du2.dInsertCustPgcvHst(responseData, onlineCtx);
	    
	    requestData.putField("CUST_PGCV_ST_CD", "R");
	    requestData.putField("RE_RCV_YN", "Y");
	    responseData = du.dUpdateCustPgcv(requestData, onlineCtx);
	    
	    requestData.putField("ATCH_MGMT_ID", requestData.getField("RCV_MGMT_NUM")+"FN");
	    callSharedBizComponentByDirect("com.SHARE", "fDeleteFileByMgmtId", requestData, onlineCtx);
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-27 10:29:34
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchIsMa(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DCUSTPGCV001 du = (DCUSTPGCV001)lookupDataUnit(DCUSTPGCV001.class);
	    responseData = du.dSearchIsMa(requestData, onlineCtx);
	    return responseData;
	}

}
