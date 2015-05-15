package com.psnm.dtok.biz.smsmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: [FU]SMS관리</li>
 * <li>설 명 :</li>
 * <li>작성일 : 2015-02-11 15:00:23</li>
 * <li>작성자 : 이승훈2 (gunyoung)</li>
 * </ul>
 * 
 * @author 이승훈2 (gunyoung)
 */
public class FSMSMGMT001 extends
		nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FSMSMGMT001() {
		super();
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-12 13:05:59
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchSmsMgmt(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			DSMSMGMT001 du = (DSMSMGMT001) lookupDataUnit(DSMSMGMT001.class);
			if("00".equals(requestData.getField("DUTY_TYP_DT"))){
				requestData.putField("DUTY_TYP_DT", "");						
			}
			responseData = du.dSearchSmsMgmt(requestData, onlineCtx);
		
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);
		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-12 13:09:42
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMsgGrp(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {

			DSMSMGMT001 du = (DSMSMGMT001) lookupDataUnit(DSMSMGMT001.class);
			responseData = du.dSearchMsgGrp(requestData, onlineCtx);
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
	 * @since 2015-02-23 09:39:31
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchHPart(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			
			DSMSMGMT001 du = (DSMSMGMT001) lookupDataUnit(DSMSMGMT001.class);
			responseData = du.dSearchHPart(requestData, onlineCtx);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);
		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-11 15:00:23
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSaveSmsSnd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			
			DSMSMGMT001 du = (DSMSMGMT001) lookupDataUnit(DSMSMGMT001.class);
			
			//웹에서 받아온값 값 이름변경
			requestData.putField("HDQT_PART_ORG_ID", requestData.getField("HDQT_PART_CD"));
			requestData.putField("HDQT_TEAM_ORG_ID", requestData.getField("HDQT_TEAM_CD"));
			requestData.putField("USER_NM",          requestData.getField("AGNT_NM"));
			requestData.putField("STRD_CL_VAL_CD",   requestData.getField("STRD_CL_VAL_ID"));

			//기존에 등록된 데이터인지 확인(중복)
			IRecordSet rs = du.dSearchSmsMgmt(requestData, onlineCtx).getRecordSet("ds");

			//중복확인 (나온데이터가없으면 등록)
			if (rs.getRecordCount() == 0) 
				du.dInsertSmsSnd(requestData, onlineCtx);
			
			responseData.putField("count", rs.getRecordCount());
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
	 * @since 2015-02-23 15:17:07
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteSmsSnd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			IRecordSet rs = requestData.getRecordSet("grid");

			DSMSMGMT001 du = (DSMSMGMT001) lookupDataUnit(DSMSMGMT001.class);

			//그리드에서 받아온데이터 레코드셋을 조회함
			for (int i = 0; i < rs.getRecordCount(); i++) {
				IDataSet listData = new DataSet();
				listData.putFieldMap(rs.getRecordMap(i));
			//전달받은 레코드셋 FLAG가 D인것만 삭제
				if ("D".equals(listData.getField("FLAG"))) {
					du.dDeleteSmsSnd(listData, onlineCtx);
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

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-24 15:23:26
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchHTeam(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			
			DSMSMGMT001 du = (DSMSMGMT001) lookupDataUnit(DSMSMGMT001.class);
			responseData = du.dSearchHTeam(requestData, onlineCtx);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);
		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-11 15:00:23
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchDuty(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			DSMSMGMT001 du = (DSMSMGMT001) lookupDataUnit(DSMSMGMT001.class);

			responseData = du.dSearchDuty(requestData, onlineCtx);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);
		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-27 10:51:02
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			
			DSMSMGMT001 du = (DSMSMGMT001) lookupDataUnit(DSMSMGMT001.class);
			responseData = du.dSearchUser(requestData, onlineCtx);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);
		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-11 15:00:23
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSndMessage(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			// 메세지전송 requestData fields에 담겨있는데이터는  발신번호, 메세지, TRAN_SYS=""
			// recordSet에 담겨있는 데이터는 수신번호(N), 수신인(Y), 수신자ID (Y) Y는 null허용
			
			// 팀 혹은 파트로 넘어오면
			if("TPART".equals(requestData.getField("KIND"))){
				// 메세지 제한 
				String message = requestData.getField("SND_MSG");
				if(message.getBytes().length>80){
					byte[] text = message.getBytes();
					int count = 0; 
					for(int a=0; a<80; a++){
						if( text[a]<0)
							count ++;
					}
					String Snd_message ; 
					if(count%2==0) Snd_message = new String(text , 0 , 80);
					else Snd_message = new String (text , 0 , 79);
					
					requestData.putField("SND_MSG", Snd_message);
				}
			}

			IRecordSet rs = requestData.getRecordSet("sndgrid");
			requestData.putRecordSet("ds", rs);
			responseData = callSharedBizComponentByDirect("com.SHARE", "fSendSmsDirectly", requestData, onlineCtx);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);

		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-03 16:16:43
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchDeptUser(IDataSet requestData,
			IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			DSMSMGMT001 du = (DSMSMGMT001) lookupDataUnit(DSMSMGMT001.class);
			
			String[] DSM_TYP_ID = requestData.getFieldValues("DSM_TYP_ID");
			
			if(DSM_TYP_ID == null || DSM_TYP_ID.length == 0){
				requestData.putField("DSM_TYP_ID", "4");
			}

			responseData = du.dSearchDeptUser(requestData, onlineCtx);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);
		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-02-11 15:00:23
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMsgCount(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {

			DSMSMGMT001 du = (DSMSMGMT001) lookupDataUnit(DSMSMGMT001.class);
			//영업국 업무인지 영업팀엄무인지 확인 / 웹상에서 전달받은 FieldCount를 이용하여 구분
			if("team".equals(requestData.getField("auth")))
				requestData.putField("DSM_WEB_STRD_CD_VAL", "52");
			else if("dept".equals(requestData.getField("auth")))
				requestData.putField("DSM_WEB_STRD_CD_VAL", "51");

			IDataSet ds1 = du.dSearchMsgCount(requestData, onlineCtx);
			int msgcount = ds1.getIntField("STRD_APLY_VAL");

			responseData.putField("STRD_APLY_VAL", msgcount);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);
		return responseData;
	}

	/**
	 * 
	 * 
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-04 15:42:59
	 * 
	 * @param requestData
	 *            요청정보 DataSet 객체
	 * @param onlineCtx
	 *            요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchReCount(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

		try {
			DSMSMGMT001 du = (DSMSMGMT001) lookupDataUnit(DSMSMGMT001.class);

			// 넘어온전화번호 하이픈제거
//			String phon_num = requestData.getField("my_phon");
//			phon_num = phon_num.replaceAll("-", "");
			// 당해년도 가져오기
			
//			requestData.putField("SND_PHN_ID", phon_num);
			
			//월인경우 SND_DT가 NULL - 공통에서 SND_DT가 들어오지않으면 월로 계산

			//공통함수 메세지잔여 카운트 
			responseData = callSharedBizComponentByDirect("com.SHARE", "fSearchSmsCount", requestData, onlineCtx);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);

		return responseData;
	}

	/**
	 *
	 *
	 * @author 이승훈2 (gunyoung)
	 * @since 2015-03-20 14:48:14
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchDutySMgtm(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		try {
			DSMSMGMT001 du = (DSMSMGMT001) lookupDataUnit(DSMSMGMT001.class);

			responseData = du.dSearchDutySMgtm(requestData, onlineCtx);
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
		responseData.setOkResultMessage("PSNM-I000", null);
		return responseData;
	}

}
