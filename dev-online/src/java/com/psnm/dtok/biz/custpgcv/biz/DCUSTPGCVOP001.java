package com.psnm.dtok.biz.custpgcv.biz;

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
 * <li>단위업무명: [DU]고객민원처리관리</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-02-11 10:20:47</li>
 * <li>작성자 : 안진갑 (ahnjingap)</li>
 * </ul>
 *
 * @author 안진갑 (ahnjingap)
 */
public class DCUSTPGCVOP001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DCUSTPGCVOP001(){
		super();
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-11 10:23:44
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dUpdateCustPgcvOp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    dbUpdate("DCUSTPGCVOP001.dUpdateCustPgcvOp", requestData.getFieldMap(), onlineCtx);
	    
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-11 10:24:14
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteCustPgcvOp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    dbDelete("DCUSTPGCVOP001.dDeleteCustPgcvOp", requestData.getFieldMap(), onlineCtx);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-11 10:24:42
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertCustPgcvOp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    String OP_SEQ = (String)dbInsertAndReturnPK("DCUSTPGCVOP001.dInsertCustPgcvOp", requestData.getFieldMap(), onlineCtx);
	    responseData.putField("OP_SEQ", OP_SEQ);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-11 10:32:17
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchCustPgcvOp(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		IRecordSet rs = dbSelect("DCUSTPGCVOP001.dSearchCustPgcvOp", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("gridCustPgcvOp", rs);	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-02-11 15:20:03
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchCustPgcvOpDtl(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
		IRecord record = dbSelectSingle("DCUSTPGCVOP001.dSearchCustPgcvOp", requestData.getFieldMap(), onlineCtx);
		responseData.putFieldMap(record);
	    return responseData;
	}
  
}
