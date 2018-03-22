/**
 * Copyright (C), 杭州中恒云能源互联网技术有限公司，保留所有权利
 */
package com.ape.autocode.base;

import com.ioe.common.domain.DataResult;
import com.ioe.fee.utils.CommonUtils;
import com.ioe.stat.annotation.Stat;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import java.util.List;

/**
 * @auther qiys@hzzh.com
 * @date 2018-03-20
 */
public abstract class BaseServiceImpl implements BaseService {

    protected Logger logger = LoggerFactory.getLogger(this.getClass());

    /**
     * 改变量主要为了实现不同的子类能够拥有不同的类型Dao对象
     */
    protected BaseDao dao;

    @Stat
    @Transactional(rollbackFor = Exception.class)
    public DataResult<Integer> updateAvailDataFlag(List<String> ids, int flag, String _accountId) {
        DataResult<Integer> result = new DataResult<Integer>();
        if (CommonUtils.isEmpty(ids) || flag < 0) {
            result.setCode("1");
            result.setMessage("1");
            return result;
        }
        try {
            checkDao();
            int updateCount = dao.updateAvailDataFlag(ids, flag);
            result.setData(updateCount);
        } catch (Exception e) {
            logger.error("updateAvailDataFlag error:{}", e.getMessage());
            result.setCode("1");
            result.setMessage("1");
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return result;
    }

    private void checkDao() {
        if (dao == null) {
            setDao();
            if (dao == null) {
                throw new NullPointerException(
                        "field 'dao' is null, can not execute updateAvailDataFlag");
            }
        }
    }

    protected abstract void setDao();
}
