<#include 'function.ftl'/>
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//ibatis.apache.org//DTD Mapper 3.0//EN"
        "http://ibatis.apache.org/dtd/ibatis-3-mapper.dtd">
<mapper namespace="${package}.dao.${entityName}Dao">

    <resultMap id="resultMap" type="${package}.entity.${entityName}">
        <#if columns??>
            <#list columns as column>
        <result property="${column.fieldName}" column="${column.columnName}" jdbcType="${column.jdbcType}"/>
            </#list>
        </#if>
    </resultMap>

    <sql id="tableName">${tableName}</sql>
    <sql id="columns">
        <#if columns??>
            <#list columns as column>
                <#if column?is_last>
        ${column.columnName}
                <#else >
        ${column.columnName},
                </#if>
            </#list>
        </#if>
    </sql>

    ${'<!-- single entity create -->'}
    <insert id="create${entityName?cap_first}">
        insert into
        <include refid="tableName"/>
        (<include refid="columns"/>) values
        (
        <#if columns??>
            <#list columns as column>
                <#if column?is_last>
            ${r'#{entity'+'.'+column.fieldName+'}'}
                <#else >
            ${r'#{entity'+'.'+column.fieldName+'}'},
                </#if>
            </#list>
        </#if>
        )
    </insert>

    ${'<!-- mutipule entity create -->'}
    <insert id="create${entityName?cap_first}Batch">
        insert into
        <include refid="tableName"/>
        (<include refid="columns"/>) values
        <foreach collection="entities" open="(" close=")" item="entity" separator=",">
        (
            <#if columns??>
                <#list columns as column>
                    <#if column?is_last>
            ${r'#{entity'+'.'+column.fieldName+'}'}
                    <#else >
            ${r'#{entity'+'.'+column.fieldName+'}'},
                    </#if>
                </#list>
            </#if>
        )
        </foreach>
    </insert>

<#--为每个主键生成查询方法-->
<#if keys??>
    <#list keys as key>
    ${'<!-- query entity by '+key.fieldName+' -->'}
    <select id="query${entityName?cap_first}By${key.fieldName?cap_first}" resultMap="resultMap">
        select <include refid="columns"/>
        from <include refid="tableName"/>
        where ${key.fieldName} = ${r'#{'+key.fieldName+'}'}
        <#if queryDefault??>
        and ${queryDefault}
        </#if>
    </select>

    <update id="delete${entityName?cap_first}By${key.fieldName?cap_first}">
        update <include refid="tableName"/>
        set ${deleteColumn}=${deleteValue}, ${updaterColumn}=${r'#{operator}'}
        where ${key.fieldName}=${r'#{'+key.fieldName+'}'}
        and ${deleteColumn}!=${deleteValue}
    </update>
    </#list>
</#if>

<#--为联合主键生成查询方法-->
<#assign updateSql=''/>
<#if keys??>
<#--如果只有一列则不执行-->
    <#if (keys?size>1)>
        <#assign methodName=''/>
        <#assign params=''/>
        <#list keys as key>
            <#if key?is_last>
                <#assign methodName = methodName + key.fieldName?cap_first />
                <#assign params = params + key.fieldName+'='+r'#{'+key.fieldName+'} ' />
                <#assign updateSql = params + key.fieldName+'='+r'#{entity.'+key.fieldName+'} ' />
            <#else>
                <#assign methodName = methodName + key.fieldName?cap_first + 'And' />
                <#assign params = params + key.fieldName+'='+r'#{'+key.fieldName+'} and ' />
                <#assign updateSql = params + key.fieldName+'='+r'#{entity.'+key.fieldName+'} and ' />
            </#if>
        </#list>
    <select id="query${entityName?cap_first}By${methodName}" resultMap="resultMap">
        select <include refid="columns"/>
        from <include refid="tableName"/>
        where ${params}
        <#if queryDefault??>
        and ${queryDefault}
        </#if>
    </select>

    <update id="delete${entityName?cap_first}By${methodName}">
        update <include refid="tableName"/>
        set ${deleteColumn}=${deleteValue}, ${updaterColumn}=${r'#{operator}'}
        where ${params}
        and ${deleteColumn}!=${deleteValue}
    </update>

    </#if>
</#if>

<#--生成更新方法-->
<#if keys??>
${'<!-- update entity -->'}
    <update id="update${entityName?cap_first}" parameterType="${package}.entity.${entityName}">
        update
        <include refid="tableName"/>
        set
        <#if columns??>
        <#assign index = 0/>
            <#list columns as column>
                <#if !isColumnInKeys(column.columnName, keys)>
                    <#assign index = index+1/>
                    <#if index==(columns?size-keys?size!0)>
            ${column.columnName} = ${r'#{entity'+'.'+column.fieldName+'}'}
                    <#else >
            ${column.columnName} = ${r'#{entity'+'.'+column.fieldName+'}'},
                    </#if>
                </#if>
            </#list>
        </#if>
        where ${updateSql} and ${deleteColumn}!=${deleteValue}
    </update>
</#if>

<#--根据索引生成查询方法-->
<#if indexes??>
    <#list indexes as index>
        <#if index.columns??>
            <#assign methodName=''/>
            <#list index.columns as col>
                <#if col?is_last>
                    <#assign methodName=methodName+col.fieldName?cap_first/>
                <#else>
                    <#assign methodName=methodName+col.fieldName?cap_first+'And'/>
                </#if>
            </#list>
    <select id="query${entityName?cap_first}By${methodName}" resultMap="resultMap">
        select <include refid="columns"/>
        from <include refid="tableName"/>
        where 1=1
        <#if queryDefault??>
        and ${queryDefault}
        </#if>
        <#list index.columns as col>
        <if test="${col.fieldName}!=null">
            and ${col.columnName}=${r'#{'+col.fieldName+'}'}
        </if>
        </#list>
    </select>
        </#if>
    </#list>
</#if>
    <update id="updateAvailDataFlag">
        update <include refid="tableName"/>
        set sys_avail_data=${r'#{flag}'}
        where id in
        <foreach collection="ids" item="id" separator="," open="(" close=")">
            ${r'#{id}'}
        </foreach>
    </update>
</mapper>