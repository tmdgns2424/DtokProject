package com.psnm.dtok.biz.smsmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: [PU]SMS관리</li>
 * <li>설 명 :</li>
 * <li>작성일 : 2015-02-11 14:59:56</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 * 
 * @author 이승훈2 (gunyoung)
 */
public class PSMSMGMT001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PSMSMGMT001() {
		super();
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-12 13:05:33
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchSmsMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {

			FSMSMGMT001 fu = (FSMSMGMT001) lookupFunctionUnit(FSMSMGMT001.class);
			responseData = fu.fSearchSmsMgmt(requestData, onlineCtx);

			IRecordSet rs = responseData.getRecordSet("ds");
			responseData.putRecordSet("grid", rs);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-11 14:59:56
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchMsgGrp(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			
			FSMSMGMT001 fu = (FSMSMGMT001) lookupFunctionUnit(FSMSMGMT001.class);
			responseData = fu.fSearchMsgGrp(requestData, onlineCtx);

			IRecordSet rs = responseData.getRecordSet("ds");
			responseData.putRecordSet("resultList", rs);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-11 14:59:56
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchHPart(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {

			FSMSMGMT001 fu = (FSMSMGMT001) lookupFunctionUnit(FSMSMGMT001.class);
			responseData = fu.fSearchHPart(requestData, onlineCtx);
			IRecordSet rs = responseData.getRecordSet("ds");
			
			responseData.putRecordSet("resultList", rs);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-11 14:59:56
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveSmsSnd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {

			FSMSMGMT001 fu = (FSMSMGMT001) lookupFunctionUnit(FSMSMGMT001.class);
			responseData = fu.fSaveSmsSnd(requestData, onlineCtx);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-11 14:59:56
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteSmsSnd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {

			FSMSMGMT001 fu = (FSMSMGMT001) lookupFunctionUnit(FSMSMGMT001.class);
			fu.fDeleteSmsSnd(requestData, onlineCtx);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-24 15:25:11
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchHTeam(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {

			FSMSMGMT001 fu = (FSMSMGMT001) lookupFunctionUnit(FSMSMGMT001.class);
			responseData = fu.fSearchHTeam(requestData, onlineCtx);
			IRecordSet rs = responseData.getRecordSet("ds");
			responseData.putRecordSet("resultList", rs);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-11 14:59:56
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchDuty(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			
			FSMSMGMT001 fu = (FSMSMGMT001) lookupFunctionUnit(FSMSMGMT001.class);
			responseData = fu.fSearchDuty(requestData, onlineCtx);
			IRecordSet rs = responseData.getRecordSet("ds");
			responseData.putRecordSet("resultList", rs);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-27 10:51:27
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {

			FSMSMGMT001 fu = (FSMSMGMT001) lookupFunctionUnit(FSMSMGMT001.class);
			responseData = fu.fSearchUser(requestData, onlineCtx);
			IRecordSet rs = responseData.getRecordSet("ds");
			responseData.putRecordSet("userListgrid", rs);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-03 10:20:35
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSndMessage(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {

			FSMSMGMT001 fu = (FSMSMGMT001) lookupFunctionUnit(FSMSMGMT001.class);
			responseData = fu.fSndMessage(requestData, onlineCtx);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-03 16:08:58
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchDeptUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {

			FSMSMGMT001 fu = (FSMSMGMT001) lookupFunctionUnit(FSMSMGMT001.class);
			responseData = fu.fSearchDeptUser(requestData, onlineCtx);
			IRecordSet rs = responseData.getRecordSet("ds");
			responseData.putRecordSet("userListgrid", rs);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-11 14:59:56
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchMsgCount(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			
			FSMSMGMT001 fu = (FSMSMGMT001) lookupFunctionUnit(FSMSMGMT001.class);
			responseData = fu.fSearchMsgCount(requestData, onlineCtx);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-04 15:42:18
	 * 
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx 요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchReCount(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {

			FSMSMGMT001 fu = (FSMSMGMT001) lookupFunctionUnit(FSMSMGMT001.class);
			responseData = fu.fSearchReCount(requestData, onlineCtx);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-20 14:49:38
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchDutySMgtm(IDataSet requestData, IOnlineContext onlineCtx) {
		

		IDataSet responseData = new DataSet();

		try {
			
			FSMSMGMT001 fu = (FSMSMGMT001) lookupFunctionUnit(FSMSMGMT001.class);
			responseData = fu.fSearchDutySMgtm(requestData, onlineCtx);
			IRecordSet rs = responseData.getRecordSet("ds");
			responseData.putRecordSet("resultList", rs);
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		
		

		return responseData;
	}
}
