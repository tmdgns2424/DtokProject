package com.psnm.dtok.biz.saleprst.biz;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;

import com.psnm.common.util.PsnmUtils;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.user.UserInfo;
import nexcore.framework.core.exception.BizRuntimeException;
import nexcore.framework.core.util.DateUtils;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: FSALEPRST002</li>
 * <li>설  명 : [FU]메인영업현황</li>
 * <li>작성일 : 2015-02-10 16:37:41</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 *
 * @author 안종광 (rhkd)
 */
public class FSALEPRST002 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

    /**
     * 이 클래스는 Singleton 객체로 수행됩니다. 
     * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
     */

    /**
     * Default Constructor
     */
    public FSALEPRST002(){
        super();
    }

    /**
     * [FM]판매우수MA현황조회
     *
     * @author 안종광 (rhkd)
     * @since 2015-02-10 16:37:41
     *
     * @param requestData 요청정보 DataSet 객체
     * @param onlineCtx   요청 컨텍스트 정보
     * @return 처리결과 DataSet 객체
     */
    public IDataSet fSearchBestMa(IDataSet requestData, IOnlineContext onlineCtx) {
        IDataSet responseData = new DataSet();
        Log log = getLog(onlineCtx);

        try {
            //1. 세션사용자정보 참조
            UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();

            String isBoundedByDept = "N";
            /*
            String dutyUserTyp = userInfo.getString("DUTY_USER_TYP"); //DUTY_USER_TYP(=asis DUTY_TYP_CD)
            String dutyCd      = userInfo.getString("DUTY");

            if ( StringUtils.equals("4", dutyUserTyp) || StringUtils.equals("14", dutyCd) ) {
                requestData.putField("SALE_DEPT_ORG_ID", userInfo.getString("SALE_DEPT_ORG_ID")); //현재세션의 영업국ID
                isBoundedByDept = "Y";
            }
            */
            if ( ! PsnmUtils.isEmployee(onlineCtx) ) { //임직원이 아니면 '소속영업국'으로 제한
            	requestData.putField("SALE_DEPT_ORG_ID", userInfo.getString("SALE_DEPT_ORG_ID")); //현재세션의 영업국ID
                isBoundedByDept = "Y";
            }
            requestData.putField("IS_BOUNDED_BY_DEPT", isBoundedByDept);

            //2. 조회기간(시작~종료) 설정 : 기준일자는 매월1일부터 전일 (현재-1일)
            String ymd = DateUtils.getCurrentDate();
            String saleDtSta = ymd.substring(0, 6).toString() + "01";
            String saleDtEnd = DateUtils.addDay(ymd, -1);

            if ( StringUtils.equals("01", ymd.substring(6, 8)) ) {
            	saleDtEnd = DateUtils.addDay(saleDtSta, -1);
            	saleDtSta = DateUtils.addMonth(saleDtSta, -1);
            	
                //saleDtEnd = saleDtSta; //오늘이 1일이면, 종료일자도 오늘로 설정함
            }

            requestData.putField("SALE_DT_STA", saleDtSta);
            requestData.putField("SALE_DT_END", saleDtEnd);

            if ( log.isDebugEnabled() ) {
                log.debug("<<판매우수MA현황조회>> 입력파라미터 : " + requestData.getFieldMap());
            }

            //3. 조회
            DSALEPRST002 du2 = (DSALEPRST002) lookupDataUnit(DSALEPRST002.class);
            IRecordSet list = du2.dSearchBestMa(requestData, onlineCtx).getRecordSet("ds");

            responseData.putRecordSet("gridbestma", list); //@see jsp(../com/popup/mainBestMaPop.jsp)
        }
        catch (BizRuntimeException be) {
            throw be;
        }
        catch (Exception e) {
            throw new BizRuntimeException("PSNM-E000", e);
        }
        responseData.setOkResultMessage("PSNM-I000", null);
        return responseData;
    }

	/**
	 * [FM]판매우수팀장현황조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-11 10:00:15
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchBestTeam(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
        Log log = getLog(onlineCtx);

        try {
            //1. 세션사용자정보 참조
            UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();

            String isBoundedByDept = "N";

            if ( ! PsnmUtils.isEmployee(onlineCtx) ) { //임직원이 아니면 '소속영업국'으로 제한
            	requestData.putField("SALE_DEPT_ORG_ID", userInfo.getString("SALE_DEPT_ORG_ID")); //현재세션의 영업국ID
                isBoundedByDept = "Y";
            }
            requestData.putField("IS_BOUNDED_BY_DEPT", isBoundedByDept);

            //2. 조회기간(시작~종료) 설정 : 기준일자는 매월1일부터 전일 (현재-1일)
            String ymd = DateUtils.getCurrentDate();
            String saleDtSta = ymd.substring(0, 6).toString() + "01";
            String saleDtEnd = DateUtils.addDay(ymd, -1);

            if ( StringUtils.equals("01", ymd.substring(6, 8)) ) {
            	saleDtEnd = DateUtils.addDay(saleDtSta, -1);
            	saleDtSta = DateUtils.addMonth(saleDtSta, -1);
            	
//                saleDtEnd = saleDtSta; //오늘이 1일이면, 종료일자도 오늘로 설정함
            }     

            requestData.putField("SALE_DT_STA", saleDtSta);
            requestData.putField("SALE_DT_END", saleDtEnd);

            if ( log.isDebugEnabled() ) {
                log.debug("<<판매우수팀장현황조회>> 입력파라미터 : " + requestData.getFieldMap());
            }

            //3. 조회
            DSALEPRST002 du2 = (DSALEPRST002) lookupDataUnit(DSALEPRST002.class);
            IRecordSet list = du2.dSearchBestTeam(requestData, onlineCtx).getRecordSet("ds");

            responseData.putRecordSet("gridbestteam", list); //@see jsp(../com/popup/mainBestTeamPop.jsp)
        }
        catch (BizRuntimeException be) {
            throw be;
        }
        catch (Exception e) {
            throw new BizRuntimeException("PSNM-E000", e);
        }
        responseData.setOkResultMessage("PSNM-I000", null);
        return responseData;
	}

	/**
	 * [FM]담보기간만료예정현황조회(메인용)
	 *
	 * @author 안종광 (rhkd)
	 * @since 2015-02-11 10:33:40
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchMrtgExpir(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
        Log log = getLog(onlineCtx);

        try {
            //1. 세션사용자정보 참조
            UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();

            String isBoundedByDept = "N"; //영업국제한
            String isBoundedByTeam = "N"; //영업팀제한

            if ( ! PsnmUtils.isEmployee(onlineCtx) ) { //임직원이 아니면 '소속영업국'으로 제한
            	requestData.putField("SALE_DEPT_ORG_ID", userInfo.getString("SALE_DEPT_ORG_ID")); //현재세션의 영업국ID
                isBoundedByDept = "Y";
            }
            if ( StringUtils.equals("16", userInfo.getString("DUTY")) ) { //16=DSM팀장
                requestData.putField("SALE_TEAM_ORG_ID", userInfo.getString("SALE_TEAM_ORG_ID")); //현재세션의 영업국ID
                isBoundedByTeam = "Y";
            }
            requestData.putField("IS_BOUNDED_BY_DEPT", isBoundedByDept);
            requestData.putField("IS_BOUNDED_BY_TEAM", isBoundedByTeam);

            if ( log.isDebugEnabled() ) {
                log.debug("<<담보기간만료예정현황조회>> 입력파라미터 : " + requestData.getFieldMap());
            }

            //3. 조회
            DSALEPRST002 du2 = (DSALEPRST002) lookupDataUnit(DSALEPRST002.class);
            IRecordSet list = du2.dSearchMrtgExpir(requestData, onlineCtx).getRecordSet("ds");

            responseData.putRecordSet("gridmrtgexpir", list); //@see jsp(../com/popup/mainMrtgExpirPop.jsp)
        }
        catch (BizRuntimeException be) {
            throw be;
        }
        catch (Exception e) {
            throw new BizRuntimeException("PSNM-E000", e);
        }
        responseData.setOkResultMessage("PSNM-I000", null);
        return responseData;
	}

	/**
	 * FM : 영업국별 판매 순위를 조회한다.
	 *
	 * @author 채수윤 (chesuyun)
	 * @since 2015-03-19 09:17:00
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchHeadqSaleRnk(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
        Log log = getLog(onlineCtx);

        try {
            //1. 세션사용자정보 참조
//            UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();

//            String isBoundedByDept = "N";
//
//            if ( ! PsnmUtils.isEmployee(onlineCtx) ) { //임직원이 아니면 '소속영업국'으로 제한
//            	requestData.putField("SALE_DEPT_ORG_ID", userInfo.getString("SALE_DEPT_ORG_ID")); //현재세션의 영업국ID
//                isBoundedByDept = "Y";
//            }
//            requestData.putField("IS_BOUNDED_BY_DEPT", isBoundedByDept);

            //2. 조회기간(시작~종료) 설정 : 기준일자는 매월1일부터 전일 (현재-1일)
            String ymd = DateUtils.getCurrentDate();
            String saleDtSta = ymd.substring(0, 6).toString() + "01";
            String saleDtEnd = DateUtils.addDay(ymd, -1);

            if ( StringUtils.equals("01", ymd.substring(6, 8)) ) {
            	saleDtEnd = DateUtils.addDay(saleDtSta, -1);
            	saleDtSta = DateUtils.addMonth(saleDtSta, -1);
            	
//                saleDtEnd = saleDtSta; //오늘이 1일이면, 종료일자도 오늘로 설정함
            }     

            requestData.putField("SALE_DT_STA", saleDtSta);
            requestData.putField("SALE_DT_END", saleDtEnd);

            if ( log.isDebugEnabled() ) {
                log.debug("<<영업국별판매순위조회>> 입력파라미터 : " + requestData.getFieldMap());
            }

            //3. 조회
            DSALEPRST002 du2 = (DSALEPRST002) lookupDataUnit(DSALEPRST002.class);
            IRecordSet list = du2.dSearchHeadqSaleRnk(requestData, onlineCtx).getRecordSet("ds");

            responseData.putRecordSet("gridbestteam", list); //@see jsp(../com/popup/mainBestTeamPop.jsp)
        }
        catch (BizRuntimeException be) {
            throw be;
        }
        catch (Exception e) {
            throw new BizRuntimeException("PSNM-E000", e);
        }
        responseData.setOkResultMessage("PSNM-I000", null);
	
	    return responseData;
	}
  
}
