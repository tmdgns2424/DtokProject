package com.psnm.dtok.com.auth.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PAUTHINFO</li>
 * <li>설  명 : 권한그룹 관련된 각종 정보 조회</li>
 * <li>작성일 : 2014-12-24 16:59:47</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class PAUTHINFO extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PAUTHINFO(){
		super();
	}

	/**
	 * 권한그룹 메뉴목록 조회(TREE형식)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-24 17:00:27
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAuthMenu(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FAUTHINFO fu = (FAUTHINFO) lookupFunctionUnit(FAUTHINFO.class);
			responseData = fu.fSearchAuthMenu(requestData, onlineCtx);
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
	 * 권한그룹의 사용자 목록조회(P페이징)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-24 17:00:57
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAuthUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FAUTHINFO fu = (FAUTHINFO) lookupFunctionUnit(FAUTHINFO.class);
			responseData = fu.fSearchAuthUser(requestData, onlineCtx);
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
