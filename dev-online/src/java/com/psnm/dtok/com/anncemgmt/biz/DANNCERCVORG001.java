package com.psnm.dtok.com.anncemgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DANNCERCVORG001</li>
 * <li>설  명 : 공지사항조직 DU</li>
 * <li>작성일 : 2015-01-08 14:59:51</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class DANNCERCVORG001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DANNCERCVORG001(){
		super();
	}

	/**
	 * 공지대상조직정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-08 14:59:51
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAnnceRcvOrgTarget(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DANNCERCVORG001.dSearchAnnceRcvOrgTarget", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * 공지할조직정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-08 14:59:51
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAnnceRcvOrgObject(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DANNCERCVORG001.dSearchAnnceRcvOrgObject", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * 공지조직정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-08 16:30:33
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertAnnceRcvOrg(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DANNCERCVORG001.dInsertAnnceRcvOrg", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 공지조직정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-08 16:30:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteAnnceRcvOrg(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DANNCERCVORG001.dDeleteAnnceRcvOrg", requestData.getFieldMap(), onlineCtx); 
	
	    return responseData;
	}
  
}
