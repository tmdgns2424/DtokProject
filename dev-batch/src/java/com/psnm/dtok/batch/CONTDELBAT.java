package com.psnm.dtok.batch;

import java.math.BigDecimal;
import java.util.Map;

import nexcore.framework.bat.IBatchContext;

import org.apache.commons.logging.Log;

import nexcore.framework.bat.base.AbsBatchComponent;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/배치</li>
 * <li>서브 업무명 : CONTDELBAT</li>
 * <li>설  명 : 공지사항, 영업정책, 주요일정, 커뮤니티 게시판 자동 게시글 삭제 기능</li>
 * <li>작성일 : 2015-04-03 17:34:54</li>
 * <li>작성자 : 채수윤 (chesuyun)</li>
 * </ul>
 */
public class CONTDELBAT extends AbsBatchComponent {
    private Log log;
    private BigDecimal batchJobSeq;
    
    public CONTDELBAT() {
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
    		
    		//##################################################################################
    		// 공지사항 삭제
    		//##################################################################################
    		// 작업SEQ 채번
    		batchJobSeq = dbSelectSingle("dSelectBatchJobSeq", param, context).getBigDecimal("BATCH_JOB_SEQ");
    		if (log.isDebugEnabled()) log.debug("####################### batchJobSeq = " + batchJobSeq);

    		// 배치로그 INSERT
    		param.put("BATCH_JOB_SEQ", String.valueOf(batchJobSeq));
    		param.put("JOB_BATCH_NM", "공지사항 삭제");
    		int insJob = dbInsert("dInsertBatchJobLog", param, context);

    		txCommit();
    		txBegin();
    		
    		// 1. 첨부파일 삭제
    		int atchFileCnt = dbDelete("dDeleteAnnceAtchFile", param, context);
    		msg +="공지사항 첨부파일 삭제 : " + atchFileCnt + "건";
    		// 2. 첨부파일관리 삭제 
    		int atchFileMgmtCnt = dbDelete("dDeleteAnnceAtchFileMgmt", param, context);
    		msg +=", 공지사항 첨부파일관리 삭제 : " + atchFileMgmtCnt + "건";
    		// 3. 공지사항 수신조직 삭제
    		int rcvOrgCnt = dbDelete("dDeleteAnnceRcvOrg", param, context);
    		msg +=", 공지사항 수신조직 삭제 : " + rcvOrgCnt + "건";
    		// 4. 공지사항 수신권한 삭제
    		int rcvGrpCnt = dbDelete("dDeleteAnnceRcvGrp", param, context);
    		msg +=", 공지사항 수신권한 삭제 : " + rcvGrpCnt + "건";
    		// 5. 공지사항 필수확인 삭제
    		int mndtChkCnt = dbDelete("dDeleteAnnceMndtChk", param, context);
    		msg +=", 공지사항 필수확인 삭제 : " + mndtChkCnt + "건";
    		// 6. 공지사항 댓글 삭제
    		int cmntCnt = dbDelete("dDeleteAnnceCmnt", param, context);
    		msg +=", 공지사항 댓글 삭제 : " + cmntCnt + "건";
    		// 7. 공지사항 열람자 삭제
    		int readerCnt = dbDelete("dDeleteAnnceReader", param, context);
    		msg +=", 공지사항 열람자 삭제 : " + readerCnt + "건";
    		// 8. 공지사항 삭제
    		int annceCnt = dbDelete("dDeleteAnnce", param, context);
    		msg +=", 공지사항 삭제 : " + annceCnt + "건";
    		
    		// 배치로그 UPDATE
    		param.put("JOB_SUSS_YN", "Y"); //작업성공여부(Y:성공, N:실패)
    		param.put("ERR_MSG", msg); //에러메세지
    		int updJob = dbUpdate("dUpdateBatchJobLog", param, context);
    		
			txCommit();
			txBegin();
			
    		//##################################################################################
    		// 영업정책 삭제
    		//##################################################################################
    		// 작업SEQ 채번
    		batchJobSeq = dbSelectSingle("dSelectBatchJobSeq", param, context).getBigDecimal("BATCH_JOB_SEQ");
    		if (log.isDebugEnabled()) log.debug("####################### batchJobSeq = " + batchJobSeq);

    		// 배치로그 INSERT
    		param.put("BATCH_JOB_SEQ", String.valueOf(batchJobSeq));
    		param.put("JOB_BATCH_NM", "영업정책 삭제");
    		insJob = dbInsert("dInsertBatchJobLog", param, context);
    		
    		txCommit();
    		txBegin();
    		
    		msg ="";
    		// 1. 첨부파일 삭제
    		atchFileCnt = dbDelete("dDeletePlcyAtchFile", param, context);
    		msg +="영업정책 첨부파일 삭제 : " + atchFileCnt + "건";
    		// 2. 첨부파일관리 삭제 
    		atchFileMgmtCnt = dbDelete("dDeletePlcyAtchFileMgmt", param, context);
    		msg +=", 영업정책 첨부파일관리 삭제 : " + atchFileMgmtCnt + "건";
    		// 3. 영업정책 수신조직 삭제
    		rcvOrgCnt = dbDelete("dDeletePlcyRcvOrg", param, context);
    		msg +=", 영업정책 수신조직 삭제 : " + rcvOrgCnt + "건";
    		// 4. 영업정책 수신권한 삭제
    		rcvGrpCnt = dbDelete("dDeletePlcyRcvGrp", param, context);
    		msg +=", 영업정책 수신권한 삭제 : " + rcvGrpCnt + "건";
    		// 5. 영업정책 댓글 삭제
    		cmntCnt = dbDelete("dDeletePlcyCmnt", param, context);
    		msg +=", 영업정책 댓글 삭제 : " + cmntCnt + "건";
    		// 6. 영업정책 열람자 삭제
    		readerCnt = dbDelete("dDeletePlcyReader", param, context);
    		msg +=", 영업정책 열람자 삭제 : " + readerCnt + "건";
    		// 7. 영업정책 삭제
    		int plcyCnt = dbDelete("dDeletePlcy", param, context);
    		msg +=", 영업정책 삭제 : " + plcyCnt + "건";
    		
    		// 배치로그 UPDATE
    		param.put("JOB_SUSS_YN", "Y"); //작업성공여부(Y:성공, N:실패)
    		param.put("ERR_MSG", msg); //에러메세지
    		updJob = dbUpdate("dUpdateBatchJobLog", param, context);    		
    		
			txCommit();

			txBegin();
    		//##################################################################################
    		// 주요일정 삭제
    		//##################################################################################
    		// 작업SEQ 채번
    		batchJobSeq = dbSelectSingle("dSelectBatchJobSeq", param, context).getBigDecimal("BATCH_JOB_SEQ");
    		if (log.isDebugEnabled()) log.debug("####################### batchJobSeq = " + batchJobSeq);

    		// 배치로그 INSERT
    		param.put("BATCH_JOB_SEQ", String.valueOf(batchJobSeq));
    		param.put("JOB_BATCH_NM", "주요일정 삭제");
    		insJob = dbInsert("dInsertBatchJobLog", param, context);

    		txCommit();
    		txBegin();
    		
    		msg ="";
    		// 1. 첨부파일 삭제
    		atchFileCnt = dbDelete("dDeleteSchAtchFile", param, context);
    		msg +="주요일정 첨부파일 삭제 : " + atchFileCnt + "건";
    		// 2. 첨부파일관리 삭제 
    		atchFileMgmtCnt = dbDelete("dDeleteSchAtchFileMgmt", param, context);
    		msg +=", 주요일정 첨부파일관리 삭제 : " + atchFileMgmtCnt + "건";
    		// 3. 주요일정 수신조직 삭제
    		rcvOrgCnt = dbDelete("dDeleteSchRcvOrg", param, context);
    		msg +=", 주요일정 수신조직 삭제 : " + rcvOrgCnt + "건";
    		// 4. 주요일정 수신권한 삭제
    		rcvGrpCnt = dbDelete("dDeleteSchRcvGrp", param, context);
    		msg +=", 주요일정 수신권한 삭제 : " + rcvGrpCnt + "건";
    		// 5. 영업정책 댓글 삭제
    		cmntCnt = dbDelete("dDeleteSchCmnt", param, context);
    		msg +=", 영업정책 댓글 삭제 : " + cmntCnt + "건";
    		// 6. 영업정책 열람자 삭제
    		readerCnt = dbDelete("dDeleteSchReader", param, context);
    		msg +=", 영업정책 열람자 삭제 : " + readerCnt + "건";
    		// 7. 주요일정 삭제
    		int schCnt = dbDelete("dDeleteSch", param, context);
    		msg +=", 주요일정 삭제 : " + schCnt + "건";
    		
    		// 배치로그 UPDATE
    		param.put("JOB_SUSS_YN", "Y"); //작업성공여부(Y:성공, N:실패)
    		param.put("ERR_MSG", msg); //에러메세지
    		updJob = dbUpdate("dUpdateBatchJobLog", param, context);    		
    		
			txCommit();
    		
			txBegin();
    		//##################################################################################
    		// 게시글 삭제
    		//##################################################################################
    		// 작업SEQ 채번
    		batchJobSeq = dbSelectSingle("dSelectBatchJobSeq", param, context).getBigDecimal("BATCH_JOB_SEQ");
    		if (log.isDebugEnabled()) log.debug("####################### batchJobSeq = " + batchJobSeq);

    		// 배치로그 INSERT
    		param.put("BATCH_JOB_SEQ", String.valueOf(batchJobSeq));
    		param.put("JOB_BATCH_NM", "게시글 삭제");
    		insJob = dbInsert("dInsertBatchJobLog", param, context);

    		txCommit();
    		txBegin();
    		
    		msg ="";
    		// 1. 첨부파일 삭제
    		atchFileCnt = dbDelete("dDeleteBltAtchFile", param, context);
    		msg +="게시글 첨부파일 삭제 : " + atchFileCnt + "건";
    		// 2. 첨부파일관리 삭제 
    		atchFileMgmtCnt = dbDelete("dDeleteBltAtchFileMgmt", param, context);
    		msg +=", 게시글 첨부파일관리 삭제 : " + atchFileMgmtCnt + "건";
    		// 3. 게시글 댓글 삭제
    		cmntCnt = dbDelete("dDeleteBltCmnt", param, context);
    		msg +=", 게시글 댓글 삭제 : " + cmntCnt + "건";
    		// 4. 게시글 열람자 삭제
    		readerCnt = dbDelete("dDeleteBltReader", param, context);
    		msg +=", 게시글 열람자 삭제 : " + readerCnt + "건";
    		// 5. 게시글 답글 삭제
    		int ansCnt = dbDelete("dDeleteBltAns", param, context);
    		msg +=", 게시글 답글 삭제 : " + ansCnt + "건";
    		// 6. 게시글 삭제
    		int bltCnt = dbDelete("dDeleteBlt", param, context);
    		msg +=", 게시글 삭제 : " + bltCnt + "건";
    		
    		// 배치로그 UPDATE
    		param.put("JOB_SUSS_YN", "Y"); //작업성공여부(Y:성공, N:실패)
    		param.put("ERR_MSG", msg); //에러메세지
    		updJob = dbUpdate("dUpdateBatchJobLog", param, context);    		
    		
			txCommit();
			
			txBegin();
    		//##################################################################################
    		// 미비서류 첨부파일 삭제
    		//##################################################################################
    		// 작업SEQ 채번
    		batchJobSeq = dbSelectSingle("dSelectBatchJobSeq", param, context).getBigDecimal("BATCH_JOB_SEQ");
    		if (log.isDebugEnabled()) log.debug("####################### batchJobSeq = " + batchJobSeq);

    		// 배치로그 INSERT
    		param.put("BATCH_JOB_SEQ", String.valueOf(batchJobSeq));
    		param.put("JOB_BATCH_NM", "미비서류 첨부파일글 삭제");
    		insJob = dbInsert("dInsertBatchJobLog", param, context);

    		txCommit();
    		txBegin();
    		
    		msg ="";
    		// 1. 첨부파일 삭제
    		// 1. 첨부파일 삭제
    		
    	    atchFileCnt = dbDelete("dDeleteIncmpDocAtchFile", param, context);
    		msg +="미비서류접수 첨부파일 삭제 : " + atchFileCnt + "건";
    		// 2. 첨부파일관리 삭제 
    		 atchFileMgmtCnt = dbDelete("dDeleteIncmpDocAtchFileMgmt", param, context);
    		msg +=", 미비서류접수 첨부파일관리 삭제 : " + atchFileMgmtCnt + "건";
    		
    		// 배치로그 UPDATE
    		param.put("JOB_SUSS_YN", "Y"); //작업성공여부(Y:성공, N:실패)
    		param.put("ERR_MSG", msg); //에러메세지
    		updJob = dbUpdate("dUpdateBatchJobLog", param, context);    		
    		
			txCommit();			
			
    	}
    	catch (Exception e) {
    		txRollback();
    		
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
	    		param.put("CONTEXT", "미비서류 첨부파일 오류");
	    		
	    		int msgCnt = dbInsert("dInsertSmsTran", param, context);
	    		msgCnt = dbInsert("dInsertSmsTranDtl", param, context);
	    		
	    		param.put("SND_MSG", "미비서류 첨부파일 오류");
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
