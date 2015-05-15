package com.psnm.dtok.com.paper.biz;

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
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: [DU]쪽지 쓰기</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-01-12 16:59:48</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 *
 * @author 이승훈2 (gunyoung)
 */
public class DRGSTPAPER001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DRGSTPAPER001(){
		super();
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-12 16:59:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSeqSelect(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		IRecordSet rs = dbSelect("DRGSTPAPER001.dSeqSelect", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);//앞에는 알로펙스값 뒤에 rs는 해당 값
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-15 13:50:02
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSaleTeam(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    IRecordSet rs = dbSelect("DRGSTPAPER001.dSearchSaleTeam", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("teamSearch", rs);//앞에는 알로펙스값 뒤에 rs는 해당 값
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-16 15:14:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dAgntList(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    IRecordSet rs = dbSelect("DRGSTPAPER001.dAgntList", requestData.getFieldMap(), onlineCtx);
	    responseData.putRecordSet("grid", rs);//앞에는 알로펙스값 뒤에 rs는 해당 값
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-16 17:28:27
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchUserPop(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    IRecordSet rs = dbSelect("DRGSTPAPER001.dSearchUserPop", requestData.getFieldMap(), onlineCtx);
	    responseData.putRecordSet("grid", rs);//앞에는 알로펙스값 뒤에 rs는 해당 값\
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-12 16:59:48
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchRead(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
        IRecordSet rs = dbSelect("DRGSTPAPER001.dSearchRead", requestData.getFieldMap(), onlineCtx);
        responseData.putRecordSet("ds", rs);//앞에는 알로펙스값 뒤에 rs는 해당 값
	    return responseData;
	}
  
}

