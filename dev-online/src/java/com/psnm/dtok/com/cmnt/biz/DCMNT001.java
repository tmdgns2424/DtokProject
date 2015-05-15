package com.psnm.dtok.com.cmnt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: DCMNT001</li>
 * <li>설  명 : 댓글관리 DU</li>
 * <li>작성일 : 2014-12-05 17:06:11</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class DCMNT001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DCMNT001(){
		super();
	}

	/**
	 * 댓글 목록을 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-05 17:09:18
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchCmnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DCMNT001.dSearchCmnt", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 댓글 목록 건수를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-05 17:12:23
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchCmntCount(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DCMNT001.dSearchCmntCount", requestData.getFieldMap(), onlineCtx);
		responseData.putField("count", rs.get(0, 0));
	
	    return responseData;
	}

	/**
	 * 댓글을 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-05 17:15:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertCmnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DCMNT001.dInsertCmnt", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 댓글을 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-05 17:17:05
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteCmnt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DCMNT001.dDeleteCmnt", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}
  
}
