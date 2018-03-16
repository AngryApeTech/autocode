package ${package_name}.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import javax.annotation.Resource;
import com.ioe.stat.annotation.Stat;

import com.ioe.common.domain.DataResult;
import com.ioe.common.domain.ListResult;
import com.ioe.common.domain.PageResult;
import java.util.*
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.alibaba.fastjson.JSONObject;

import ${package + '.entity.' + entityName};
import ${package + '.service.' + entityName}}

/**
* 描述：${tanleComment}
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
            result.setCode("");
            result.setCode("");
            return result;
        }
        try{
            // TODO : 前置代码
            ${EntityName} ${entityName?uncap_first} = new ${EntityName}();

            ${entityName?uncap_first}Dao.save()
            // TODO : 后置代码
        } catch (Exception e){
            logger.error("save${entityName} error:{}", e.getMessage());
            result.setCode("");
            result.setMessage("");
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return result;
    }

    /**
    * 批量保存
    */
    DataResult${'<Boolean>'} save${entityName}Batch(String ${entityName?uncap_first}Json);

    /**
    * 根据Code获取对象
    */
    DataResult<${entityName}> get${EntityName}ByCode(String code);

    /**
    * 更新对象
    */
    DataResultt${'<Boolean>'} update${entityName}(
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
    );

    /**
    * 根据code删除对象
    */
    DataResultt${'<Boolean>'} delete${entityName}ByCode(String code);

}