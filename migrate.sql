-- 教学文档管理系统 数据库表

-- 课程表
CREATE TABLE IF NOT EXISTS td_courses (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 文档表（存储结构化内容）
CREATE TABLE IF NOT EXISTS td_documents (
    id TEXT PRIMARY KEY,
    course_id TEXT REFERENCES td_courses(id),
    doc_type TEXT NOT NULL, -- 大纲/教案/指导书/教学手册/申报表
    year INTEGER,
    title TEXT,
    content_json TEXT, -- 结构化内容（JSON格式）
    original_file_name TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS td_documents_course ON td_documents(course_id);
CREATE INDEX IF NOT EXISTS td_documents_type ON td_documents(doc_type);

-- 试卷题目表
CREATE TABLE IF NOT EXISTS td_questions (
    id TEXT PRIMARY KEY,
    course_id TEXT REFERENCES td_courses(id),
    question_type TEXT NOT NULL, -- 选择/填空/简答/论述/实践
    content TEXT NOT NULL,
    answer TEXT,
    tags TEXT, -- 逗号分隔的知识点标签
    difficulty TEXT DEFAULT '中', -- 易/中/难
    score INTEGER DEFAULT 10,
    source_file TEXT, -- 来源文件
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS td_questions_course ON td_questions(course_id);
CREATE INDEX IF NOT EXISTS td_questions_type ON td_questions(question_type);

-- 生成的试卷表
CREATE TABLE IF NOT EXISTS td_exam_papers (
    id TEXT PRIMARY KEY,
    course_id TEXT REFERENCES td_courses(id),
    year INTEGER NOT NULL,
    paper_type TEXT NOT NULL, -- A卷/B卷
    title TEXT,
    questions_json TEXT, -- 包含题号、内容、答案、分值
    total_score INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 模板表（存储教务处模板的字段映射）
CREATE TABLE IF NOT EXISTS td_templates (
    id TEXT PRIMARY KEY,
    course_id TEXT REFERENCES td_courses(id),
    doc_type TEXT NOT NULL,
    template_name TEXT,
    field_mapping_json TEXT, -- 字段映射关系
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS td_templates_course ON td_templates(course_id);

-- 初始化两门课程
INSERT INTO td_courses (id, name, description) VALUES
    ('storyfilm', '故事片创作实践', '影视摄影与制作专业核心实践课程'),
    ('cinematography', '电影摄影造型技巧', '摄影艺术与技术系专业技术课');
