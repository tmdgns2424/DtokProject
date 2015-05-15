package com.psnm.dtok.brd.brdbannce.biz;

import java.util.Map;

import org.apache.commons.logging.Log;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecord;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.IResultMessage;
import nexcore.framework.core.data.ResultMessage;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/게시판</li>
 * <li>단위업무명: DDSM_ANNCE</li>
 * <li>설  명 : 공지사항</li>
 * <li>작성일 : 2014-11-05 13:05:18</li>
 * <li>작성자 : admin (admin)</li>
 * </ul>
 *
 * @author admin (admin)
 */
public class DDSM_ANNCE extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DDSM_ANNCE(){
		super();
	}

	/**
	 * 공지사항 목록조회(페이징)
	 *
	 * @author admin (admin)
	 * @since 2014-11-05 13:08:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDSM_ANNCE_S001(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
	    Log log = getLog(onlineCtx);
	    log.debug("#공지사항 목록조회# 검색조건(필드맵) :: " + requestData.getFieldMap());

		IRecordSet rs = dbSelect("DDSM_ANNCE.S001", requestData.getFieldMap(), onlineCtx);

		if (rs == null)
			throw new BizRuntimeException("MSTAE00001");

		if (rs != null && rs.getRecordCount() > 0) {
			log.debug("#공지사항 목록조회# 1번째제목 = [" + rs.get(0, "ANNCE_TITL_NM") + "]");
		}
		responseData.putRecordSet("ds", rs);

		return responseData;
	}

	/**
	 * 공지사항 건수조회
	 *
	 * @author admin (admin)
	 * @since 2014-11-05 13:26:14
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDSM_ANNCE_S002(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		
	    Log log = getLog(onlineCtx);

		IRecordSet rs = dbSelect("DDSM_ANNCE.S002", requestData.getFieldMap(), onlineCtx);

		if (rs == null)
			throw new BizRuntimeException("MSTAE00001");

		if (rs != null && rs.getRecordCount() > 0) {
			log.debug("#공지사항건수조회# 건수 = " + rs.get(0, "ANNCE_CNT"));
		}
		responseData.putRecordSet("ds", rs);

		return responseData;
	}

	/**
	 * 공지사항 1건조회
	 *
	 * @author admin (admin)
	 * @since 2014-11-07 10:34:15
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAnnce(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
	    log.debug("[공지사항 1건조회] 검색조건(필드맵) :: " + requestData.getFieldMap());

		IRecord map = this.dbSelectSingle("DDSM_ANNCE.dSearchAnnce", requestData.getFieldMap(), onlineCtx);

		if (map != null && map.size() > 0) {
			if (log.isDebugEnabled());
		}
		responseData.putFieldMap(map);
	
	    return responseData;
	}

	/**
	 * 공지사항 첨부파일조회
	 *
	 * @author admin (admin)
	 * @since 2014-11-05 13:05:18
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAnnceAtchFile(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
	    log.debug("[공지사항 첨부파일조회] 검색조건 : " + requestData.getFieldMap());

		IRecordSet rs = dbSelect("DDSM_ANNCE.dSearchAnnceAtchFile", requestData.getFieldMap(), onlineCtx);

		if (rs == null)
			throw new BizRuntimeException("MSTAE00001");

		if (rs != null && rs.getRecordCount() > 0) {
			if (log.isDebugEnabled());
		}
		responseData.putRecordSet("ds", rs);

		return responseData;
	}

	/**
	 * 공지사항ID 시퀀스채번
	 *
	 * @author admin (admin)
	 * @since 2014-11-11 09:45:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchAnnceIdSeq(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);

		IRecordSet rs = dbSelect("DDSM_ANNCE.dSearchAnnceIdSeq", requestData.getFieldMap(), onlineCtx);

		if (rs == null)
			throw new BizRuntimeException("MSTAE00001");

		if (rs != null && rs.getRecordCount() > 0) {
			log.debug("#공지사항ID채번# 채번ID = " + rs.get(0, "ANNCE_ID"));
		}
		responseData.putRecordSet("ds", rs);

		return responseData;
	}

	/**
	 * 공지사항 등록
	 *
	 * @author admin (admin)
	 * @since 2014-11-11 09:51:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertAnnce(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		int result = dbInsert("DDSM_ANNCE.dInsertAnnce", requestData.getFieldMap(), onlineCtx);
		//if (result != 1) throw new BizRuntimeException("MSTAE00004");
		if (log.isDebugEnabled()) {
			log.debug("#공지사항 등록# 결과 = " + result);
		}
		return responseData;
	}

	/**
	 * 공지사항 첨부파일등록
	 *
	 * @author admin (admin)
	 * @since 2014-11-11 09:58:24
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertAnnceAtchFile(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		int result = dbInsert("DDSM_ANNCE.dInsertAnnceAtchFile", requestData.getFieldMap(), onlineCtx);
		//if (result != 1) throw new BizRuntimeException("MSTAE00004");
		if (log.isDebugEnabled()) {
			log.debug("#공지사항 첨부파일등록# 결과 = " + result);
		}
		return responseData;
	}

	/**
	 * 공지사항 첨부파일삭제
	 *
	 * @author admin (admin)
	 * @since 2014-11-11 10:03:51
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteAnnceAtchFile(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		int result = dbDelete("DDSM_ANNCE.dDeleteAnnceAtchFile", requestData.getFieldMap(), onlineCtx);
		//if (result != 1) throw new BizRuntimeException("MSTAE00004");
		if (log.isDebugEnabled()) {
			log.debug("#공지사항 첨부파일삭제# 결과 = " + result);
		}
		return responseData;
	}

	/**
	 * 공지사항 정보를 수정
	 *
	 * @author admin (admin)
	 * @since 2014-11-14 09:45:08
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateAnnce(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

		Log log = getLog(onlineCtx);

		int result = dbUpdate("DDSM_ANNCE.dUpdateAnnce", requestData.getFieldMap(), onlineCtx);

		if (log.isDebugEnabled()) {
			log.debug("[공지사항수정] 결과 : " + result);
		}

	    return responseData;
	}
 
}
