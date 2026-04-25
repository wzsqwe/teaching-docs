# 教学文档管理系统 - 功能规格

## 一、定位

帮助高校教师管理教学文档（大纲/教案/指导书/教学手册/试卷），实现：
1. 内容结构化存储，历史版本永不丢失
2. 教务处发来新模板时，内容自动填入，保留原格式
3. 试卷题库管理，支持随机组卷生成AB卷

## 二、课程与文档结构

### 2.1 课程列表
| ID | 课程名 | 文档类型 |
|----|--------|---------|
| storyfilm | 故事片创作实践 | 大纲、指导书、教学手册、教案、申报表 |
| cinematography | 电影摄影造型技巧 | 大纲、试卷库 |

### 2.2 大纲字段（结构化）
- 课程名称、课程类别、学时、学分
- 课程简介（课程内容）
- 课程设计理念（6条）
- 素质目标、知识目标、能力目标（各若干条）
- 课程目标对毕业要求的支撑
- 考核方式、成绩构成
- 参考书

### 2.3 教案字段
- 课程名称、授课教师、开课单位、授课对象
- 章节内容、授课学时、课程类型
- 教学目标（素质/知识/能力）
- 教学重点与难点
- 教学过程设计（课前/课中/课后）

### 2.4 试卷字段
- 题型：选择题、填空题、简答题、论述题、实践题
- 题目内容、答案、知识点标签、分值
- 难度等级（易/中/难）

## 三、核心功能

### 3.1 课程首页
- 展示两门课程卡片
- 点击进入课程详情页

### 3.2 课程详情页
- Tab切换：大纲 | 教案 | 指导书 | 教学手册 | 试卷
- 每类文档显示版本列表（年份标注）
- 上传/编辑/删除/查看
- 查看历史版本

### 3.3 文档编辑
- 从Word文件导入，自动解析结构化字段
- 字段编辑器：各字段逐一编辑
- 支持导出Word（套模板）

### 3.4 智能填入（新模板 → 内容填充）
流程：
1. 上传教务处发来的新模板Word
2. 系统读取模板结构（标题/段落/表格）
3. 基于关键词匹配内容字段
4. 预览匹配结果（可修改）
5. 导出保留原格式的Word

### 3.5 试卷管理
- 上传已有试卷，自动识别题目
- 手动补充题目（题型/知识点/分值/难度）
- 随机组卷：选题型、每种题数量、分值，系统随机抽
- 生成AB卷Word

## 四、技术方案

### 4.1 架构
- 前端：单HTML（和Studio共用Supabase）
- 后端处理：Python脚本（Word读写、PDF转换）
- 数据存储：Supabase

### 4.2 数据表
```
courses: id, name, description, created_at
documents: id, course_id, type, year, content_json, original_file, created_at
questions: id, course_id, type, content, answer, tags, difficulty, score, created_at
exam_papers: id, course_id, year, type(A/B), questions_json, created_at
templates: id, course_id, type, name, file_content, field_mapping_json, created_at
```

### 4.3 Word处理
- 读取：python-docx / pandoc
- 写入：docx-js（Node.js生成Word）
- 智能匹配：基于标题关键词（"课程基本信息"/"教学目标"/"素质目标"等）

## 五、界面风格

- 简洁紧凑（和Studio一致）
- 左侧课程列表 + 右侧文档区
- 卡片式文档列表
- 表格式字段编辑器
- 进度条/状态提示

## 六、部署

- GitHub Pages（和Studio同一仓库不同文件夹）
- 访问路径：https://wzsqwe.github.io/studio-teaching/
