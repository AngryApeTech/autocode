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
import ${package + '.service.' + entityName}}

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
    <#list columns as column>
        <#if column.columnName != keyName>
            <#if column?is_last>
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
        <#if column.columnName != keyName>
            ${entityName?uncap_first}.set${column.fieldName?cap_first}(${column.fieldName});
        <#else >
            ${entityName?uncap_first}.set${column.fieldName?cap_first}(CoderGenerator.getDeviceCode(NewCodeUtil.nodeId()));
        </#if>
    </#list>
</#if>
            ${entityName?uncap_first}Dao.save()
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

    /**
    * 根据Code获取对象
    */
    @Override
    @Stat
    DataResult<${entityName}> get${entityName}ByCode (String code){
        DataResult<${entityName}> result = new DataResult();
        if(CommonUtils.isEmpty(code)){
            result.setCode("1");
            result.setCode("1");
            return result;
        }
        try{
            // TODO : 前置代码
            ${entityName} ${entityName?uncap_first} = ${entityName?uncap_first}Dao.getByKey(code);
            // TODO : 后置代码
            if(${entityName?uncap_first} != null){
                result.setData(${entityName?uncap_first});
            }
        } catch (Exception e){
            logger.error("save${entityName}ByCode error:{}", e.getMessage());
            result.setCode("1");
            result.setMessage("1");
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return result;
    }

    /**
    * 更新对象
    */
    @Override
    @Stat
    @Transactional(rollbackFor = Exception.class)
    DataResult${'<Boolean>'} update${entityName} (
<#if columns??>
    <#list columns as column>
        <#if column.columnName != keyName>
            <#if column?is_last>
                ${column.javaType?split(".")?last} ${column.fieldName}
            <#else >
                ${column.javaType?split(".")?last} ${column.fieldName},
            </#if>
        </#if>
    </#list>
</#if>
    ){
        DataResult${'<Boolean>'} result = new DataResult();
        if(false){
            result.setCode("1");
            result.setCode("1");
            return result;
        }
        try{
            // TODO : 前置代码
            ${entityName} ${entityName?uncap_first} = ${entityName?uncap_first}Dao.getByKey(code);
<#if columns??>
    <#list columns as column>
            ${entityName?uncap_first}.set${column.fieldName?cap_first}(${column.fieldName});
    </#list>
</#if>
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

    /**
    * 根据code删除对象
    */
    @Override
    @Stat
    @Transactional(rollbackFor = Exception.class)
    DataResult${'<Boolean>'} delete${entityName}ByCode(String code){
        DataResult${'<Boolean>'} result = new DataResult();
        if(CommonUtils.isEmpty(code)){
            result.setCode("1");
            result.setCode("1");
            return result;
        }
        try{
            // TODO : 前置代码
            ${entityName?uncap_first}Dao.deleteByKey(code);
            // TODO : 后置代码
            result.setData(Boolean);
        } catch (Exception e){
            logger.error("delete${entityName}ByCode error:{}", e.getMessage());
            result.setCode("1");
            result.setMessage("1");
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return result;
    }

}