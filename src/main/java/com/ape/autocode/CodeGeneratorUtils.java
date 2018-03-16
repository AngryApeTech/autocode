/**
 * Copyright (C), 杭州中恒云能源互联网技术有限公司，保留所有权利
 */
package com.ape.autocode;

import freemarker.template.Template;
import org.springframework.util.StringUtils;

import java.io.*;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.*;

/**
 * @auther qiys@hzzh.com
 * @date 2018-03-15
 */
public class CodeGeneratorUtils {

    private final String AUTHOR = "AngryApe";
    private final String CURRENT_DATE = "2017/05/03";
    private final String tableName = "t_busi_alarm";
    private final String packageName = "com.test";
    private final String tableAnnotation = "质量问题";
    private final String URL = "jdbc:mysql://10.1.170.160/assetaccount2.2?useUnicode=true&characterEncoding=utf8&allowMultiQueries=true";
    private final String USER = "cms";
    private final String PASSWORD = "Cms123";
    private final String DRIVER = "com.mysql.jdbc.Driver";
    private final String diskPath = "D://test/";
    private final String deleteColumn = "disabled";
    private final String changeTableName = replaceUnderLineAndUpperCase(tableName);

    public Connection getConnection() throws Exception {
        Class.forName(DRIVER);
        Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
        return connection;
    }

    public static void main(String[] args) throws Exception {
        CodeGeneratorUtils codeGeneratorUtils = new CodeGeneratorUtils();
        codeGeneratorUtils.generate();
    }

    public CodeGeneratorUtils() {
        init();
    }

    public void init() {
        File path = new File(diskPath);
        if (!path.exists()) {
            if (path.mkdirs()) {
                System.out.println("create path [] successfully !");
            }
        }
    }

    public void generate() throws Exception {
        try {
            Connection connection = getConnection();
            DatabaseMetaData databaseMetaData = connection.getMetaData();
            ResultSet resultSet = databaseMetaData.getColumns(null, "%", tableName, "%");
            List<ColumnMeta> columns = new ArrayList<>();
            Set<String> classes = new HashSet<>();
            JdbcUtil.parseColumns(resultSet, columns, classes);
            resultSet = databaseMetaData.getPrimaryKeys(null, null, tableName);
            String key = JdbcUtil.getKey(resultSet);
            // 构造 freemarker 变量
            Map<String, Object> dataMap = new HashMap<>();
            dataMap.put("package", packageName);
            dataMap.put("columns", columns);
            dataMap.put("tableName", tableName);
            dataMap.put("entityName", changeTableName);
            dataMap.put("keyName", key);
            dataMap.put("keyField", JdbcUtil.parseColumnName(key));
            dataMap.put("deleteColumn", deleteColumn);
            //生成Mapper文件
            generateMapperFile(dataMap);
            //生成Dao文件
            generateDaoFile(resultSet);
            //生成Repository文件
            generateRepositoryFile(resultSet);
            //生成服务层接口文件
            generateServiceInterfaceFile(resultSet);
            //生成服务实现层文件
            generateServiceImplFile(resultSet);
            //生成Controller层文件
            generateControllerFile(resultSet);
            //生成DTO文件
            generateDTOFile(resultSet);
            //生成Model文件
            generateModelFile(resultSet);
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {

        }
    }

    private void generateModelFile(ResultSet resultSet) throws Exception {

        final String suffix = ".java";
        final String path = diskPath + changeTableName + suffix;
        final String templateName = "Model.ftl";
        File mapperFile = new File(path);
        List<ColumnMeta> columnMetaList = new ArrayList<>();
        ColumnMeta columnMeta = null;
        while (resultSet.next()) {
            //id字段略过
            if (resultSet.getString("COLUMN_NAME").equals("id"))
                continue;
            columnMeta = new ColumnMeta();
            //获取字段名称
            columnMeta.setColumnName(resultSet.getString("COLUMN_NAME"));
            //获取字段类型
            columnMeta.setJdbcType(resultSet.getString("TYPE_NAME"));
            //转换字段名称，如 sys_name 变成 SysName
            columnMeta
                    .setFieldName(replaceUnderLineAndUpperCase(resultSet.getString("COLUMN_NAME")));
            //字段在数据库的注释
            columnMeta.setComment(resultSet.getString("REMARKS"));
            columnMetaList.add(columnMeta);
        }
        Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("model_column", columnMetaList);
        generateFileByTemplate(templateName, mapperFile, dataMap);

    }

    private void generateDTOFile(ResultSet resultSet) throws Exception {
        final String suffix = "DTO.java";
        final String path = "D://" + changeTableName + suffix;
        final String templateName = "DTO.ftl";
        File mapperFile = new File(path);
        Map<String, Object> dataMap = new HashMap<>();
        generateFileByTemplate(templateName, mapperFile, dataMap);
    }

    private void generateControllerFile(ResultSet resultSet) throws Exception {
        final String suffix = "Controller.java";
        final String path = diskPath + changeTableName + suffix;
        final String templateName = "Controller.ftl";
        File mapperFile = new File(path);
        Map<String, Object> dataMap = new HashMap<>();
        generateFileByTemplate(templateName, mapperFile, dataMap);
    }

    private void generateServiceImplFile(ResultSet resultSet) throws Exception {
        final String suffix = "ServiceImpl.java";
        final String path = diskPath + changeTableName + suffix;
        final String templateName = "ServiceImpl.ftl";
        File mapperFile = new File(path);
        Map<String, Object> dataMap = new HashMap<>();
        generateFileByTemplate(templateName, mapperFile, dataMap);
    }

    private void generateServiceInterfaceFile(ResultSet resultSet) throws Exception {
        final String prefix = "I";
        final String suffix = "Service.java";
        final String path = diskPath + prefix + changeTableName + suffix;
        final String templateName = "ServiceInterface.ftl";
        File mapperFile = new File(path);
        Map<String, Object> dataMap = new HashMap<>();
        generateFileByTemplate(templateName, mapperFile, dataMap);
    }

    private void generateRepositoryFile(ResultSet resultSet) throws Exception {
        final String suffix = "Repository.java";
        final String path = diskPath + changeTableName + suffix;
        final String templateName = "Repository.ftl";
        File mapperFile = new File(path);
        Map<String, Object> dataMap = new HashMap<>();
        generateFileByTemplate(templateName, mapperFile, dataMap);
    }

    private void generateDaoFile(ResultSet resultSet) throws Exception {
        final String suffix = "DAO.java";
        final String path = diskPath + changeTableName + suffix;
        final String templateName = "DAO.ftl";
        File mapperFile = new File(path);
        Map<String, Object> dataMap = new HashMap<>();
        generateFileByTemplate(templateName, mapperFile, dataMap);

    }

    private void generateMapperFile(Map<String, Object> dataMap) throws Exception {
        final String suffix = "Mapper.xml";
        final String path = diskPath + changeTableName + suffix;
        final String templateName = "Mapper.ftl";
        File mapperFile = new File(path);
        generateFileByTemplate(templateName, mapperFile, dataMap);

    }

    private void generateFileByTemplate(final String templateName, File file,
            Map<String, Object> dataMap) throws Exception {
        Template template = FreeMarkerTemplateUtils.getTemplate(templateName);
        FileOutputStream fos = new FileOutputStream(file);
        dataMap.put("table_name_small", tableName);
        dataMap.put("table_name", changeTableName);
        dataMap.put("author", AUTHOR);
        dataMap.put("date", CURRENT_DATE);
        dataMap.put("package_name", packageName);
        dataMap.put("table_annotation", tableAnnotation);
        Writer out = new BufferedWriter(new OutputStreamWriter(fos, "utf-8"), 10240);
        template.process(dataMap, out);
    }

    public String replaceUnderLineAndUpperCase(String str) {
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
        return StringUtils.capitalize(result);
    }

    public String[] parseTableName(String tableName) {
        String[] res = new String[2];
        StringBuffer sb = new StringBuffer();
        sb.append(tableName);
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
        res[1] = StringUtils.capitalize(result);
        return res;
    }

}
