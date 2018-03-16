package ${package_name}.model;
import com.evada.inno.common.domain.BaseModel;
import com.evada.inno.common.listener.ICreateListenable;
import com.evada.inno.common.listener.IDeleteListenable;
import com.evada.inno.common.listener.IModifyListenable;
import org.hibernate.annotations.Where;
import javax.persistence.*;
import java.util.Date;

/**
* 描述：${table_annotation}模型
* @author ${author}
* @date ${date}
*/
@Entity
@Table(name="${table_name_small}")
@Where(clause = "status > '0'")
@Inheritance(strategy= InheritanceType.SINGLE_TABLE)
public class ${table_name} extends BaseModel implements ICreateListenable,IModifyListenable,IDeleteListenable {

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