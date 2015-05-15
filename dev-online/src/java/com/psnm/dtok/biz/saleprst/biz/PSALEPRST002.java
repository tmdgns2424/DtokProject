package com.psnm.dtok.biz.saleprst.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: PSALEPRST002</li>
 * <li>설  명 : [PU]메인영업현황</li>
 * <li>작성일 : 2015-02-10 16:38:05</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class PSALEPRST002 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PSALEPRST002(){
		super();
	}

	/**
	 * [PM]판매우수MA현황조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-10 16:42:51
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchBestMa(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		try {
			FSALEPRST002 fu = (FSALEPRST002) lookupFunctionUnit(FSALEPRST002.class);
			responseData = fu.fSearchBestMa(requestData, onlineCtx);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}

	/**
	 * [PM]판매우수팀장현황조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-11 10:18:15
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchBestTeam(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		try {
			FSALEPRST002 fu = (FSALEPRST002) lookupFunctionUnit(FSALEPRST002.class);
			responseData = fu.fSearchBestTeam(requestData, onlineCtx);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}

	/**
	 * [PM]담보기간만료예정현황조회(메인용)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-11 10:34:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchMrtgExpir(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FSALEPRST002 fu = (FSALEPRST002) lookupFunctionUnit(FSALEPRST002.class);
			responseData = fu.fSearchMrtgExpir(requestData, onlineCtx);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}

	/**
	 * PM : 영업국별 판매 순위를 조회한다.
	 *
	 * @author 채수윤 (chesuyun)
	 * @since 2015-02-10 16:38:05
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchHeadqSaleRnk(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		try {
			FSALEPRST002 fu = (FSALEPRST002) lookupFunctionUnit(FSALEPRST002.class);
			responseData = fu.fSearchHeadqSaleRnk(requestData, onlineCtx);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		return responseData;
	}
  
}
