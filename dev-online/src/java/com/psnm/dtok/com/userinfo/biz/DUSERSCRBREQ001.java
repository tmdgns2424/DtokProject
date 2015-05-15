package com.psnm.dtok.com.userinfo.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DUSERSCRBREQ001</li>
 * <li>설  명 : 회원정보관리 DU</li>
 * <li>작성일 : 2014-12-03 18:02:16</li>
 * <li>작성자 : 한상곤 (hansanggon)</li>
 * </ul>
 *
 * @author 한상곤 (hansanggon)
 */
public class DUSERSCRBREQ001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DUSERSCRBREQ001(){
		super();
	}

	/**
	 * 에이전트 조회[팝업] DM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-12-03 18:04:51
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    if( "2".equals(requestData.getField("agentSearchCheck")) ){
	    	responseData.putRecordSet("gridagnt", dbSelect("DUSERSCRBREQ001.dSearchAgnt2", requestData.getFieldMap(), onlineCtx));	
	    }
	    else{
	    	responseData.putRecordSet("gridagnt", dbSelect("DUSERSCRBREQ001.dSearchAgnt", requestData.getFieldMap(), onlineCtx));	
	    }
	    
	
	    return responseData;
	}

	/**
	 * 에이전트 건수조회[팝업] DM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-12-03 18:09:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgntCnt(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
		if( "2".equals(requestData.getField("agentSearchCheck")) ){
			IRecordSet rs = dbSelect("DUSERSCRBREQ001.dSearchAgntCnt2", requestData.getFieldMap(), onlineCtx);
			responseData.putRecordSet("ds", rs);
		}
		else{
			IRecordSet rs = dbSelect("DUSERSCRBREQ001.dSearchAgntCnt", requestData.getFieldMap(), onlineCtx);
			responseData.putRecordSet("ds", rs);
		}
		
		
	    return responseData;
	}

	/**
	 * 회원가입요청정보 검색을 위하여 관련 테이블(DSM_USER_SCRB_REQ)을 조인하여 회원가입요청정보 객체를 map객체로 가져오는 메소드
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:02:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchUserScrbReq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		IRecordSet rs = dbSelect("DUSERSCRBREQ001.dSearchUserScrbReq", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("grid", rs);	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:02:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchUserScrbReqDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		IRecord record = dbSelectSingle("DUSERSCRBREQ001.dSearchUserScrbReqDtl", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:02:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertUserScrbReq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    dbInsert("DUSERSCRBREQ001.dInsertUserScrbReq", requestData.getFieldMap(), onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:02:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateUserScrbReq(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    dbUpdate("DUSERSCRBREQ001.dUpdateUserScrbReq", requestData.getFieldMap(), onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:02:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertUserInfo1(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    dbInsert("DUSERSCRBREQ001.dInsertUserInfo1", requestData.getFieldMap(), onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:02:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertUserInfo2(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    dbInsert("DUSERSCRBREQ001.dInsertUserInfo2", requestData.getFieldMap(), onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:02:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertUserInfoHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    dbInsert("DUSERSCRBREQ001.dInsertUserInfoHst", requestData.getFieldMap(), onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-23 13:01:42
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchUserAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		IRecordSet rs = dbSelect("DUSERSCRBREQ001.dSearchUserAuthGrp", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("rs", rs);	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:02:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSaveChangedFaxNo(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    dbUpdate("DUSERSCRBREQ001.dSaveChangedFaxNo", requestData.getFieldMap(), onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:02:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateMACntrtState(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    dbUpdate("DUSERSCRBREQ001.dUpdateMACntrtState", requestData.getFieldMap(), onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-29 09:41:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchUserScrbApprCnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    IRecord record = dbSelectSingle("DUSERSCRBREQ001.dSearchUserScrbApprCnt", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);
		
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-01 10:52:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchNickNmChk(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		IRecord record = dbSelectSingle("DUSERSCRBREQ001.dSearchNickNmChk", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-01 14:12:24
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchFaxNumChk(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		IRecord record = dbSelectSingle("DUSERSCRBREQ001.dSearchFaxNumChk", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-01 15:33:45
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAddr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    IRecordSet record = dbSelect("DUSERSCRBREQ001.dSearchAddr", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("gridAddress",record);	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-13 13:23:24
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchEmailChk(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		IRecord record = dbSelectSingle("DUSERSCRBREQ001.dSearchEmailChk", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:02:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchUserIDChk(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		IRecord record = dbSelectSingle("DUSERSCRBREQ001.dSearchUserIDChk", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-13 16:14:43
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchCntrtStCd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    IRecordSet record = dbSelect("DUSERSCRBREQ001.dSearchCntrtStCd", requestData.getFieldMap(), onlineCtx);
	    responseData.putRecordSet("state", record);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:02:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchMemberChk(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		IRecord record = dbSelectSingle("DUSERSCRBREQ001.dSearchMemberChk", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:02:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSmsRecordSet(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    IRecordSet record = dbSelect("DUSERSCRBREQ001.dSearchSmsRecordSet", requestData.getFieldMap(), onlineCtx);
	    responseData.putRecordSet("ds", record);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-30 13:54:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchUserScrbReqCnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    IRecord record = dbSelectSingle("DUSERSCRBREQ001.dSearchUserScrbReqCnt", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-16 10:23:55
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSmemberCnt(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DUSERSCRBREQ001.dSearchSmemberCnt", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-16 10:24:43
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSmember(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    responseData.putRecordSet("gridsmember", dbSelect("DUSERSCRBREQ001.dSearchSmember", requestData.getFieldMap(), onlineCtx));
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-12-03 18:02:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertPwdChgHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    dbInsert("DUSERSCRBREQ001.dInsertPwdChgHst", requestData.getFieldMap(), onlineCtx);
	    return responseData;
	}  
}
