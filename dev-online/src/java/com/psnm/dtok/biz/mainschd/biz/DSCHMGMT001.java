package com.psnm.dtok.biz.mainschd.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: [DU]주요일정관리</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-01-13 11:38:57</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 *
 * @author 이승훈2 (gunyoung)
 */
public class DSCHMGMT001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DSCHMGMT001(){
		super();
	}

	/**
	 * 주요일정 검색을 위하여 관련 테이블(DSM_SCHMGMT, DSM_SCH_READR_MGMT)을 조인하여 주요일정 객체를 map객체로 가져오는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:38:57
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSchMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		
	    IDataSet responseData = new DataSet();
	    
	    IRecordSet rs = dbSelect("DSCHMGMT001.dSearchSchMgmt", requestData.getFieldMap(), onlineCtx);
	    
	    responseData.putRecordSet("grid", rs);
	    
	    return responseData;
	}

	/**
	 * 주요일정 건수를 조회하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:38:57
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSchMgmtCnt(IDataSet requestData, IOnlineContext onlineCtx) {
		
	    IDataSet responseData = new DataSet();
	    
	    IRecordSet rs = dbSelect("DSCHMGMT001.dSearchSchMgmtCnt", requestData.getFieldMap(), onlineCtx);
	    
	    responseData.putRecordSet("COUNT", rs);
	    
	    return responseData;
	}

	/**
	 * 주요일정 정보를 상세 조회하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:38:57
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDetailSchMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		
	    IDataSet responseData = new DataSet();
	    
	    responseData.putFieldMap(dbSelectSingle("DSCHMGMT001.dDetailSchMgmt", requestData.getFieldMap(), onlineCtx));
	    
	    return responseData;
	}

	/**
	 * 주요일정관리ID 시퀀스 정보를 조회하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:38:57
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSchMgmtSeq(IDataSet requestData, IOnlineContext onlineCtx) {
		
	    IDataSet responseData = new DataSet();
	    
	    responseData.putFieldMap(dbSelectSingle("DSCHMGMT001.dSearchSchMgmtSeq", requestData.getFieldMap(), onlineCtx));
	    
	    return responseData;

	}

	/**
	 * 주요일정을 추가하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:38:57
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertSchMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		
	    IDataSet responseData = new DataSet();
	    
	    dbInsert("DSCHMGMT001.dInsertSchMgmt", requestData.getFieldMap(), onlineCtx);
	    
	    return responseData;
	}

	/**
	 * 주요일정을 수정하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:38:57
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateSchMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		
	    IDataSet responseData = new DataSet();
	    
	    dbUpdate("DSCHMGMT001.dUpdateSchMgmt", requestData.getFieldMap(), onlineCtx);
	    
	    return responseData;

	}

	/**
	 * 주요일정을 삭제하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-16 10:18:59
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteSchMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		
	    IDataSet responseData = new DataSet();
	    
	    dbDelete("DSCHMGMT001.dDeleteSchMgmt", requestData.getFieldMap(), onlineCtx);
	    
	    return responseData;
	}

	/**
	 * 주요일정 정보를 조회 하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-16 16:56:54
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSchMgmtBrws(IDataSet requestData, IOnlineContext onlineCtx) {
		
		 IDataSet responseData = new DataSet();
		 
		 IRecordSet rs = dbSelect("DSCHMGMT001.dSearchSchMgmtBrws", requestData.getFieldMap(), onlineCtx);
		 
		 responseData.putRecordSet("ds", rs);
		 
		 return responseData;
	}

	/**
	 * 주요일정 정보를 조회 한 건수 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:38:57
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSchMgmtBrwsCnt(IDataSet requestData, IOnlineContext onlineCtx) {
		
	    IDataSet responseData = new DataSet();
	    
	    IRecordSet rs = dbSelect("DSCHMGMT001.dSearchSchMgmtBrwsCnt", requestData.getFieldMap(), onlineCtx);
		responseData.putField("count", rs.get(0, 0));
		
	    return responseData;
	}

	/**
	 * 주요일정 달력을 조회하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-19 18:17:41
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSchMgmtBrwsCal(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		
	    IRecordSet rs  = dbSelect("DSCHMGMT001.dSearchSchMgmtBrwsCal"	 , requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		
	    return responseData;
	}

	/**
	 * 주요일정을 팝업에 상세 조회를 하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:38:57
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchPopSchMgmtBrws(IDataSet requestData, IOnlineContext onlineCtx) {
		
		 IDataSet responseData = new DataSet();
		 
		 IRecordSet rs = dbSelect("DSCHMGMT001.dSearchPopSchMgmtBrws", requestData.getFieldMap(), onlineCtx);
		 
		 responseData.putRecordSet("grid", rs);
		 
		 return responseData;
	}

	/**
	 * 주요일정 팝업의 상세 건수를 조회 하는 메소드
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:38:57
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchPopSchMgmtBrwsCnt(IDataSet requestData, IOnlineContext onlineCtx) {
		
		IDataSet responseData = new DataSet();
		
	    IRecordSet rs = dbSelect("DSCHMGMT001.dSearchPopSchMgmtBrwsCnt", requestData.getFieldMap(), onlineCtx);
	    
		responseData.putRecordSet("COUNT", rs);
		
	    return responseData;
	}

	/**
	 * 주요일정관리휴일 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-12 10:14:40
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSchMgmtBrwsCalHDay(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DSCHMGMT001.dSearchSchMgmtBrwsCalHDay", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-12 14:02:58
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSchMgmtBrwsCalData(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		 
		 IRecordSet rs = dbSelect("DSCHMGMT001.dSearchSchMgmtBrwsCalData", requestData.getFieldMap(), onlineCtx);
		 
		 responseData.putRecordSet("gridCal", rs);
		 
		 return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-13 11:38:57
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSchMgmtAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DSCHMGMT001.dSearchSchMgmtAuthGrp", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}
	
}
