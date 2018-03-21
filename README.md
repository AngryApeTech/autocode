# 功能介绍
生成基于Spring + MyBatis Mapper 对应的java文件，包括Entity、Mapper、Dao、Service、ServiceImpl 文件。

# 注意
1. 目前仅可生成table对应的文件
2. 表必须有唯一主键，用于设置可用性标识
3. 表名必须符合`t_` + `模块名` + `_` + `表功能描述` 的格式。若表功能表述需要多个单词，以`_`分隔，代码中将自动以驼峰命名法表示。

# 功能列表
1. 指定某个表，生成代码:`table.pattern=表名`
2. 指定符合某种规则的表，生成代码：`table.pattern=[pattern]`, pattern 与sql like 语法相同，`%` 表示全部，`t_%`表示以“t_”开头的表
3. 目前生成的文件中，包含以下方法：
    - 单个保存
    - 批量保存
    - 根据主键查找
    - 根据主键删除对象
    - 更新对象（没有主键时不生成）
    - 根据索引查找。为所有索引列生成一个查询方法
    
# 配置项列表

|配置项|默认|说明|
|----|----|--|
|author|AngryApe|作者|
|--数据库连接--|-|-|
|jdbc.dialect|-|暂时不生效|
|jdbc.driver|-|-|
|jdbc.url|-|-|
|jdbc.user|-|-|
|jdbc.password|-|-|
|--表相关--|-|-|
|table.pattern|-|-|
|columns.sys|-|-|
|column.updater|-|-|
|column.delete|-|-|
|column.delete.value|-|-|
|query.default|-|-|
|--输出相关--|-|-|
|package.name|-|-|
|file.path|-|D://|



    