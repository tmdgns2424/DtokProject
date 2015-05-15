package com.psnm.dtok.batch;

import java.math.BigDecimal;
import java.util.Map;

import nexcore.framework.bat.IBatchContext;

import org.apache.commons.logging.Log;

import nexcore.framework.bat.base.AbsBatchComponent;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/배치</li>
 * <li>서브 업무명 : CLEARIDINFO</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-05-12 15:47:10</li>
 * <li>작성자 : 허용 (06476)</li>
 * </ul>
 */
public class CLEARIDINFO extends AbsBatchComponent {
    private Log log;
    private BigDecimal batchJobSeq;    
    public CLEARIDINFO() {
        super();
    }

    /**
     * 배치 전처리 메소드. 
     * 여기서 Exception 발생시 execute() 메소드는 실행되지 않고, afterExecute() 는 실행됨
     */
    public void beforeExecute(IBatchContext context) {
		log = getLog(context);
		
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
    		param.put("JOB_BATCH_NM", "P&G적용");
    		int insJob = dbInsert("dInsertBatchJobLog", param, context);
    		
    		txCommit();
    		txBegin();
    		
    		/*1.사용자*/    		    		
			int num1 = dbUpdate("dUpdateDsmUser",     param, context);
			msg +="에이전트지원 : " + num1 + "건";
			/*2.회원가입요청*/    		    		
			int num2 = dbUpdate("dUpdateScrbReq",     param, context);
			msg +="회원가입요청 : " + num2 + "건";
			/*3.에이전트지원*/    		    		
			int num3 = dbUpdate("dUpdateAgentCntrt",     param, context);
			msg +="에이전트지원 : " + num3 + "건";
			/*4.지원상담*/    		    		
			int num4 = dbUpdate("dDeleteAplcnsl",     param, context);
			msg +="지원상담 : " + num4 + "건";
			/*5.고객민원*/    		    		
			int num5 = dbUpdate("dUpdateCustPgcv",     param, context);
			msg +="고객민원 : " + num5 + "건";
			/*6.비정상영업소명*/    		    		
			int num6 = dbUpdate("dUpdateScrbClm",     param, context);
			msg +="비정상영업소명 : " + num6 + "건";
			/*7.미비서류접수*/    		    		
			int num7 = dbUpdate("dUpdateInmpDoc",     param, context);
			msg +="미비서류접수 : " + num7 + "건";
			/*8.임직원 로그인삭제*/
			int num9 = dbUpdate("dDeleteDsmApprove",     param, context);
			msg +="임직원로그인삭제 : " + num9 + "건";			
			/*9.임직원 권한말소*/
			int num8 = dbUpdate("dUpdateDutyHst",     param, context);
			msg +="임직원권한말소 : " + num8 + "건";			
	
			
    		// 배치로그 UPDATE
    		param.put("JOB_SUSS_YN", "Y"); //작업성공여부(Y:성공, N:실패)
    		param.put("ERR_MSG", msg); //에러메세지
    		int updJob = dbUpdate("dUpdateBatchJobLog", param, context);    		
			


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
	    		param.put("CONTEXT", "P&G 적용 오류");
	    		
	    		int msgCnt = dbInsert("dInsertSmsTran", param, context);
	    		msgCnt = dbInsert("dInsertSmsTranDtl", param, context);
	    		
	    		param.put("SND_MSG", "P&G 적용 오류");
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
        if (super.exceptionInExecute == null) {
            // execute() 정상인 경우
            
        }else {
            // execute() 에서 에러 발생할 경우
            
        }
    }

}
