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
 * <li>단위업무명: [FU]매출정보</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-01-28 14:43:50</li>
 * <li>작성자 : 안진갑 (ahnjingap)</li>
 * </ul>
 *
 * @author 안진갑 (ahnjingap)
 */
public class FPOPUPSALEINFO001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FPOPUPSALEINFO001(){
		super();
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-28 14:47:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSaleInfo(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 
	    DPOPUPSALEINFO001 du = (DPOPUPSALEINFO001)lookupDataUnit(DPOPUPSALEINFO001.class);

		responseData = du.dSearchSaleInfo(requestData, onlineCtx);
		
		IRecordSet rs = responseData.getRecordSet("gridSale");
		int totalCount = 0;
		if( rs.getRecordCount() != 0 ){
			totalCount = rs.getRecord(0).getInt("COUNT");
		}
		rs.setTotalRecordCount( totalCount );
		rs.setPageNo(requestData.getIntField("page"));
		rs.setRecordCountPerPage(requestData.getIntField("page_size"));

	    return responseData;
	}
  
}
