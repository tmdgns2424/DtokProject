package com.psnm.dtok.com.phrs.biz;

import java.util.Map;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.lang.StringUtils;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FPHRS001</li>
 * <li>설 명 : 명언관리FU</li>
 * <li>작성일 : 2015-01-05 15:17:32</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 * 
 * @author 이승훈2 (gunyoung)
 */
public class FPHRS001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FPHRS001() {
		super();
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-05 15:17:32
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchPhrs(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {

			DPHRS001 du = (DPHRS001) lookupDataUnit(DPHRS001.class);

			responseData = du.dSearchPhrs(requestData, onlineCtx); // 전체데이터 가져옴

			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

		return responseData;
	}

	/**
	 * 11111 111**
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-01-05 18:09:291
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSavePhrs(IDataSet requestData, IOnlineContext onlineCtx) {

		IDataSet responseData = new DataSet();

		try {
			DPHRS001 du = (DPHRS001) lookupDataUnit(DPHRS001.class);
			IRecordSet list = requestData.getRecordSet("gridphrs");
			int listCount = null == list ? 0 : list.getRecordCount();
			for (int i = 0; i < listCount; i++) {
				Map<String, Object> record = list.getRecordMap(i);
				IDataSet dsParam = new DataSet();
				dsParam.putFieldMap(record);

				String flag = (String) record.get("FLAG");

				if (StringUtils.equals(flag, "U")) { // 갱신
					du.dSavePhrs(dsParam, onlineCtx);
				}
			}

			responseData.setOkResultMessage("PSNM-I000", null);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		return responseData;
	}

}
