/**
 * Copyright (C), 杭州中恒云能源互联网技术有限公司，保留所有权利
 */
package com.ape.autocode;

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
