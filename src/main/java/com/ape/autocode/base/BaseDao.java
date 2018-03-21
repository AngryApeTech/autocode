package com.ape.autocode.base;

import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @auther qiys@hzzh.com
 * @date 2018-03-20
 */
public interface BaseDao {

    /**
     * 设置字段 sys_avail_data
     *
     * @param ids  记录主键
     * @param flag 是否用于可用性测试的标识，0：否，1：是
     * @return
     */
    int updateAvailDataFlag(@Param("ids") List<String> ids, @Param("flag") int flag);
}
