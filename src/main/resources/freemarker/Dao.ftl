package ${package}.dao;

import ${package}.entity.${entityName};

import org.apache.ibatis.annotations.Param;
import java.util.*;

/**
* 描述：${tableComment}
* @author ${author}
* @date ${date}
*/
public interface ${entityName}Dao extends BaseDao{

    int create${entityName?cap_first}(@Param("entity")${entityName} entity);

    int create${entityName?cap_first}Batch(@Param("entities")List<${entityName}> entities);

<#if keys??>
    int update${entityName?cap_first}(@Param("entity")${entityName} entity);
</#if>

<#--为每个主键生成查询方法-->
<#if keys??>
    <#list keys as key>
    List<${entityName}> query${entityName?cap_first}By${key.fieldName?cap_first} (@Param("${key.fieldName}")String ${key.fieldName}, @Param("availData")int availData);

    int delete${entityName?cap_first}By${key.fieldName?cap_first} (String ${key.fieldName}, @Param("operator")String operator);

    </#list>
</#if>

<#--为联合主键生成查询方法-->
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
    ${entityName} query${entityName?cap_first}By${methodName}(${params}, @Param("availData")int availData);

    int delete${entityName?cap_first}By${methodName} (${params}, @Param("operator")String operator);
    </#if>
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
    * index:${index.tableName +' ==> '+ index.name}
    */
    List<${entityName}> query${entityName?cap_first}By${methodName} (${params}, @Param("availData")int availData);

    </#list>
</#if>

    int updateAvailDataFlag(@Param("ids")List${'<String>'} ids, @Param("flag")int flag);
}