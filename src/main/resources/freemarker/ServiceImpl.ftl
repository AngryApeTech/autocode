<#include 'function.ftl'/>
package ${package}.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import javax.annotation.Resource;
import com.ioe.stat.annotation.Stat;

import com.ioe.common.domain.DataResult;
import com.ioe.common.domain.ListResult;
import com.ioe.common.domain.PageResult;
import java.util.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.alibaba.fastjson.JSONObject;

import ${package + '.entity.' + entityName};
import ${package + '.service.' + entityName};

/**
* 描述：${tableComment}
* @author ${author}
* @date ${date}
*/
@Service("${entityName?uncap_first}Service")
public class ${entityName}ServiceImpl implements ${entityName}Service {

    private static Logger logger = LoggerFactory.getLogger(${entityName}ServiceImpl.class);

    @Resource
    private ${entityName}Dao ${entityName?uncap_first}Dao;

    /**
    * 单个保存
    */
    @Override
    @Stat
    @Transactional(rollbackFor = Exception.class)
    DataResult${'<String>'} save${entityName}(
<#if columns??>
    <#assign index = 0/>
    <#list columns as column>
        <#if !isColumnInKeys(column.columnName, keys)>
            <#assign index = index+1/>
            <#if index==(columns?size-keys?size!0)>
                ${column.javaType?split(".")?last} ${column.fieldName}
            <#else >
                ${column.javaType?split(".")?last} ${column.fieldName},
            </#if>
        </#if>
    </#list>
</#if>
    ){
        DataResult${'<String>'} result = new DataResult();
        if(false){
            result.setCode("1");
            result.setCode("1");
            return result;
        }
        try{
            // TODO : 前置代码
            ${entityName} ${entityName?uncap_first} = new ${entityName}();
<#if columns??>
    <#list columns as column>
        <#if !isColumnInKeys(column.columnName, keys)>
            ${entityName?uncap_first}.set${column.fieldName?cap_first}(${column.fieldName});
        <#else >
            ${entityName?uncap_first}.set${column.fieldName?cap_first}(CoderGenerator.getDeviceCode(NewCodeUtil.nodeId()));
        </#if>
    </#list>
</#if>
            ${entityName?uncap_first}Dao.save(${entityName?uncap_first});
            // TODO : 后置代码
        } catch (Exception e){
            logger.error("save${entityName} error:{}", e.getMessage());
            result.setCode("1");
            result.setMessage("1");
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return result;
    }

    /**
    * 批量保存
    */
    @Override
    @Stat
    @Transactional(rollbackFor = Exception.class)
    DataResult${'<Boolean>'} save${entityName}Batch (String ${entityName?uncap_first}Json){
        if(CommonUtils.isEmpty(${entityName?uncap_first}Json)){
            result.setCode("1");
            result.setCode("1");
            return result;
        }
        try{
            List<${entityName}> ${entityName?uncap_first}List = CommonUtils.getListByJson(${entityName?uncap_first}Json, ${entityName}.class);

            if (CommonUtils.isEmpty(${entityName?uncap_first}List)) {
                result.setCode("1");
                result.setMessage("1");
                return result;
            }

            // TODO : 前置代码
            ${entityName?uncap_first}Dao.saveBatch(${entityName?uncap_first}List);
            result.setData(True);

            // TODO : 后置代码
        } catch (Exception e){
            logger.error("save${entityName}Batch error:{}", e.getMessage());
            result.setCode("1");
            result.setMessage("1");
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return result;
    }

<#--为每个主键生成查询方法-->
<#if keys??>
    <#list keys as key>
    /**
    * 根据${key.fieldName}获取对象
    */
    @Override
    @Stat
    public ListResult<${entityName}> get${entityName}By${key.fieldName} (${key.javaType} ${key.fieldName}, int availData){
        ListResult<${entityName}> result = new ListResult();
        <#if key.javaType=="String">
        if(CommonUtils.isEmpty(${key.fieldName})){
        <#else>
        if(${key.fieldName} == null){
        </#if>
            result.setCode("1");
            result.setCode("1");
            return result;
        }
        try{
            // TODO : 前置代码
            List<${entityName}> ${entityName?uncap_first}List = ${entityName?uncap_first}Dao.getBy${key.fieldName?cap_first}(${key.fieldName}, availData);
            // TODO : 后置代码
            if(CommonUtils.isNotEmpty(${entityName?uncap_first}List)){
                result.setDataList(${entityName?uncap_first}List);
            }
        } catch (Exception e){
            logger.error("save${entityName}By${key.fieldName} error:{}", e.getMessage());
            result.setCode("1");
            result.setMessage("1");
        }
        return result;
    }

    /**
    * 根据${key.fieldName}删除对象
    */
    @Override
    @Stat
    @Transactional(rollbackFor = Exception.class)
    public DataResult${'<Integer>'} delete${entityName}By${key.fieldName}(${key.javaType} ${key.fieldName}, String operator){
        DataResult${'<Integer>'} result = new DataResult();
        <#if key.javaType=="String">
        if(CommonUtils.isEmpty(${key.fieldName})){
        <#else>
        if(${key.fieldName} == null){
        </#if>
            result.setCode("1");
            result.setCode("1");
            return result;
        }
        try{
            // TODO : 前置代码
        int count = ${entityName?uncap_first}Dao.deleteBy${key.fieldName}(${key.fieldName}, operator);
            // TODO : 后置代码
            result.setData(count);
        } catch (Exception e){
            logger.error("delete${entityName}By${key.fieldName} error:{}", e.getMessage());
            result.setCode("1");
            result.setMessage("1");
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return result;
    }

    </#list>
</#if>

<#--为联合主键生成查询方法-->
<#if keys??>
<#--如果只有一列则不执行-->
    <#if (keys?size>1)>
        <#assign methodName=''/>
        <#assign params=''/>
        <#assign paramNames=''/>
        <#list keys as key>
            <#if key?is_last>
                <#assign methodName = methodName + key.fieldName?cap_first />
                <#assign params = params + key.javaType+' '+key.fieldName/>
                <#assign paramNames = paramNames + key.fieldName/>
            <#else>
                <#assign methodName = methodName + key.fieldName?cap_first + 'And' />
                <#assign params = params + key.javaType+' '+key.fieldName + ', '/>
                <#assign paramNames = paramNames + key.fieldName + ', '/>
            </#if>
        </#list>
    /**
    * 根据${paramNames}获取对象
    */
    @Override
    @Stat
    public DataResult<${entityName}> get${entityName}By${methodName} (${params}, int availData){
        DataResult<${entityName}> result = new DataResult();
        // TODO: 数据校验
        //if(){
        //    result.setCode("1");
        //    result.setCode("1");
        //    return result;
        //}
        try{
            // TODO : 前置代码
            ${entityName} ${entityName?uncap_first} = ${entityName?uncap_first}Dao.getBy${methodName}(${paramNames}, availData);
            // TODO : 后置代码
            if(${entityName?uncap_first} != null){
                result.setData(${entityName?uncap_first});
            }
        } catch (Exception e){
            logger.error("save${entityName}By$${methodName} error:{}", e.getMessage());
            result.setCode("1");
            result.setMessage("1");
        }
        return result;
    }

    /**
    * 根据${paramNames}删除对象
    */
    @Override
    @Stat
    @Transactional(rollbackFor = Exception.class)
    public DataResult${'<Integer>'} delete${entityName}By${methodName}(${params}, String operator){
        DataResult${'<Integer>'} result = new DataResult();
        // TODO: 数据校验
        //if(){
        //    result.setCode("1");
        //    result.setCode("1");
        //    return result;
        //}
        try{
            // TODO : 前置代码
        int count = ${entityName?uncap_first}Dao.deleteBy${methodName}(${paramNames}, operator);
            // TODO : 后置代码
            result.setData(count);
        } catch (Exception e){
            logger.error("delete${entityName}By${methodName} error:{}", e.getMessage());
            result.setCode("1");
            result.setMessage("1");
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return result;
    }

    </#if>
</#if>

<#--生成更新方法-->
<#if keys??>
    /**
    * 更新对象
    */
    @Override
    @Stat
    @Transactional(rollbackFor = Exception.class)
    DataResult${'<Boolean>'} update${entityName} (
<#if columns??>
    <#list columns as column>
                ${column.javaType?split(".")?last} ${column.fieldName},
    </#list>
</#if>
                String operator
    ){
        DataResult${'<Boolean>'} result = new DataResult();
        if(false){
            result.setCode("1");
            result.setCode("1");
            return result;
        }
        try{
            // TODO : 前置代码
        ${entityName} ${entityName?uncap_first} = new ${entityName}();
<#if columns??>
    <#list columns as column>
        ${entityName?uncap_first}.set${column.fieldName?cap_first}(${column.fieldName});
    </#list>
</#if>
        ${entityName?uncap_first}.set${updaterField?cap_first}(operator);
        ${entityName?uncap_first}Dao.update(${entityName?uncap_first});
            // TODO : 后置代码
            result.setData(True);
        } catch (Exception e){
            logger.error("update${entityName} error:{}", e.getMessage());
            result.setCode("1");
            result.setMessage("1");
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return result;
    }
</#if>

<#--根据索引生成查询方法-->
<#if indexes??>
    <#list indexes as index>
        <#if index.columns??>
            <#assign params='' paramNames='' fieldComments='' methodName=''/>
            <#list index.columns as col>
                <#if col?is_last>
                    <#assign params=params+col.javaType+' '+col.fieldName/>
                    <#assign paramNames=paramNames+col.fieldName/>
                    <#assign methodName=methodName+col.fieldName?cap_first/>
                <#else>
                    <#assign params=params+col.javaType+' '+col.fieldName+', '/>
                    <#assign paramNames=paramNames+col.fieldName+', '/>
                    <#assign methodName=methodName+col.fieldName?cap_first+'And'/>
                </#if>
                <#assign fieldComments=fieldComments+'* @param '+col.fieldName+' '+col.comment+'\n\t'/>
            </#list>
        </#if>
    /**
    * 根据${paramNames}查询记录
    *
    ${fieldComments}
    */
    @Override
    @Stat
    public ListResult<${entityName}> get${entityName}By${methodName} (${params}, int availData){
        ListResult<${entityName}> result = new ListResult();
        //TODO:数据校验
        //if(){
        //    result.setCode("1");
        //    result.setCode("1");
        //    return result;
        //}
        try{
            // TODO : 前置代码
            List<${entityName}> ${entityName?uncap_first}List = ${entityName?uncap_first}Dao.getBy${methodName}(${paramNames}, availData);
            // TODO : 后置代码
            if(CommonUtils.isNotEmpty(${entityName?uncap_first}List)){
                result.setDataList(${entityName?uncap_first}List);
            }
        } catch (Exception e){
            logger.error("get${entityName}By${methodName} error:{}", e.getMessage());
            result.setCode("1");
            result.setMessage("1");
        }
        return result;
    }

    </#list>
</#if>
}