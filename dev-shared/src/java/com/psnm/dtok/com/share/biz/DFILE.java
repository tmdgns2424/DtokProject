package com.psnm.dtok.com.share.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DFILE</li>
 * <li>설  명 : 공통 첨부파일 정보처리 DAO 클래스</li>
 * <li>작성일 : 2014-11-12 20:34:26</li>
 * <li>작성자 : admin (admin)</li>
 * </ul>
 *
 * @author admin (admin)
 */
public class DFILE extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DFILE(){
		super();
	}

	/**
	 * 첨부파일정보 조회
	 *
	 * @author admin (admin)
	 * @since 2014-11-12 20:34:26
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchFile(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		Log log = getLog(onlineCtx);
		log.debug( requestData.getFieldMap() );

	    IRecordSet rs = dbSelect("DFILE.dSearchFile", requestData.getFieldMap(), onlineCtx);

		responseData.putRecordSet("ds", rs);

		return responseData;
	}

	/**
	 * 첨부파일정보를 등록
	 *
	 * @author admin (admin)
	 * @since 2014-11-13 09:19:52
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertFile(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    String userId = requestData.getField("USER_ID");

	    //확장자로 파일 필터링
	    String fileName = requestData.getField("FILE_NM");
	    String fileExt = fileName.substring(fileName.lastIndexOf(".")+1, fileName.length());

	    if ( StringUtils.equalsIgnoreCase(fileExt, "jsp") || StringUtils.equalsIgnoreCase(fileExt, "exe") ||
	    	 StringUtils.equalsIgnoreCase(fileExt, "class") || StringUtils.equalsIgnoreCase(fileExt, "dll") ) {

	    	Log log = getLog(onlineCtx);
			log.error("<첨부파일정보등록> <오류> 허용하지 않는 첨부파일확장자! 입력파라미터 : " + requestData.getFieldMap());
	    	throw new BizRuntimeException("MSTAE00004");
	    }

		/* (ASIS_CODE)
	    if (((StarUserInfo)onlineCtx.getUserInfo()).getCustomProp("loginId")!=null) {
			userId = ((StarUserInfo)onlineCtx.getUserInfo()).getCustomProp("loginId").toString();
	    	requestData.putField("USER_ID", userId);
		}
		*/
	    if ( StringUtils.isBlank(userId) ) {
	    	userId = "10001000";
	    }

	    dbInsert("DFILE.dInsertFile", requestData.getFieldMap(), onlineCtx);	
	
	    return responseData;
	}

	/**
	 * 첨부파일정보를 삭제
	 *
	 * @author admin (admin)
	 * @since 2014-11-13 09:20:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteFile(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    int result = dbDelete("DFILE.dDeleteFile", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}
  
}
