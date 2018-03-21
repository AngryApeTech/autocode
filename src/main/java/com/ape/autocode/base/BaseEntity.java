/**
 * Copyright (C), 杭州中恒云能源互联网技术有限公司，保留所有权利
 */
package com.ape.autocode.base;

import java.io.Serializable;
import java.util.Date;

/**
 * @auther qiys@hzzh.com
 * @date 2018-03-19
 */
public class BaseEntity implements Serializable {

    /**
     * 创建者
     */
    private String sysCreator;

    /**
     * 创建时间
     */
    private Date sysCreateTime;

    /**
     * 更新者
     */
    private String sysUpdater;

    /**
     * 更新时间
     */
    private Date sysUpdateTime;

    /**
     * 是否删除，是否删除，0：删除（default），1：可用
     */
    private int sysDeleted;

    /**
     * 本数据是否用于可用性测试，0：否（default），1：是
     */
    private int sysAvailData;

    /**
     * 数据哈希值，用于同步和更新校验
     */
    private String sysHash;

    public String getSysCreator() {
        return sysCreator;
    }

    public void setSysCreator(String sysCreator) {
        this.sysCreator = sysCreator;
    }

    public Date getSysCreateTime() {
        return sysCreateTime;
    }

    public void setSysCreateTime(Date sysCreateTime) {
        this.sysCreateTime = sysCreateTime;
    }

    public String getSysUpdater() {
        return sysUpdater;
    }

    public void setSysUpdater(String sysUpdater) {
        this.sysUpdater = sysUpdater;
    }

    public Date getSysUpdateTime() {
        return sysUpdateTime;
    }

    public void setSysUpdateTime(Date sysUpdateTime) {
        this.sysUpdateTime = sysUpdateTime;
    }

    public int getSysDeleted() {
        return sysDeleted;
    }

    public void setSysDeleted(int sysDeleted) {
        this.sysDeleted = sysDeleted;
    }

    public int getSysAvailData() {
        return sysAvailData;
    }

    public void setSysAvailData(int sysAvailData) {
        this.sysAvailData = sysAvailData;
    }

    public String getSysHash() {
        return sysHash;
    }

    public void setSysHash(String sysHash) {
        this.sysHash = sysHash;
    }
}
