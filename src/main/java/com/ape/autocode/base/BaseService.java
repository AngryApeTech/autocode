package com.ape.autocode.base;

import com.ioe.common.domain.DataResult;

import java.util.List;

/**
 * @auther qiys@hzzh.com
 * @date 2018-03-20
 */
public interface BaseService {

    /**
     * 设置数据是否用于可用性检测的标识
     *
     * @param ids  主键
     * @param flag 是否用于可用性检测，0：否（default），1：是
     * @return
     */
    DataResult<Integer> updateAvailDataFlag(List<String> ids, int flag, String _accountId);

}
