package com.psnm.dtok.com.share.ejb;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>설 명 : 공유공통 컴포넌트. FU, DU 로만 구성</li>
 * <li>작성일 : 2014-11-12 20:15:17</li>
 * <li>작성자 : admin (admin)</li>
 * </ul>
 *
 * @author admin (admin)
 */
public class SHAREBean extends nexcore.framework.coreext.pojo.biz.SharedBizComponent {

    /**
     * @see nexcore.framework.coreext.pojo.biz.SharedBizComponent#getFqId()
     */
    @Override
    public String getFqId() {
        return "com.SHARE";
    }

}
