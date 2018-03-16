package ${package}.dao;

import ${package}.entity.${entityName};

import org.apache.ibatis.annotations.Param;
import java.util.*;

/**
* 描述：${tableComment}
* @author ${author}
* @date ${date}
*/
public interface ${entityName}Dao {
    int save(@Param("entity")${entityName} entity);

    int saveBatch(@Param("entities")List<${entityName}> entities);

    int update(@Param("entity")${entityName} entity);

    ${entityName} getByKey(@Param("key")String key);

    int deleteByKey(String key);
}