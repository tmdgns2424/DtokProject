package com.psnm.dtok.biz.incmpdoc.ejb;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>설 명 : 미비서류접수 정보를 조회/입력/수정/삭제 하는 BC</li>
 * <li>작성일 : 2015-01-22 14:03:28</li>
 * <li>작성자 : 김지홍 (kimjihong)</li>
 * </ul>
 *
 * @author 김지홍 (kimjihong)
 */
public class INCMPDOCBean extends nexcore.framework.coreext.pojo.biz.OnlineBizComponent {

    /**
     * @see nexcore.framework.coreext.pojo.biz.OnlineBizComponent#getFqId()
     */
    @Override
    public String getFqId() {
        return "biz.INCMPDOC";
    }

}
