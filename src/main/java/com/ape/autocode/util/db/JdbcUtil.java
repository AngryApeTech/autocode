package com.ape.autocode.util.db;

import com.ape.autocode.entity.ColumnMeta;
import com.ape.autocode.entity.IndexMeta;
import com.ape.autocode.entity.TableMeta;
import com.ape.autocode.util.CommonUtils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import static com.ape.autocode.util.db.DBConfig.*;

/**
 * @auther qiys@hzzh.com
 * @date 2018-03-15
 */
public class JdbcUtil {

    /**
     * 获取数据库连接
     *
     * @param properties 包含连接配置信息
     * @return
     * @throws Exception
     */
    public static Connection getConnection(Properties properties) throws Exception {
        Class.forName((String) properties.get(DRIVER));
        String url = (String) properties.get(URL);
        String user = (String) properties.get(USER);
        String password = (String) properties.get(PASSWORD);
        return DriverManager.getConnection(url, user, password);
    }

    /**
     * 从元数据中读取表信息
     *
     * @param res resultSet
     * @return List<TableMeta>
     */
    public static List<TableMeta> parseTables(ResultSet res) {
        List<TableMeta> tableMetas = new ArrayList<>();
        try {
            while (res.next()) {
                String tableName = res.getString("TABLE_NAME");
                String remarks = res.getString("REMARKS").replace("\r\n", "\t");
                //截取掉前缀“t_xxx_”
                String entityName = JdbcUtil
                        .parseCamelNameInitUpper(tableName.substring(tableName.indexOf('_', 2) + 1));
                TableMeta table = new TableMeta(tableName, entityName, remarks);
                tableMetas.add(table);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tableMetas;
    }

    /**
     * 从元数据中读取字段信息
     *
     * @param res resultSet
     */
    public static List<ColumnMeta> parseColumns(ResultSet res) {
        List<ColumnMeta> columns = new ArrayList<>();
        try {
            while (res.next()) {
                String columnName = res.getString("COLUMN_NAME");
                String dataType = res.getString("TYPE_NAME");
                String remarks = res.getString("REMARKS").replace("\r\n", "\t");
                String defaultVal = res.getString("COLUMN_DEF");
                ColumnMeta column = new ColumnMeta(columnName, dataType,
                        parseCamelNameInitLower(columnName), remarks, jdbc2JavaType(dataType), defaultVal);
                columns.add(column);
                //                res.getMetaData().getColumnClassName()
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return columns;
    }

    /**
     * 从元数据中读取主键信息
     *
     * @param res resultSet
     * @return
     */
    public static List<ColumnMeta> parseKeys(ResultSet res, List<ColumnMeta> columns) {
        List<ColumnMeta> keys = new ArrayList<>();
        try {
            List<String> temp = new ArrayList<>();
            while (res.next()) {
                String key = res.getString("COLUMN_NAME"); //列名
                String seq = res.getString("KEY_SEQ"); //顺序
                temp.add(seq + ":" + key);
            }
            if (CommonUtils.isEmpty(temp)) {
                return Collections.emptyList();
            }
            Collections.sort(temp);
            for (String s : temp) {
                for (ColumnMeta column : columns) {
                    if (column.getColumnName().equals(s.split(":")[1])) {
                        keys.add(column);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return keys;
    }

    public static List<IndexMeta> parseIndexes(String tableName, ResultSet res, List<ColumnMeta> columns) {
        List<IndexMeta> indexes = new ArrayList<>();
        Map<String, List<String>> indexMap = new HashMap<>();
        try {
            while (res.next()) {
                String indexName = res.getString("INDEX_NAME"); //索引名称
                if (indexName.equals("PRIMARY"))
                    continue;
                String columnName = res.getString("COLUMN_NAME"); //列名
                String ordinal = res.getString("ORDINAL_POSITION"); //列序号
                CommonUtils.addMapList(indexMap, indexName, ordinal + ":" + columnName);
            }
            if (CommonUtils.isEmpty(indexMap)) {
                return Collections.emptyList();
            }
            indexMap.forEach((k, v) -> {
                Collections.sort(v);
                IndexMeta index = new IndexMeta();
                index.setName(k);
                index.setTableName(tableName);
                index.setColumns(new ArrayList<>());
                v.forEach(ic -> columns.stream()
                        .filter(c -> c.getColumnName().equals(ic.split(":")[1]))
                        .forEach(index::addColumn));
                indexes.add(index);
            });
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return indexes;
    }

    /**
     * 将以下划线分隔的字符串转为以驼峰命名的字符串（首字母大写）
     *
     * @param str 原始字符串
     * @return
     */
    public static String parseCamelNameInitUpper(String str) {
        StringBuffer sb = new StringBuffer();
        sb.append(str);
        int count = sb.indexOf("_");
        while (count != 0) {
            int num = sb.indexOf("_", count);
            count = num + 1;
            if (num != -1) {
                char ss = sb.charAt(count);
                char ia = (char) (ss - 32);
                sb.replace(count, count + 1, ia + "");
            }
        }
        String result = sb.toString().replaceAll("_", "");
        return CommonUtils.capitalize(result);
    }

    /**
     * 将以下划线分隔的字符串转为以驼峰命名的字符串（首字母小写）
     *
     * @param str 原始字符串
     * @return
     */
    public static String parseCamelNameInitLower(String str) {
        String temp = parseCamelNameInitUpper(str);
        return temp.substring(0, 1).toLowerCase() + temp.substring(1);
    }

    public static String jdbc2JavaType(String jdbcType) {
        switch (jdbcType) {
            case "CHAR":
            case "VARCHAR":
            case "LONGVARCHAR":
                return "String";
            case "NUMERIC":
            case "DECIMAL":
                return "java.math.BigDecimal";
            case "BIT":
                return "Boolean";
            case "TINYINT":
            case "SMALLINT":
            case "INTEGER":
                return "Integer";
            case "BIGINT":
                return "Long";
            case "REAL":
                return "Float";
            case "FLOAT":
            case "DOUBLE":
                return "Double";
            case "BINARY":
            case "VARBINARY":
            case "LONGVARBINARY":
                return "byte[]";
            case "DATE":
            case "TIME":
            case "TIMESTAMP":
                return "java.util.Date";
        }
        return "String";
    }

    public static void main(String[] args) {
        System.out.println(parseCamelNameInitUpper("t_busi_alarm_rule"));
        System.out.println(parseCamelNameInitLower("t_busi_alarm_rule"));
    }

}
