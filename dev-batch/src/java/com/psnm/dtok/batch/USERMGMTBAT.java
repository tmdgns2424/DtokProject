package com.psnm.dtok.batch;

import java.math.BigDecimal;
import java.util.Map;

import nexcore.framework.bat.IBatchContext;

import org.apache.commons.logging.Log;

import nexcore.framework.bat.base.AbsBatchComponent;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/배치</li>
 * <li>서브 업무명 : USERMGMTBAT</li>
 * <li>설  명 : DSM사용자중 해촉된 사용자의 상태변경과 이력등록을 처리</li>
 * <li>작성일 : 2015-03-17 15:58:06</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 */
public class USERMGMTBAT extends AbsBatchComponent {
    private Log log;
//    private long startMillis;
//    private long endMillis;
    private BigDecimal batchJobSeq;
    
    public USERMGMTBAT() {
        super();
    }

    /**
     * 배치 전처리 메소드. 
     * 여기서 Exception 발생시 execute() 메소드는 실행되지 않고, afterExecute() 는 실행됨
     */
    public void beforeExecute(IBatchContext context) {
		log = getLog(context);
//		startMillis = System.currentTimeMillis();
    }

    /**
     * 배치 메인 메소드
     */
    public void execute(final IBatchContext context) {
    	Map<String, String> param = context.getInParameters();
    	String msg = "";
    	
    	try {
        	txBegin();
        	
    		// 작업SEQ 채번
    		batchJobSeq = dbSelectSingle("dSelectBatchJobSeq", param, context).getBigDecimal("BATCH_JOB_SEQ");
    		if (log.isDebugEnabled()) log.debug("####################### batchJobSeq = " + batchJobSeq);
    		
    		// 배치로그 INSERT
    		param.put("BATCH_JOB_SEQ", String.valueOf(batchJobSeq));
    		param.put("JOB_BATCH_NM", "사용자상태관리");
    		int insJob = dbInsert("dInsertBatchJobLog", param, context);
    		
    		txCommit();
    		txBegin();
    		
    		
			int num2 = dbInsert("dInsertRetiredUserHist", param, context);
			msg +=", 해촉사용자 상태갱신 이력 등록 : " + num2 + "건";
			    		    		
			int num1 = dbUpdate("dUpdateRetiredUser",     param, context);
			msg +="해촉사용자 상태 갱신 : " + num1 + "건";

			int num4 = dbUpdate("dUpdateRetiredUserScrb",     param, context);
			msg +="해촉사용자 회원가입요청 상태 갱신 : " + num4 + "건";
			

//			int num3 = dbUpdate("dUpdateRetiredOldUser",  param, context);
//			msg +=", 오래된 해촉사용자 개인정보 NULL 처리 : " + num3 + "건";

    		// 배치로그 UPDATE
    		param.put("JOB_SUSS_YN", "Y"); //작업성공여부(Y:성공, N:실패)
    		param.put("ERR_MSG", msg); //에러메세지
    		int updJob = dbUpdate("dUpdateBatchJobLog", param, context);    		
			
//			log.debug("배치작업완료 : 사용자상태관리 : 1. 해총사용자상태갱신(건수) = " + num1);
//			log.debug("배치작업완료 : 사용자상태관리 : 2. 해총사용자이력등록(건수) = " + num2);
//			log.debug("배치작업완료 : 사용자상태관리 : 3. 오래된 해총사용자 빈값으로 갱신(건수) = " + num3);

			txCommit();
		}
    	catch (Exception e) {
    		txRollback();
//    		log.error("배치작업오류 : 사용자상태관리 : " + e.getMessage());
    		
    		try {
    			txBegin();
    			
	    		param.put("JOB_SUSS_YN", "N"); //작업성공여부(Y:성공, N:실패)
	    		param.put("ERR_MSG", e.getMessage()); //에러메세지
	    		int updJob = dbUpdate("dUpdateBatchJobLog", param, context);

				txCommit();
				txBegin();

	    		BigDecimal smsTranSeq = dbSelectSingle("dSelectSmsTranSeq", param, context).getBigDecimal("TRAN_CNT");
	    		BigDecimal telnkCmpMsgId = dbSelectSingle("dSelectSmsCmpMsgSeq", param, context).getBigDecimal("CMP_MSG_ID");
	    		if (log.isDebugEnabled()) log.debug("####################### TRAN_CNT = " + smsTranSeq + ", CMP_MSG_ID = "+ telnkCmpMsgId);
	    		
	    		param.put("TRAN_CNT", String.valueOf(smsTranSeq));
	    		param.put("CMP_MSG_ID", String.valueOf(telnkCmpMsgId));
	    		param.put("CONTEXT", "사용자상태관리 작업 오류");
	    		
	    		int msgCnt = dbInsert("dInsertSmsTran", param, context);
	    		msgCnt = dbInsert("dInsertSmsTranDtl", param, context);
	    		
	    		param.put("SND_MSG", "사용자상태관리 작업 오류");
	    		msgCnt = dbInsert("dInsertTelinkSms", param, context);
	    		
	    		txCommit();
	    	}
	    	catch (Exception se) {
	    		txRollback();
	    	}    		
    	}
    }

    /**
     * 배치 후처리 메소드. 
     * beforeExecute(), execute() 의 Exception 발생 여부와 관계없이 이 메소드는 실행됨
     */
    public void afterExecute(IBatchContext context) {
//    	endMillis = System.currentTimeMillis();

        if (super.exceptionInExecute == null) {
            // execute() 정상인 경우
//        	log.info("배치작업완료 : 사용자상태관리 : 수행시간 = " + (endMillis-startMillis) + " (milli-second).");
        }
        else {
//        	log.error("배치작업오류 : 사용자상태관리 : " + super.exceptionInExecute.getMessage());
        }
    }

}
