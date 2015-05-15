package com.psnm.dtok.com.share.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;

import org.apache.commons.logging.Log;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DBASE</li>
 * <li>설  명 : 조직정보, 사용자정보등 본 시스템의 기준정보 조회</li>
 * <li>작성일 : 2014-11-18 17:55:04</li>
 * <li>작성자 : admin (admin)</li>
 * </ul>
 *
 * @author admin (admin)
 */
public class DBASE extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다..
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DBASE(){
		super();
	}

	/**
	 * 에이전트정보를 조회하여 반환(NO페이징, 팝업용)
	 *
	 * @author admin (admin)
	 * @since 2014-11-18 17:55:04
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgent(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		Log log = getLog(onlineCtx);
		if ( log.isDebugEnabled() ) {
			log.debug("[에이전트조회] 입력파라미터 : " + requestData.getFieldMap() );
		}

	    IRecordSet rs = dbSelect("DBASE.dSearchAgent", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("ds", rs);

		return responseData;
	}

	/**
	 * 회원정보 팝업을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-15 17:28:09
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchUserPop(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DBASE.dSearchUserPop", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}

	/**
	 * 본사직원조회(팝업용)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-29 16:16:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchEmpPop(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    IRecordSet rs = dbSelect("DBASE.dSearchEmpPop", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	    return responseData;
	}

	/**
	 * [DM]권한그룹목록 - 전체목록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-12 15:31:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAuthGrp(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    IRecordSet rs = dbSelect("DBASE.dSearchAuthGrp", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs); 
	    return responseData;
	}

	/**
	 * [DM]에이전트조회(회원가입시) - 사용자테이블 JOIN 안함
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-03-05 17:27:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAgentNoMember(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
	    IRecordSet rs = dbSelect("DBASE.dSearchAgentNoMember", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
		return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-13 16:15:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAllUserPop(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		
	    IRecordSet rs = dbSelect("DBASE.dSearchAllUserPop", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("ds", rs); 
	
	    return responseData;
	}
  
}
