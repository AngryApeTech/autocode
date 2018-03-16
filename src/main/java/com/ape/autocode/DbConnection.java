package com.ape.autocode;

import java.sql.Connection;
import java.util.Properties;

/**
 * @auther qiys@hzzh.com
 * @date 2018-03-14
 */
public abstract class DbConnection {

    protected static Properties conf = new Properties();

    public abstract Connection getConnection();

    private void init() {
        //        TODO : read config from db-config.property
    }
}
