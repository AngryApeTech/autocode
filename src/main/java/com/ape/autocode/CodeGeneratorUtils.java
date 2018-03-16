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
    private final String packagePath = packageName.replace(".", "/").concat("/");

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
        //        File path = new File(diskPath);
        //        if (!path.exists()) {
        //            if (path.mkdirs()) {
        //                System.out.println("create path [] successfully !");
        //            }
        //        }
    }

    public void generate() throws Exception {
        String tableComment = "";

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
            dataMap.put("tableComment", tableComment);
            dataMap.put("author", AUTHOR);
            dataMap.put("date", CURRENT_DATE);
            //生成Entity文件
            generateEntityFile(dataMap);
            //生成Mapper文件
            generateMapperFile(dataMap);
            //生成Dao文件
            generateDaoFile(dataMap);
            //生成服务层接口文件
            generateServiceInterfaceFile(dataMap);
            //生成服务实现层文件
            generateServiceImplFile(dataMap);
            //生成DTO文件
            generateDTOFile(dataMap);
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {

        }
    }

    /**
     * 生成Entity文件
     *
     * @param dataMap
     * @throws Exception
     */
    private void generateEntityFile(Map<String, Object> dataMap) throws Exception {
        final String fileSuffix = ".java";
        final String pathSuffix = "entity";
        final String templateName = "Entity.ftl";
        generateFileByTemplate(templateName, pathSuffix, fileSuffix, dataMap);
    }

    /**
     * 生成mapper文件
     *
     * @param dataMap
     * @throws Exception
     */
    private void generateMapperFile(Map<String, Object> dataMap) throws Exception {
        final String fileSuffix = "Mapper.xml";
        final String pathSuffix = "mapper";
        final String templateName = "Mapper.ftl";
        generateFileByTemplate(templateName, pathSuffix, fileSuffix, dataMap);
    }

    private void generateDTOFile(Map<String, Object> dataMap) throws Exception {
        final String fileSuffix = ".java";
        final String pathSuffix = "dto";
        final String templateName = "Dto.ftl";
        generateFileByTemplate(templateName, pathSuffix, fileSuffix, dataMap);
    }

    private void generateServiceInterfaceFile(Map<String, Object> dataMap) throws Exception {
        final String fileSuffix = ".java";
        final String pathSuffix = "service";
        final String templateName = "ServiceInterface.ftl";
        generateFileByTemplate(templateName, pathSuffix, fileSuffix, dataMap);
    }

    private void generateServiceImplFile(Map<String, Object> dataMap) throws Exception {
        final String fileSuffix = ".java";
        final String pathSuffix = "service/impl";
        final String templateName = "ServiceImpl.ftl";
        generateFileByTemplate(templateName, pathSuffix, fileSuffix, dataMap);
    }

    private void generateDaoFile(Map<String, Object> dataMap) throws Exception {
        final String fileSuffix = ".java";
        final String pathSuffix = "dao";
        final String templateName = "Dao.ftl";
        generateFileByTemplate(templateName, pathSuffix, fileSuffix, dataMap);
    }

    private void generateFileByTemplate(final String templateName, String pathSuffix,
            String fileSuffix, Map<String, Object> dataMap) throws Exception {
        final String path = diskPath + packagePath + pathSuffix + "/";
        File pkgPath = new File(path);
        if (!pkgPath.exists()) {
            pkgPath.mkdirs();
        }
        File mapperFile = new File(path + changeTableName + fileSuffix);
        Template template = FreeMarkerTemplateUtils.getTemplate(templateName);
        FileOutputStream fos = new FileOutputStream(mapperFile);
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

}
