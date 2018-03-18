<#function isColumnInKeys columnName keys>
    <#if !keys??>
        <#return false/>
    </#if>
    <#list keys as key>
        <#if key.columnName == columnName>
            <#return true/>
        </#if>
    </#list>
    <#return false/>
</#function>