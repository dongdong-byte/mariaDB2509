package kim.projectdockerdb.mapper;


import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface UniversalMapper {
    @Select("select * from ${tableName}")
    List<Map<String, Object>> findAll(@Param("tableName") String tableName);

}
