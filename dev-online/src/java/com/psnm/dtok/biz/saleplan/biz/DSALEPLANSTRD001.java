package com.psnm.dtok.biz.saleplan.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: DSALEPLANSTRD001</li>
 * <li>설  명 : 영업계획기준관리 DU</li>
 * <li>작성일 : 2015-01-29 10:39:13</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class DSALEPLANSTRD001 extends nexcore.framework.coreext.pojo.biz.DataUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public DSALEPLANSTRD001(){
		super();
	}

	/**
	 * 영업계획기준관리상품유형 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-29 14:45:28
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSalePlanStrdProd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DSALEPLANSTRD001.dSearchSalePlanStrdProd", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 영업계획기준관리상품유형 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-29 14:46:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertSalePlanStrdProd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DSALEPLANSTRD001.dInsertSalePlanStrdProd", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 영업계획기준관리상품유형 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-29 14:47:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteSalePlanStrdProd(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DSALEPLANSTRD001.dDeleteSalePlanStrdProd", requestData.getFieldMap(), onlineCtx); 
	
	    return responseData;
	}

	/**
	 * 영업계획기준관리기준제목 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-29 14:47:36
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dSearchSalePlanStrdCtt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    IRecordSet rs = dbSelect("DSALEPLANSTRD001.dSearchSalePlanStrdCtt", requestData.getFieldMap(), onlineCtx);
		responseData.putRecordSet("ds", rs);
	
	    return responseData;
	}

	/**
	 * 영업계획기준관리기준제목 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-29 14:48:02
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dInsertSalePlanStrdCtt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbInsert("DSALEPLANSTRD001.dInsertSalePlanStrdCtt", requestData.getFieldMap(), onlineCtx);
	
	    return responseData;
	}

	/**
	 * 영업계획기준관리기준제목 정보를 삭제하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-01-29 14:48:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet dDeleteSalePlanStrdCtt(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    dbUpdate("DSALEPLANSTRD001.dDeleteSalePlanStrdCtt", requestData.getFieldMap(), onlineCtx); 
	
	    return responseData;
	}
  
}
