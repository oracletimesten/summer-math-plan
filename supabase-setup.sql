-- ============================================================
-- 奥数暑假集训管理系统 - Supabase 建表脚本
-- 请在 Supabase Dashboard > SQL Editor 中执行此脚本
-- ============================================================

-- 1. 创建学习模块表
CREATE TABLE IF NOT EXISTS training_modules (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    phase TEXT NOT NULL,
    start_week INTEGER NOT NULL DEFAULT 1,
    end_week INTEGER NOT NULL DEFAULT 1,
    color TEXT NOT NULL DEFAULT '#3d7a6e',
    topics TEXT[] DEFAULT '{}',
    plans TEXT DEFAULT '',
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. 添加注释
COMMENT ON TABLE training_modules IS '奥数暑假集训学习模块';
COMMENT ON COLUMN training_modules.name IS '模块名称';
COMMENT ON COLUMN training_modules.phase IS '所属阶段';
COMMENT ON COLUMN training_modules.start_week IS '开始周次';
COMMENT ON COLUMN training_modules.end_week IS '结束周次';
COMMENT ON COLUMN training_modules.color IS '颜色标记';
COMMENT ON COLUMN training_modules.topics IS '知识点列表';
COMMENT ON COLUMN training_modules.plans IS '每日安排';
COMMENT ON COLUMN training_modules.completed IS '是否完成';
COMMENT ON COLUMN training_modules.sort_order IS '排序序号';

-- 3. 启用 RLS（行级安全策略）
ALTER TABLE training_modules ENABLE ROW LEVEL SECURITY;

-- 4. 创建 RLS 策略：允许所有匿名用户读写（适合个人使用）
CREATE POLICY "Allow anonymous read" ON training_modules
    FOR SELECT USING (true);

CREATE POLICY "Allow anonymous insert" ON training_modules
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow anonymous update" ON training_modules
    FOR UPDATE USING (true) WITH CHECK (true);

CREATE POLICY "Allow anonymous delete" ON training_modules
    FOR DELETE USING (true);

-- 5. 创建自动更新 updated_at 的触发器
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_training_modules_updated_at
    BEFORE UPDATE ON training_modules
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 6. 插入初始数据
INSERT INTO training_modules (name, phase, start_week, end_week, color, topics, plans, sort_order) VALUES
('分数四则混合运算', '阶段一：数与运算', 1, 1, '#3d7a6e', ARRAY['分数加减法', '分数乘除法', '运算顺序', '简便运算'], 'Day 1-2：复习分数基本概念，做分数加减法练习（30题）
Day 3-4：分数乘除法练习，重点练约分（30题）
Day 5-6：混合运算综合练习，注意运算顺序（20题）
Day 7：错题复盘 + 简便运算专项（15题）', 1),
('分数巧算', '阶段一：数与运算', 2, 2, '#5a9e8e', ARRAY['连锁约分', '提取公因数', '整体约分', '凑整'], 'Day 1-2：连锁约分与整体约分（20题）
Day 3：提取公因数与凑整（15题）
Day 4-5：综合巧算练习（20题）
Day 6-7：错题复盘', 2),
('循环小数', '阶段一：数与运算', 2, 2, '#7ab8aa', ARRAY['循环节认识', '纯循环/混循环', '化分数', '循环小数运算'], 'Day 1：循环小数的认识和分类
Day 2-3：循环小数化分数的方法（20题）
Day 4-5：循环小数运算练习（15题）
Day 6-7：综合练习 + 错题复盘', 3),
('比的应用', '阶段一：数与运算', 5, 5, '#9dd2c6', ARRAY['按比分配', '连比', '比与分数转换'], 'Day 1-2：按比分配练习（20题）
Day 3：连比问题（15题）
Day 4-5：比与分数综合应用（20题）
Day 6-7：错题复盘', 4),
('余数问题与同余', '阶段二：数论入门', 3, 3, '#d4a04a', ARRAY['带余除法', '同余性质', '逐步满足法', '公倍数法'], 'Day 1：复习带余除法
Day 2-3：同余的概念和基本性质（15题）
Day 4-5："相同的余数"问题（15题）
Day 6：逐步满足法（10题）
Day 7：综合练习 + 错题复盘', 5),
('因数个数定理', '阶段二：数论入门', 4, 4, '#c9a227', ARRAY['质因数分解', '因数个数公式', '因数和公式', '特殊因数'], 'Day 1-2：质因数分解练习（30题）
Day 3-4：因数个数定理学习与应用（20题）
Day 5：因数和定理（10题）
Day 6：特殊因数（15题）
Day 7：综合练习 + 错题复盘', 6),
('四边形中的面积关系', '阶段三：几何进阶', 5, 5, '#b85c3e', ARRAY['等积变形', '一半模型', '蝴蝶模型', '梯形面积关系'], 'Day 1-2：等积变形（15题）
Day 3：一半模型（15题）
Day 4-5：梯形蝴蝶模型（15题）
Day 6-7：综合练习 + 错题复盘', 7),
('燕尾模型与共边三角形', '阶段三：几何进阶', 6, 6, '#c75b39', ARRAY['燕尾定理', '共边定理', '设份数法', '面积比与线段比'], 'Day 1-2：燕尾模型学习和设份数（15题）
Day 3：共边三角形与燕尾综合（10题）
Day 4-5：综合练习（20题）
Day 6-7：错题复盘', 8),
('圆与扇形', '阶段三：几何进阶', 6, 6, '#d97a5c', ARRAY['圆周长', '圆面积', '扇形弧长', '扇形面积', '圆环面积'], 'Day 1-2：圆的周长和面积（15题）
Day 3-4：扇形弧长和面积（15题）
Day 5：圆环与组合图形（10题）
Day 6-7：综合练习 + 错题复盘', 9),
('多次相遇行程问题', '阶段四：应用题专题', 7, 7, '#8b7ab8', ARRAY['直线多次相遇', '环形跑道', '速度比', '份数法'], 'Day 1-2：理解多次相遇规律，做基础题（10题）
Day 3-4：直线多次相遇综合（15题）
Day 5：环形跑道相遇问题（10题）
Day 6：速度比与份数法（10题）
Day 7：综合练习 + 错题复盘', 10),
('水中浸物', '阶段四：应用题专题', 8, 8, '#a89cd4', ARRAY['完全浸没', '不完全浸没', '水溢出', '水位变化'], 'Day 1-2：完全浸没与不完全浸没（15题）
Day 3：水溢出判断与计算（10题）
Day 4-5：综合练习（15题）
Day 6-7：错题复盘', 11),
('分类枚举', '阶段四：应用题专题', 8, 8, '#c4b8e0', ARRAY['有序枚举', '分类标准', '树形图', '加法原理'], 'Day 1-2：有序枚举练习（15题）
Day 3-4：树形图与分类枚举（15题）
Day 5-7：综合练习 + 错题复盘', 12),
('染色与覆盖', '阶段四：应用题专题', 8, 8, '#ddd5ec', ARRAY['染色法', '奇偶性分析', '覆盖问题', '逻辑推理'], 'Day 1-2：染色法基本概念（10题）
Day 3-4：覆盖问题（10题）
Day 5-7：综合练习 + 错题复盘', 13);

-- 验证数据
SELECT count(*) as module_count FROM training_modules;
SELECT id, name, phase, start_week, end_week FROM training_modules ORDER BY sort_order;
