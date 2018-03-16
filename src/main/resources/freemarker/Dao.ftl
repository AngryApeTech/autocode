package ${packageName}.dao;

import ${packageName}.entity.${table_name};

import org.apache.ibatis.annotations.Param;
import java.util.*;

/**
* 描述：${table_annotation}Dao
* @author ${author}
* @date ${date}
*/
public interface ${table_name}Dao {
    save(@Param("entity")${table_name} entity);

    saveBatch(@Param("entities")List<${table_name}> entities);

    update(@Param("entity")${table_name} entity);

    getByKey(String key);

    deleteByKey(String key);
}