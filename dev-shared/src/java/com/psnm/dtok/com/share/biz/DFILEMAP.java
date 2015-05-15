package com.psnm.dtok.com.share.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DFILEMAP</li>
 * <li>설  명 : 첨부파일과 각 컨텐츠와의 매핑정보를 조회,등록,삭제하는 DU 클래스</li>
 * <li>작성일 : 2014-12-15 15:57:07</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class DFILEMAP extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DFILEMAP(){
		super();
	}

	/**
	 * 업무구분에 따른 첨부파일매핑조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-15 15:57:07
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchFileMapByType(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    IRecordSet rs = null; //dbSelect("DFILEMAP.dSearchFileMgmt", requestData.getFieldMap(), onlineCtx);

	    Log log = getLog(onlineCtx);
		if ( log.isDebugEnabled() ) {
			log.debug("<<<첨부파일매핑조회>>> 입력파라미터 정보 : " + requestData.getFieldMap());
		}

	    String fileGrpId = requestData.getField("FILE_GRP_ID");
	    String qid = "DFILEMAP.dSearchFile" + this.getPostfix(fileGrpId);
    	log.info("<<<첨부파일매핑조회>>> 파일그룹ID(업무구분) : '" + fileGrpId + "', 쿼리ID : '" + qid + "'");

    	rs = dbSelect(qid, requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	    return responseData;
	}

	private String getPostfix(String fileGrpId) {
	    String postfix = "Mgmt";
    	if ( StringUtils.equalsIgnoreCase("annce", fileGrpId) ) {
    		postfix = "Annce";
    	}
    	else if ( StringUtils.equalsIgnoreCase("BIZTRGT", fileGrpId) ) {
    		postfix = "Biztrgt";
    	}
    	else if ( StringUtils.equalsIgnoreCase("BLTCONT", fileGrpId) ) {
    		postfix = "Bltcont";
    	}
    	else if ( StringUtils.equalsIgnoreCase("EDU", fileGrpId) ) {
    		postfix = "Edu";
    	}
    	else if ( StringUtils.equalsIgnoreCase("FAQ", fileGrpId) ) {
    		postfix = "Faq";
    	}
    	else if ( StringUtils.equalsIgnoreCase("ISSUE", fileGrpId) ) {
    		postfix = "Issue";
    	}
    	else if ( StringUtils.equalsIgnoreCase("P2P", fileGrpId) ||
    			  StringUtils.equalsIgnoreCase("P2P_CNSL", fileGrpId) ) {
    		postfix = "P2p";
    	}
    	else if ( StringUtils.equalsIgnoreCase("PAPER", fileGrpId) ) {
    		postfix = "Paper";
    	}
    	else if ( StringUtils.equalsIgnoreCase("SCHMGMT", fileGrpId) ) {
    		postfix = "Schmgmt";
    	}
    	return postfix;
	}

	/**
	 * 업무구분별로 첨부파일매핑 정보를 각 매핑테이블에 등록함
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-15 19:34:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertFileMapByType(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
		if ( log.isDebugEnabled() ) {
			log.debug("<<<첨부파일매핑등록>>> 입력파라미터 정보 : " + requestData.getFieldMap());
		}

	    String fileGrpId = requestData.getField("FILE_GRP_ID");
	    String qid = "DFILEMAP.dInsertFile" + this.getPostfix(fileGrpId);
    	log.info("<<<첨부파일매핑등록>>> 파일그룹ID(업무구분) : '" + fileGrpId + "', 쿼리ID : '" + qid + "'");

	    int result = dbInsert(qid, requestData.getFieldMap(), onlineCtx);
	    responseData.putField("result", result);

	    return responseData;
	}

	/**
	 * 업무구분별로 첨부파일 매핑정보를 삭제함
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-15 19:36:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteFileMapByType(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
		if ( log.isDebugEnabled() ) {
			log.debug("<<<첨부파일매핑삭제>>> 입력파라미터 정보 : " + requestData.getFieldMap());
		}

	    String fileGrpId = requestData.getField("FILE_GRP_ID");
	    String qid = "DFILEMAP.dDeleteFile" + this.getPostfix(fileGrpId);
    	log.info("<<<첨부파일매핑삭제>>> 파일그룹ID(업무구분) : '" + fileGrpId + "', 쿼리ID : '" + qid + "'");

	    int result = dbInsert(qid, requestData.getFieldMap(), onlineCtx);
	    responseData.putField("result", result);

	    return responseData;
	}

}
