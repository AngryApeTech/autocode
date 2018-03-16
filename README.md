# 功能介绍
生成基于Spring + MyBatis Mapper 对应的java文件，包括Entity、Mapper、Dao、Service、ServiceImpl 文件。

# 注意
1. 目前仅可生成table对应的文件
2. 表必须有主键

# 功能列表
1. 指定某个表，生成代码:`table.pattern=表名`
2. 指定符合某种规则的表，生成代码：`table.pattern=[pattern]`, pattern 与sql like 语法相同，`%` 表示全部，`t_%`表示以“t_”开头的表
3. 目前生成的文件中，包含以下方法：
  - 单个保存
  - 批量保存
  - 根据主键查找
  - 更新对象（主键必须有值）
  - 根据主键删除对象