package ${package}.dao;

import ${package}.entity.${entityName};

import org.apache.ibatis.annotations.Param;
import java.util.*;

/**
* 描述：${tableComment}
* @author ${author}
* @date ${date}
*/
public interface ${entityName}Dao {

    int save(@Param("entity")${entityName} entity);

    int saveBatch(@Param("entities")List<${entityName}> entities);

    int update(@Param("entity")${entityName} entity);

<#--为联合主键的每个字段生成单独的查询方法-->
<#if keys??>
    <#list keys as key>
    List<${entityName}> getBy${key.fieldName?cap_first} (@Param("${key.fieldName}")String ${key.fieldName}, @Param("availData")int availData);

    int deleteBy${key.fieldName?cap_first} (String ${key.fieldName}, @Param("operator")String operator);

    </#list>
</#if>

<#--为联合主键的所有字段生成查询方法-->
<#if keys??>
    <#--如果只有一列则不执行-->
    <#if (keys?size>1)>
        <#assign methodName=''/>
        <#assign params=''/>
        <#list keys as key>
            <#if key?is_last>
                <#assign methodName = methodName + key.fieldName?cap_first />
                <#assign params = params + '@Param("'+key.fieldName+'")'+key.javaType+' '+key.fieldName/>
            <#else>
                <#assign methodName = methodName + key.fieldName?cap_first + 'And' />
                <#assign params = params + '@Param("'+key.fieldName+'")'+key.javaType+' '+key.fieldName + ', '/>
            </#if>
        </#list>
    ${entityName} getBy${methodName}(${params}, @Param("availData")int availData);

    int deleteBy${methodName} (${params}, @Param("operator")String operator);
    </#if>
</#if>

}