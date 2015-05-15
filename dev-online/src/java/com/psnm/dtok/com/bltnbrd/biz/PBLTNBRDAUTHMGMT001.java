package com.psnm.dtok.com.bltnbrd.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PBLTNBRDAUTHMGMT001</li>
 * <li>설  명 : [PU]게시판권한관리</li>
 * <li>작성일 : 2014-12-31 10:33:27</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class PBLTNBRDAUTHMGMT001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PBLTNBRDAUTHMGMT001(){
		super();
	}

	/**
	 * [PM] 적용대상권한, 적용권한, 적용대상영업국, 적용영업국 및 회원정보를 조회하여 반환
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-31 10:33:27
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAuthDeptUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FBLTNBRDAUTHMGMT001 fu = (FBLTNBRDAUTHMGMT001) lookupFunctionUnit(FBLTNBRDAUTHMGMT001.class);
			responseData = fu.fSearchAuthDeptUser(requestData, onlineCtx);
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
	 * [PM]게시판권한관리 - 사용자조회(팝업용)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-05 13:49:55
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchDeptUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FBLTNBRDAUTHMGMT001 fu = (FBLTNBRDAUTHMGMT001) lookupFunctionUnit(FBLTNBRDAUTHMGMT001.class);
			responseData = fu.fSearchDeptUser(requestData, onlineCtx);
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
	 * [PM]게시판권한저장
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-31 10:33:27
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveBrdAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FBLTNBRDAUTHMGMT001 fu = (FBLTNBRDAUTHMGMT001) lookupFunctionUnit(FBLTNBRDAUTHMGMT001.class);
			responseData = fu.fSaveBrdAuth(requestData, onlineCtx);
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
	 * [PM]게시판권한복사
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-03-23 11:20:38
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pCopyBrdAuth(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FBLTNBRDAUTHMGMT001 fu = (FBLTNBRDAUTHMGMT001) lookupFunctionUnit(FBLTNBRDAUTHMGMT001.class);
			responseData = fu.fCopyBrdAuth(requestData, onlineCtx);
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
