package com.psnm.dtok.agn.agntmgmt.ejb;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/에이전트</li>
 * <li>설 명 : MA지원관리 및 에이전트계약관리</li>
 * <li>작성일 : 2014-11-19 16:27:14</li>
 * <li>작성자 : 한상곤 (hansanggon)</li>
 * </ul>
 *
 * @author 한상곤 (hansanggon)
 */
public class AGNTMGMTBean extends nexcore.framework.coreext.pojo.biz.OnlineBizComponent {

    /**
     * @see nexcore.framework.coreext.pojo.biz.OnlineBizComponent#getFqId()
     */
    @Override
    public String getFqId() {
        return "agn.AGNTMGMT";
    }

}
