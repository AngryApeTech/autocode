package com.ape.autocode;

import com.ape.autocode.entity.ColumnMeta;
import com.ape.autocode.entity.IndexMeta;
import com.ape.autocode.entity.TableMeta;
import com.ape.autocode.util.CommonUtils;
import com.ape.autocode.util.db.JdbcUtil;
import com.ape.autocode.util.freemarker.FreeMarkerTemplateUtils;
import freemarker.template.Template;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @auther qiys@hzzh.com
 * @date 2018-03-15
 */
public class CodeGenerator {

    private final static Logger logger = LoggerFactory.getLogger(CodeGenerator.class);

    private String author;
    private String currentDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
    private String packageName;
    private String filePath;
    private String deleteColumn;
    private String deleteValue;
    private Set<String> sysColumns;
    private String packagePath;
    private String tablePattern;
    private String queryDefault;
    private String updaterColumn;

    private Properties conf;

    private boolean initConfig = false;

    public CodeGenerator() {
    }

    public CodeGenerator(Properties properties) {
        config(properties);
    }

    public void config(Properties properties) {
//        properties.forEach((key, value) -> System.out.println(key));
        if (properties == null || properties.size() <= 0) {
            logger.error("No configuration for generator environment.");
            return;
        }
        this.author = (String) properties.get("author");
        this.packageName = (String) properties.get("package.name");
        if (CommonUtils.isEmpty(packageName)) {
            logger.error("Can not get property [package.name] for CodeGenerator.");
            System.exit(1);
        }
        this.filePath = (String) properties.get("file.path");
        if (CommonUtils.isEmpty(filePath)) {
            logger.warn("Can not get property [file.path] for CodeGenerator.");
            System.exit(1);
        }
        this.deleteColumn = (String) properties.get("column.delete");
        if (CommonUtils.isEmpty(deleteColumn)) {
            logger.warn("Can not get property [table.pattern] for CodeGenerator.");
            System.exit(1);
        }
        this.deleteValue = (String) properties.get("column.delete.value");
        if (CommonUtils.isEmpty(deleteValue)) {
            logger.warn("Can not get property [column.delete.value] for CodeGenerator.");
            System.exit(1);
        }
        this.queryDefault = (String) properties.get("query.default");
        this.updaterColumn = (String) properties.get("column.updater");
        if (CommonUtils.isEmpty(updaterColumn)) {
            logger.warn("Can not get property [column.updater] for CodeGenerator.");
            System.exit(1);
        }
        String columnsDefault = (String) properties.get("columns.sys");
        if (CommonUtils.isEmpty(columnsDefault)) {
            logger.warn("Can not get property [columns.sys] for CodeGenerator.");
            System.exit(1);
        }
        this.sysColumns = new HashSet<>(Arrays.asList(columnsDefault.split(",")));
        this.tablePattern = (String) properties.get("table.pattern");
        if (CommonUtils.isEmpty(packageName)) {
            logger.warn("Can not get property [table.pattern] for CodeGenerator.");
            System.exit(1);
        }
        packagePath = packageName.replace(".", "/").concat("/");
        initConfig = true;
        conf = properties;
    }

    public static void main(String[] args) throws Exception {

    }

    public void generate() throws Exception {
        if (!initConfig) {
            return;
        }
        Connection connection = JdbcUtil.getConnection(conf);
        DatabaseMetaData databaseMetaData = connection.getMetaData();
        String[] types = {"TABLE"};
        ResultSet resultSet = databaseMetaData.getTables(null, null, tablePattern, types);
        List<TableMeta> tables = JdbcUtil.parseTables(resultSet);
        logger.info("Ready to generate file for total {} tables. \n", tables.size());
        tables.forEach(t -> {
            try {
                logger.info("Start to generate files for table: {}", t.getTableName());
                generateFiles(databaseMetaData, t.getTableName(), t.getEntityName(),
                        t.getTableComment());
                logger.info("Successfully generate files for table: {} \n", t.getTableName());
            } catch (Exception e) {
                logger.error("Failed to generate files for table: {}, error: \n{}\n",
                        t.getTableName(), e.getMessage());
            }
        });
        connection.close();
    }

    /**
     *
     * @param metaData
     * @param tableName
     * @param entityName
     * @param comment
     * @throws Exception
     */
    private void generateFiles(DatabaseMetaData metaData, String tableName, String entityName,
                               String comment) throws Exception {
        try {
            //获取字段信息
            ResultSet resultSet = metaData.getColumns(null, "%", tableName, "%");
            List<ColumnMeta> columns = JdbcUtil.parseColumns(resultSet);
            resultSet.close();
//            columns.forEach(System.out::println);

            //获取主键信息
            resultSet = metaData.getPrimaryKeys(null, null, tableName);
            List<ColumnMeta> keys = JdbcUtil.parseKeys(resultSet, columns);
            resultSet.close();
//            if (CommonUtils.isEmpty(keys)) {
//                throw new Exception("No primary key of table: " + tableName);
//            }
            keys.forEach(System.out::println);

            //TODO:获取索引信息
            resultSet = metaData.getIndexInfo(null, null, tableName, false, false);
            List<IndexMeta> indexes = JdbcUtil.parseIndexes(tableName, resultSet, columns);
            indexes.forEach(System.out::println);
            resultSet.close();
            // 构造 freemarker 变量
            Map<String, Object> dataMap = new HashMap<>();
            dataMap.put("package", packageName);    //文件包名
            dataMap.put("columns", columns);        //数据库所有字段信息
            dataMap.put("tableName", tableName);    //表名
            dataMap.put("entityName", entityName);  //表对应的Entity名称
            dataMap.put("keys", keys);              //（联合）主键
            dataMap.put("indexes", indexes);              //（联合）主键
            dataMap.put("deleteColumn", deleteColumn);  //
            dataMap.put("deleteValue", deleteValue);    //
            dataMap.put("sysColumns", sysColumns);  //
            dataMap.put("tableComment", comment);   //
            dataMap.put("author", author);          //
            dataMap.put("date", currentDate);       //
            dataMap.put("queryDefault", queryDefault);       //
            dataMap.put("updaterColumn", updaterColumn);       //
            dataMap.put("updaterField", JdbcUtil.parseCamelNameInitLower(updaterColumn));       //
            //生成Entity文件
            generateEntityFile(dataMap);
            //生成Mapper文件
            generateMapperFile(dataMap);
            //生成服务层接口文件
            generateServiceInterfaceFile(dataMap);
            //生成服务实现层文件
            generateServiceImplFile(dataMap);
            //生成Dao文件
            generateDaoFile(dataMap);
            resultSet.close();
        } catch (Exception e) {
            throw new RuntimeException(e);
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
        final String path = filePath + packagePath + pathSuffix + "/";
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
