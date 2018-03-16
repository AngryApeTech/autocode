/**
 * Copyright (C), 杭州中恒云能源互联网技术有限公司，保留所有权利
 */
package com.ape.autocode;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * @auther qiys@hzzh.com
 * @date 2018-03-16
 */
public class Runner {

    private final static Logger logger = LoggerFactory.getLogger(Runner.class);

    public static void main(String[] args) {
        Runner runner = new Runner();
        Properties properties = runner.loadConfig(args);
        if (properties == null || properties.size() <= 0) {
            logger.error("Property file is empty or not set, check please.");
            System.exit(1);
        }
        CodeGenerator codeGenerator = new CodeGenerator(properties);
        try {
            codeGenerator.generate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Properties loadConfig(String[] args) {
        try {
            String filePath = "auto_code.properties";
            if (args != null && args.length > 0) {
                try {
                    File propertyFile = new File(args[0]);
                    if (propertyFile.exists()) {
                        filePath = args[0];
                    }
                } catch (Exception e) {

                }
            }
            InputStream inputStream = CodeGenerator.class.getClassLoader()
                    .getResourceAsStream(filePath);
            Properties properties = new Properties();
            properties.load(inputStream);
            return properties;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

}
