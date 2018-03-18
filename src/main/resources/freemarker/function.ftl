<#function isColumnInKeys columnName keys>
    <#list keys as key>
        <#if key.columnName == columnName>
            <#return true/>
        </#if>
    </#list>
    <#return false/>
</#function>