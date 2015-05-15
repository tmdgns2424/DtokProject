package com.psnm.dtok.com.bltnbrd.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PBLTNBRDMGMT001</li>
 * <li>설  명 : 게시판관리</li>
 * <li>작성일 : 2014-12-26 13:26:41</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class PBLTNBRDMGMT001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PBLTNBRDMGMT001(){
		super();
	}

	/**
	 * 유형별 게시판 목록 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-26 13:46:24
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchBltnBrdByType(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FBLTNBRDMGMT001 fu = (FBLTNBRDMGMT001) lookupFunctionUnit(FBLTNBRDMGMT001.class);
			responseData = fu.fSearchBltnBrdByType(requestData, onlineCtx);
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
	 * 지정된 게시판 포함 하위 게시판목록 조회(TREE형)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-26 15:12:35
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FBLTNBRDMGMT001 fu = (FBLTNBRDMGMT001) lookupFunctionUnit(FBLTNBRDMGMT001.class);
			responseData = fu.fSearchBltnBrd(requestData, onlineCtx);
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
	 * 게시판 정보 1건 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-26 16:02:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchBltnBrdByPk(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FBLTNBRDMGMT001 fu = (FBLTNBRDMGMT001) lookupFunctionUnit(FBLTNBRDMGMT001.class);
			responseData = fu.fSearchBltnBrdByPk(requestData, onlineCtx);
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
	 * [PM]게시판저장
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-01-28 10:38:40
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveBltnBrd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FBLTNBRDMGMT001 fu = (FBLTNBRDMGMT001) lookupFunctionUnit(FBLTNBRDMGMT001.class);
			responseData = fu.fSaveBltnBrd(requestData, onlineCtx);
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
	 * [PM]게시판담당자목록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-16 09:40:49
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchBltnBrdChrgr(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FBLTNBRDMGMT001 fu = (FBLTNBRDMGMT001) lookupFunctionUnit(FBLTNBRDMGMT001.class);
			responseData = fu.fSearchBltnBrdChrgr(requestData, onlineCtx);
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
	 * [PM]하위게시판목록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-16 10:18:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchBltnBrdBySup(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			FBLTNBRDMGMT001 fu = (FBLTNBRDMGMT001) lookupFunctionUnit(FBLTNBRDMGMT001.class);
			responseData = fu.fSearchBltnBrdBySup(requestData, onlineCtx);
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
