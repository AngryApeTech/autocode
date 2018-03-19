<#include 'function.ftl'/>
package ${package}.service;

import com.ioe.common.domain.DataResult;
import com.ioe.common.domain.ListResult;
import com.ioe.common.domain.PageResult;
import ${package + '.entity.' + entityName};
import java.util.*;
import java.math.BigDecimal;

/**
* 描述：${tableComment} 服务实现层接口
* @author ${author}
* @date ${date}
*/
public interface ${entityName}Service {


<#if columns??>
    <#assign index = 0 params = '' paramComments=''/>
    <#list columns as column>
    <#--唯一主键时，不需要传进来；联合主键时需要传进来；系统字段不需要传进来；-->
        <#if ((keys![])?size>1 ||((keys![])?size==1 && !isColumnInKeys(column.columnName, keys)))
        && !(sysColumns![])?seq_contains(column.columnName)>
            <#assign params = params + column.javaType?split(".")?last+" "+column.fieldName+', '/>
            <#assign paramComments = paramComments + '* @param '+ column.fieldName +' '+ column.comment+'\n\t'/>
        </#if>
    </#list>
    /**
    * 单个保存
    ${paramComments}
    * @param operator 操作者编号
    */
     DataResult${'<String>'}save${entityName}(${params} String operator);
</#if>

    /**
    * 批量保存
    * @param ${entityName?uncap_first}Json 对象集合 Json 字符串
    * @param operator 操作者编号
    */
    DataResult${'<Boolean>'} save${entityName}Batch(String ${entityName?uncap_first}Json, String operator);

<#--为每个主键生成查询方法-->
<#if keys??>
    <#list keys as key>
    /**
    * 根据${key.fieldName}获取对象
    * @param ${key.fieldName} ${key.comment}
    */
    ListResult<${entityName}> get${entityName}By${key.fieldName?cap_first} (${key.javaType} ${key.fieldName}, int availData);

    /**
    * 根据${key.fieldName}删除对象
    * @param ${key.fieldName} ${key.comment}
    */
    DataResult${'<Integer>'} delete${entityName}By${key.fieldName?cap_first}(${key.javaType} ${key.fieldName}, String operator);

    </#list>
</#if>

<#--为联合主键生成查询方法-->
<#if keys??>
<#--如果只有一列则不执行-->
    <#if (keys?size>1)>
        <#assign methodName='' paramComments='' params='' paramNames=''/>
        <#list keys as key>
            <#if key?is_last>
                <#assign methodName = methodName + key.fieldName?cap_first />
                <#assign params = params + key.javaType+' '+key.fieldName/>
                <#assign paramNames = paramNames + key.fieldName/>
            <#else>
                <#assign methodName = methodName + key.fieldName?cap_first + 'And' />
                <#assign params = params + key.javaType+' '+key.fieldName + ', ' />
                <#assign paramNames = paramNames + key.fieldName + ', ' />
            </#if>
            <#assign paramComments = paramComments + '* @param '+ key.fieldName +' '+ key.comment+'\n\t'/>
        </#list>
    /**
    * 根据${paramNames}获取对象
        ${paramComments}
    * @param availData 是否是测试数据，0/1:否/是,默认为0
    */
    DataResult<${entityName}> get${entityName}By${methodName} (${params}, int availData);

    /**
    * 根据${paramNames}删除对象
        ${paramComments}
    * @param operator 操作者编号
    */
    DataResult${'<Integer>'} delete${entityName}By${methodName}(${params}, String operator);

    </#if>
</#if>

<#--生成更新方法-->
<#if columns?? && keys??>
    <#assign fields='' fieldComments=''/>
    <#list columns as column>
        <#if !((sysColumns![])?seq_contains(column.columnName))>
            <#assign fields = fields + column.javaType?split(".")?last+' '+ column.fieldName + ', '/>
            <#assign fieldComments = fieldComments + '* @param '+ column.fieldName +' '+ column.comment+'\n\t'/>
        </#if>
    </#list>
    <#assign fields = fields + 'String operator'/>
    /**
    * 更新对象
    ${fieldComments}
    * @param operator 操作者编号
    */
    DataResult${'<Boolean>'} update${entityName}(${fields});
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
    ListResult<${entityName}> get${entityName}By${methodName} (${params}, int availData);

    </#list>
</#if>
}