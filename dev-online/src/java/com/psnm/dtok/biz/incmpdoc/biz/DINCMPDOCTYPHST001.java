package com.psnm.dtok.biz.incmpdoc.biz;

import java.util.Map;

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
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: DINCMPDOCTYPHST001</li>
 * <li>설  명 : 미비접수 첨부유형 파일 관련 Data Unit</li>
 * <li>작성일 : 2015-01-22 15:15:14</li>
 * <li>작성자 : 김지홍 (kimjihong)</li>
 * </ul>
 *
 * @author 김지홍 (kimjihong)
 */
public class DINCMPDOCTYPHST001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DINCMPDOCTYPHST001(){
		super();
	}

	/**
	 * 미비서류접수 첨부유형이력 정보를 조회하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-22 15:15:14
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchIncmpDocTypHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	
	    return responseData;
	}

	/**
	 * 미비서류접수 첨부유형이력 정보를 추가하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-22 15:15:14
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertIncmpDocTypHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DINCMPDOCTYPHST001.dInsertIncmpDocTypHst", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 미비서류접수 첨부유형이력 정보를 삭제하는 메소드
	 *
	 * @author 김지홍 (kimjihong)
	 * @since 2015-01-22 15:15:14
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteIncmpDocTypHst(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DINCMPDOCTYPHST001.dDeleteIncmpDocTypHst", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}
  
}
