package ${package};

<#list imports as imp>
import ${imp};
</#list>

/**
* 描述：${table_annotation}模型
* @author ${author}
* @date ${date}
*/
public class ${className} extends BaseEntity {

<#if model_column?exists>
    <#list model_column as model>
    /**
    *${model.comment!}
    */
        <#if (model.jdbcType = 'varchar' || model.jdbcType = 'text')>
    @Column(name = "${model.columnName}",columnDefinition = "VARCHAR")
    private String ${model.fieldName?uncap_first};

        </#if>
        <#if model.jdbcType = 'timestamp' >
    @Column(name = "${model.columnName}",columnDefinition = "TIMESTAMP")
    private Date ${model.fieldName?uncap_first};

        </#if>
    </#list>
</#if>

<#if model_column?exists>
    <#list model_column as model>
        <#if (model.jdbcType = 'varchar' || model.jdbcType = 'text')>
    public String get${model.fieldName}() {
        return this.${model.fieldName?uncap_first};
    }

    public void set${model.fieldName}(String ${model.fieldName?uncap_first}) {
        this.${model.fieldName?uncap_first} = ${model.fieldName?uncap_first};
    }

        </#if>
        <#if model.jdbcType = 'timestamp' >
    public Date get${model.fieldName}() {
        return this.${model.fieldName?uncap_first};
    }

    public void set${model.fieldName}(Date ${model.fieldName?uncap_first}) {
        this.${model.fieldName?uncap_first} = ${model.fieldName?uncap_first};
    }

        </#if>
    </#list>
</#if>

}