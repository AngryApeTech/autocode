package com.ape.autocode;

/**
 * 数据库字段封装类
 * Created by AngryApe at 2017/5/3.
 */
public class ColumnMeta {

    /**
     * 数据库字段名称
     **/
    private String columnName;
    /**
     * 数据库字段类型
     **/
    private String jdbcType;
    /**
     * 数据库字段首字母小写且去掉下划线字符串
     **/
    private String fieldName;
    /**
     * 数据库字段注释
     **/
    private String comment;

    private String javaType;

    public ColumnMeta() {
    }

    public ColumnMeta(String columnName, String jdbcType, String fieldName,
            String comment,String javaType) {
        this.columnName = columnName;
        this.jdbcType = jdbcType;
        this.fieldName = fieldName;
        this.comment = comment;
        this.javaType = javaType;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getColumnName() {
        return columnName;
    }

    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    public String getJdbcType() {
        return jdbcType;
    }

    public void setJdbcType(String jdbcType) {
        this.jdbcType = jdbcType;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public String getJavaType() {
        return javaType;
    }

    public void setJavaType(String javaType) {
        this.javaType = javaType;
    }

    @Override
    public String toString() {
        return "ColumnMeta{" + "columnName='" + columnName + '\'' + ", jdbcType='" + jdbcType + '\''
                + ", fieldName='" + fieldName + '\'' + ", comment='" + comment + '\''
                + ", javaType='" + javaType + '\'' + '}';
    }
}