package com.psnm.dtok.com.menu.biz;

import java.util.Map;

import org.apache.commons.logging.Log;

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
 * <li>단위업무명: PUSERMENUAUTH001</li>
 * <li>설  명 : [PU]사용자메뉴권한관리</li>
 * <li>작성일 : 2015-01-26 17:11:12</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class PUSERMENUAUTH001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PUSERMENUAUTH001(){
		super();
	}

	/**
	 * [PM]사용자메뉴권한조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-26 17:14:16
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchUserMenuAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FUSERMENUAUTH001 fu = (FUSERMENUAUTH001) lookupFunctionUnit(FUSERMENUAUTH001.class);
			responseData = fu.fSearchUserMenuAuth(requestData, onlineCtx);
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
	 * [PM]사용자메뉴권한저장
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-28 16:36:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveUserMenuAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FUSERMENUAUTH001 fu = (FUSERMENUAUTH001) lookupFunctionUnit(FUSERMENUAUTH001.class);
			responseData = fu.fSaveUserMenuAuth(requestData, onlineCtx);
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
