package com.ape.autocode;

import com.ape.autocode.entity.ColumnMeta;
import com.ape.autocode.entity.TableMeta;
import com.ape.autocode.util.CommonUtils;
import com.ape.autocode.util.db.JdbcUtil;
import com.ape.autocode.util.freemarker.FreeMarkerTemplateUtils;
import freemarker.template.Template;

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
public class CodeGenerator {

    private final String AUTHOR = "AngryApe";
    private final String CURRENT_DATE = "2017/05/03";
    private final String packageName = "com.test";
    private final String URL = "jdbc:mysql://10.1.170.160/assetaccount2.2?useUnicode=true&characterEncoding=utf8&allowMultiQueries=true";
    private final String USER = "cms";
    private final String PASSWORD = "Cms123";
    private final String DRIVER = "com.mysql.jdbc.Driver";
    private final String diskPath = "D://test/";
    private final String deleteColumn = "disabled";
    private final String packagePath = packageName.replace(".", "/").concat("/");

    public Connection getConnection() throws Exception {
        Class.forName(DRIVER);
        Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
        return connection;
    }

    public static void main(String[] args) throws Exception {
        CodeGenerator codeGenerator = new CodeGenerator();
        codeGenerator.generateDb();
    }

    public void generateDb() throws Exception {
        Connection connection = getConnection();
        DatabaseMetaData databaseMetaData = connection.getMetaData();
        String[] types = {"TABLE"};
        ResultSet resultSet = databaseMetaData.getTables(null, null, "t_busi%", types);
        List<TableMeta> tables = JdbcUtil.parseTables(resultSet);
        System.out.println("Ready to generate file for total " + tables.size() + " tables. \n");
        tables.forEach(t -> {
            try {
                System.out.println("Start to generate files for table: " + t.getTableName());
                System.out.println(t);
                generate(databaseMetaData, t.getTableName(), t.getEntityName(),
                        t.getTableComment());
                System.out.println("Successfully generate files for table: " + t.getTableName());
            } catch (Exception e) {
                System.out.println("Failed to generate files for table: " + t.getTableName());
                e.printStackTrace();
            }
        });
    }

    public void generateTable(String tableName, String comment) throws Exception {
        Connection connection = getConnection();
        DatabaseMetaData databaseMetaData = connection.getMetaData();
        String entityName = JdbcUtil
                .parseCamelName(tableName.substring(tableName.indexOf('_', 2) + 1));
        generate(databaseMetaData, tableName, entityName, comment);
    }

    public void generate(DatabaseMetaData metaData, String tableName, String entityName,
            String comment) throws Exception {
        try {
            ResultSet resultSet = metaData.getColumns(null, "%", tableName, "%");
            List<ColumnMeta> columns = new ArrayList<>();
            Set<String> classes = new HashSet<>();
            JdbcUtil.parseColumns(resultSet, columns, classes);
            resultSet = metaData.getPrimaryKeys(null, null, tableName);
            String key = JdbcUtil.getKey(resultSet);
            if (CommonUtils.isEmpty(key)) {
                throw new Exception("No primary key of table: " + tableName);
            }
            // 构造 freemarker 变量
            Map<String, Object> dataMap = new HashMap<>();
            dataMap.put("package", packageName);
            dataMap.put("columns", columns);
            dataMap.put("tableName", tableName);
            dataMap.put("entityName", entityName);
            dataMap.put("keyName", key);
            dataMap.put("keyField", JdbcUtil.parseColumnName(key));
            dataMap.put("deleteColumn", deleteColumn);
            dataMap.put("tableComment", comment);
            dataMap.put("author", AUTHOR);
            dataMap.put("date", CURRENT_DATE);
            //生成Entity文件
            generateEntityFile(dataMap);
            //生成Mapper文件
            generateMapperFile(dataMap);
            //生成服务层接口文件
            generateServiceInterfaceFile(dataMap);
            //生成服务实现层文件
            generateServiceImplFile(dataMap);
            //生成Dao文件
            //            generateDaoFile(dataMap);
            resultSet.close();
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

    private void generateServiceInterfaceFile(Map<String, Object> dataMap) throws Exception {
        final String fileSuffix = "Service.java";
        final String pathSuffix = "service";
        final String templateName = "ServiceInterface.ftl";
        generateFileByTemplate(templateName, pathSuffix, fileSuffix, dataMap);
    }

    private void generateServiceImplFile(Map<String, Object> dataMap) throws Exception {
        final String fileSuffix = "ServiceImpl.java";
        final String pathSuffix = "service/impl";
        final String templateName = "ServiceImpl.ftl";
        generateFileByTemplate(templateName, pathSuffix, fileSuffix, dataMap);
    }

    private void generateDaoFile(Map<String, Object> dataMap) throws Exception {
        final String fileSuffix = "Dao.java";
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
        File mapperFile = new File(path + dataMap.get("entityName") + fileSuffix);
        Template template = FreeMarkerTemplateUtils.getTemplate(templateName);
        FileOutputStream fos = new FileOutputStream(mapperFile);
        Writer out = new BufferedWriter(new OutputStreamWriter(fos, "utf-8"), 10240);
        template.process(dataMap, out);
    }

}
