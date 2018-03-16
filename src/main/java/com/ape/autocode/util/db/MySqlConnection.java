package com.ape.autocode.util.db;

import java.sql.Connection;

/**
 * @auther qiys@hzzh.com
 * @date 2018-03-14
 */
public class MySqlConnection extends DbConnection {

    @Override
    public Connection getConnection() {
        String url = conf.getProperty("");
        return null;
    }
}
