package com.ape.autocode.entity;

/**
 * @auther qiys@hzzh.com
 * @date 2018-03-16
 */
public class TableMeta {

    /**
     * 表名
     */
    private String tableName;

    /**
     * 对应Entity名称
     */
    private String entityName;

    /**
     * 表注释
     */
    private String tableComment;

    public TableMeta() {
    }

    public TableMeta(String tableName, String entityName, String tableComment) {
        this.tableName = tableName;
        this.entityName = entityName;
        this.tableComment = tableComment;
    }

    public String getTableComment() {
        return tableComment;
    }

    public void setTableComment(String tableComment) {
        this.tableComment = tableComment;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getEntityName() {
        return entityName;
    }

    public void setEntityName(String entityName) {
        this.entityName = entityName;
    }

    @Override
    public String toString() {
        return "TableMeta{" + "tableName='" + tableName + '\'' + ", entityName='" + entityName
                + '\'' + ", tableComment='" + tableComment + '\'' + '}';
    }
}
