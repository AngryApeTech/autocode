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
    * 批量保存
    */
    DataResult${'<Boolean>'} save${entityName}Batch(String ${entityName?uncap_first}Json);

    /**
    * 根据Code获取对象
    */
    DataResult<${entityName}> get${entityName}ByCode(String code);

    /**
    * 更新对象
    */
    DataResult${'<Boolean>'} update${entityName}(
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
    DataResult${'<Boolean>'} delete${entityName}ByCode(String code);
}