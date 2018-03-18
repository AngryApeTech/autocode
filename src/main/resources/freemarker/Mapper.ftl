<#include 'function.ftl'/>
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//ibatis.apache.org//DTD Mapper 3.0//EN"
        "http://ibatis.apache.org/dtd/ibatis-3-mapper.dtd">
<mapper namespace="${package}.dao.${tableName}Dao">

    <resultMap id="resultMap" type="${package}.dto.${tableName}Entity">
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

    ${'<!-- single entity save -->'}
    <insert id="save">
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

    ${'<!-- mutipule entity save -->'}
    <insert id="insertBatch">
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

<#if keys??>
    <#list keys as key>
    ${'<!-- get entity by '+key.fieldName+' -->'}
    <select id="getBy${key.fieldName?cap_first}" resultMap="resultMap">
        select <include refid="columns"/>
        from <include refid="tableName"/>
        where ${key.fieldName} = ${r'#{'+key.fieldName+'}'}
        and ${queryDefault}
    </select>

    <update id="deleteBy${key.fieldName?cap_first}">
        update <include refid="tableName"/>
        set ${deleteColumn}=${deleteValue}, ${updaterColumn}=${r'#{operator}'}
        where ${key.fieldName}=${r'#{'+key.fieldName+'}'}
        and ${deleteColumn}!=${deleteValue}
    </update>
    </#list>
</#if>

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
    <select id="getBy${methodName}" resultMap="resultMap">
        select <include refid="columns"/>
        from <include refid="tableName"/>
        where ${params}
        and ${queryDefault}
    </select>

    <update id="deleteBy${methodName}">
        update <include refid="tableName"/>
        set ${deleteColumn}=${deleteValue}, ${updaterColumn}=${r'#{operator}'}
        where ${params}
        and ${deleteColumn}!=${deleteValue}
    </update>

    </#if>
</#if>

${'<!-- update entity -->'}
    <update id="update" parameterType="${package}.entity.${entityName}">
        update
        <include refid="tableName"/>
        set
        <#if columns??>
        <#assign index = 0/>
            <#list columns as column>
                <#if !isColumnInKeys(column.columnName, keys)>
                    <#assign index = index+1/>
                    <#if index==(columns?size-keys?size)>
            ${column.columnName} = ${r'#{entity'+'.'+column.fieldName+'}'}
                    <#else >
            ${column.columnName} = ${r'#{entity'+'.'+column.fieldName+'}'},
                    </#if>
                </#if>
            </#list>
        </#if>
        where ${updateSql} and ${deleteColumn}!=${deleteValue}
    </update>

</mapper>