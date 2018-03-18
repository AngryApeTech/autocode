<#include 'function.ftl'/>
package ${package}.service;

import com.ioe.common.domain.DataResult;
import com.ioe.common.domain.ListResult;
import com.ioe.common.domain.PageResult;
import ${package + '.entity.' + entityName};
import java.util.List;
import java.util.Map;

/**
* 描述：${tableComment} 服务实现层接口
* @author ${author}
* @date ${date}
*/
public interface ${entityName}Service {

    /**
    * 单个保存
    */
     DataResult${'<String>'}save${entityName}(
<#if columns??>
    <#assign index = 0/>
    <#list columns as column>
        <#if !isColumnInKeys(column.columnName, keys)>
            <#assign index = index+1/>
            <#if index==(columns?size-keys?size)>
                ${column.javaType?split(".")?last} ${column.fieldName}
            <#else >
                ${column.javaType?split(".")?last} ${column.fieldName},
            </#if>
        </#if>
    </#list>
</#if>
    );

    /**
    * 批量保存
    */
    DataResult${'<Boolean>'} save${entityName}Batch(String ${entityName?uncap_first}Json);

<#if keys??>
    <#list keys as key>
    /**
    * 根据${key.fieldName}获取对象
    */
    ListResult<${entityName}> get${entityName}By${key.fieldName} (${key.javaType} ${key.fieldName}, int availData);

    /**
    * 根据${key.fieldName}删除对象
    */
    DataResult${'<Integer>'} delete${entityName}By${key.fieldName}(${key.javaType} ${key.fieldName}, String operator);

    </#list>
</#if>

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
                <#assign paramNames = params + key.fieldName/>
            <#else>
                <#assign methodName = methodName + key.fieldName?cap_first + 'And' />
                <#assign params = params + key.javaType+' '+key.fieldName + ', ' />
                <#assign paramNames = params + key.fieldName + ', ' />
            </#if>
        </#list>
    /**
    * 根据${paramNames}获取对象
    */
    DataResult<${entityName}> get${entityName}By${methodName} (${params}, int availData);

    /**
    * 根据${paramNames}删除对象
    */
    DataResult${'<Integer>'} delete${entityName}By${methodName}(${params}, String operator);

    </#if>
</#if>

    /**
    * 更新对象
    */
    DataResult${'<Boolean>'} update${entityName}(
<#if columns??>
    <#list columns as column>
                ${column.javaType?split(".")?last} ${column.fieldName},
    </#list>
</#if>
                String operator
    );
}