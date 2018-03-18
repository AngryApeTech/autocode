package com.ape.autocode.entity;

import java.util.ArrayList;
import java.util.List;

public class IndexMeta {

    /**
     * 索引名称
     */
    private String name;

    private String tableName;

    /**
     * 索引列
     */
    private List<ColumnMeta> columns;

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<ColumnMeta> getColumns() {
        return columns;
    }

    public void setColumns(List<ColumnMeta> columns) {
        this.columns = columns;
    }

    public void addColumn(ColumnMeta column) {
        if (this.columns == null) {
            this.columns = new ArrayList<>();
        }
        if (column == null) {
            return;
        }
        this.columns.add(column);
    }
}
