<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//ibatis.apache.org//DTD Mapper 3.0//EN"
        "http://ibatis.apache.org/dtd/ibatis-3-mapper.dtd">
<mapper namespace="${package}.dao.${tableName}Dao">

    <resultMap id="resultMap" type="${package}.dto.${tableName}Entity">
        <#if columns??>
            <#list columns as column>
        <result property="${column.columnName}" column="${column.columnName}" jdbcType="${column.jdbcType}"/>
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

<#-- single entity save -->
    <insert id="save">
        insert into
        <include refid="tableName"/>
        (<include refid="columns"/>) values
        (
        <#if columns??>
            <#list columns as column>
                <#if column?is_last>
            ${r'#{entity'+'.'+column.columnName+'}'}
                <#else >
            ${r'#{entity'+'.'+column.columnName+'}'},
                </#if>
            </#list>
        </#if>
        )
    </insert>

<#-- mutipule entity save -->
    <insert id="insertBatch">
        insert into
        <include refid="tableName"/>
        (<include refid="columns"/>) values
        <foreach collection="entities" open="(" close=")" item="entity" separator=",">
        (
            <#if columns??>
                <#list columns as column>
                    <#if column?is_last>
            ${r'#{entity'+'.'+column.columnName+'}'}
                    <#else >
            ${r'#{entity'+'.'+column.columnName+'}'},
                    </#if>
                </#list>
            </#if>
        )
        </foreach>
    </insert>

<#-- get entity by key -->
    <select id="getByKey" resultMap="resultMap">
        select <include refid="columns"/>
        from <include refid="tableName"/>
        where ${keyName} = ${r'#{key}'}
    </select>

<#-- update entity -->
    <update id="update" parameterType="${package}.entity.${entityName}">
        update
        <include refid="tableName"/>
        set
        <#if columns??>
            <#list columns as column>
                <#if column.columnName != keyName>
                    <#if column?is_last>
            ${column.columnName} = ${r'#{entity'+'.'+column.columnName+'}'}
                    <#else >
                        ${r'#{entity'+'.'+column.columnName+'}'},
                    </#if>
                </#if>
            </#list>
        </#if>
        where ${keyName} = ${r'#{entity'+'.'+ keyField +'}'},
    </update>

<#-- delete entity by key -->
    <update id="deleteByKey">
        update
        <include refid="tableName"/>
        set ${deleteColumn}=1 where ${deleteColumn}=0 and ${keyName}=${r'#{key}'}
    </update>

</mapper>