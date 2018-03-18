/*
 * Copyright (C), 杭州中恒云能源互联网技术有限公司，保留所有权利
 * 版本：3.1.0
 */

package com.ape.autocode.util;

import java.util.*;

/**
 * AngryApe created at 2017/10/12
 */
public class CommonUtils {

    /*--------------------List转字符串---------------------*/
    public static String listToString(List<String> list, String separator, String open,
            String close) {
        if (list == null || list.size() < 1)
            return "";
        StringBuilder sb = new StringBuilder("");
        int index = 0;
        for (String str : list) {
            sb.append(open).append(str).append(close);
            if (index + 1 < list.size())
                sb.append(separator);
            index++;
        }
        return sb.toString();
    }

    public static String listToString(List<String> list) {
        return listToString(list, ",", "", "");
    }

    public static String listToSqlString(List<String> list) {
        return listToString(list, ",", "'", "'");
    }

    /*---------------------返回对象消息处理------------------*/
//    public static void setReturnCode(Result res, AssetAccountReturnCode code) {
//        res.setCode(code.getValue());
//        res.setMessage(code.getName());
//    }
//
//    /**
//     * 检查内部调用结果并将异常信息赋值给result
//     *
//     * @param result     主调方法的result
//     * @param resultTemp 被调方法的result
//     * @return 是否有异常
//     */
//    public static <T extends Result> boolean isResultFault(T result, T resultTemp) {
//        if (isNotEmpty(resultTemp.getCode())) {
//            result.setCode(resultTemp.getCode());
//            result.setMessage(resultTemp.getMessage());
//            return true;
//        }
//        return false;
//    }

    /*---------------------非空判断-----------------------*/
    public static boolean isEmpty(String str) {
        return str == null || "".equals(str);
    }

    public static boolean isNotEmpty(String str) {
        return str != null && !"".equals(str);
    }

    public static boolean isEmpty(Collection collection) {
        return collection == null || collection.isEmpty();
    }

    public static boolean isNotEmpty(Collection collection) {
        return collection != null && !collection.isEmpty();
    }

    public static boolean isEmpty(Map map){
        return map==null || map.isEmpty();
    }

    public static boolean isNotEmpty(Map map){
        return map!=null && !map.isEmpty();
    }

    public static <T> List<T> arrayListNullToEmpty(List<T> collection) {
        return isEmpty(collection) ? new ArrayList<T>() : collection;
    }

    /*---------------------方法内部性能调试----------------*/
    public static void methodCost(Long start, String methodName, StringBuilder sb) {
        Long tEnd = System.currentTimeMillis();
        sb.append(methodName + " execute cost time " + (tEnd - start) + " ms\n");
        start = tEnd;
    }

    public static void methodCost(Long start, String methodName) {
        Long tEnd = System.currentTimeMillis();
        System.out.println(methodName + " execute cost time " + (tEnd - start) + " ms\n");
        start = tEnd;
    }

//    public static <K, V> Map<K, V> convertDbMap(List<DbMap<K, V>> list) {
//        if (isEmpty(list)) {
//            return Collections.emptyMap();
//        }
//        Map<K, V> map = new HashMap<>();
//        for (DbMap<K, V> dbMap : list) {
//            map.put(dbMap.getKey(), dbMap.getValue());
//        }
//        return map;
//    }

    /**
     * json 转对象
     *
     * @return 对象数组
     */
//    public static <T> List<T> parseObjects(String json, Class<T> clazz) {
//        if (isEmpty(json)) {
//            return Collections.emptyList();
//        }
//        List<T> list = new ArrayList<>();
//        if (json.charAt(0) == '[') {
//            list = JSONArray.parseArray(json, clazz);
//        } else {
//            T entity = JSON.parseObject(json, clazz);
//            list.add(entity);
//        }
//        return list;
//    }

    /**
     * 向 value 为List<V> 的map中添加值
     */
    public static <K, V> void addMapList(Map<K, List<V>> map, K key, V value) {
        if (!map.containsKey(key)) {
            map.put(key, new ArrayList<V>());
        }
        map.get(key).add(value);
    }

    public static void main(String[] args) {
        List<String> metrics = new ArrayList<>();
        metrics.add("02010100");
        metrics.add("02010200");
        metrics.add("02010300");
        metrics.add("02020100");
        System.out.println(listToString(metrics, "==", "<", ">"));
        System.out.println(listToString(metrics));
        System.out.println(listToSqlString(metrics));
    }

    public static <T> List<T> getListByJson(String json, Class<T> tClass) {

        List<T> list = new ArrayList<>();
//        if (json.charAt(0) == '[') {
//            list = JSONArray.parseArray(json, tClass);
//        } else {
//            T rule = JSON.parseObject(json, tClass);
//            list.add(rule);
//        }

        return list;
    }
}
