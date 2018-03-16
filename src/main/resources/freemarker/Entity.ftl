package ${package}.entity;

import java.util.*;
import java.math.BigDecimal;

/**
* 描述：${tableComment}
* @author ${author}
* @date ${date}
*/
public class ${entityName} extends BaseEntity {

<#if columns??>
    <#list columns as column>
    /**
    *${column.comment!}
    */
    private ${column.javaType?split(".")?last} ${column.fieldName?uncap_first};

    </#list>
</#if>

<#if columns??>
    <#list columns as column>
    public ${column.javaType?split(".")?last} get${column.fieldName?cap_first}() {
        return this.${column.fieldName?uncap_first};
    }

    public void set${column.fieldName?cap_first}(${column.javaType?split(".")?last} ${column.fieldName?uncap_first}) {
        this.${column.fieldName?uncap_first} = ${column.fieldName?uncap_first};
    }

    </#list>
</#if>

}