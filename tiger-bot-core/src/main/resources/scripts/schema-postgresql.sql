-- AI供应商表
CREATE TABLE IF NOT EXISTS ai_providers (
    id BIGSERIAL PRIMARY KEY,
    provider_type VARCHAR(128) NOT NULL,
    provider_name VARCHAR(128) NOT NULL,
    api_key TEXT NOT NULL,
    base_url VARCHAR(128) NOT NULL
);

COMMENT ON TABLE ai_providers IS 'AI供应商表';
COMMENT ON COLUMN ai_providers.id IS '主键，AI供应商ID';
COMMENT ON COLUMN ai_providers.provider_type IS '供应商类型';
COMMENT ON COLUMN ai_providers.provider_name IS '供应商名称';
COMMENT ON COLUMN ai_providers.api_key IS 'API密钥';
COMMENT ON COLUMN ai_providers.base_url IS '基础URL';
-- AI模型表

CREATE TABLE IF NOT EXISTS ai_models (
    id BIGSERIAL PRIMARY KEY,
    ai_provider_id BIGINT NOT NULL,
    model_name VARCHAR(128) NOT NULL,
    description TEXT NOT NULL,
    max_tokens INT NOT NULL,
    max_output_tokens INT NOT NULL,
    reasoning_flg BOOLEAN NOT NULL,
    stream_flg BOOLEAN NOT NULL,
    enabled BOOLEAN NOT NULL,
    tool_call_flg BOOLEAN NOT NULL,
    params VARCHAR(255) NOT NULL
);

COMMENT ON TABLE ai_models IS 'AI模型表';
COMMENT ON COLUMN ai_models.id IS '主键，AI模型ID';
COMMENT ON COLUMN ai_models.ai_provider_id IS 'AI供应商ID';
COMMENT ON COLUMN ai_models.model_name IS '模型名称';
COMMENT ON COLUMN ai_models.max_tokens IS '最大令牌数';
COMMENT ON COLUMN ai_models.max_output_tokens IS '最大输出令牌数';
COMMENT ON COLUMN ai_models.reasoning_flg IS '推理功能';
COMMENT ON COLUMN ai_models.stream_flg IS '流式输出';
COMMENT ON COLUMN ai_models.enabled IS '是否激活';
COMMENT ON COLUMN ai_models.tool_call_flg IS '工具调用';
COMMENT ON COLUMN ai_models.params IS '参数';


-- AI角色表
CREATE TABLE IF NOT EXISTS ai_roles (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    prompt_content TEXT NOT NULL,
    extra_memory TEXT NOT NULL,
    prompt_type VARCHAR(128) NOT NULL
);

COMMENT ON TABLE ai_roles IS 'AI角色表';
COMMENT ON COLUMN ai_roles.id IS '主键，AI角色ID';
COMMENT ON COLUMN ai_roles.name IS '角色名称';
COMMENT ON COLUMN ai_roles.prompt_content IS '提示内容';
COMMENT ON COLUMN ai_roles.extra_memory IS '额外记忆';
COMMENT ON COLUMN ai_roles.prompt_type IS '提示类型';


-- 聊天对象表
CREATE TABLE IF NOT EXISTS chats (
                                     id BIGSERIAL PRIMARY KEY,
                                     name VARCHAR(128) NOT NULL,
                                     group_flag BOOLEAN DEFAULT FALSE,
                                     ai_provider_id BIGINT NOT NULL,
                                     ai_model_id BIGINT NOT NULL,
                                     ai_role_id BIGINT NOT NULL
);

COMMENT ON TABLE chats IS '聊天对象表';
COMMENT ON COLUMN chats.id IS '主键，聊天对象ID';
COMMENT ON COLUMN chats.name IS '聊天名称（群名或私聊名）';
COMMENT ON COLUMN chats.group_flag IS '是否为群聊';
COMMENT ON COLUMN chats.ai_provider_id IS 'AI供应商ID';
COMMENT ON COLUMN chats.ai_model_id IS 'AI模型ID';
COMMENT ON COLUMN chats.ai_role_id IS 'AI角色ID';

-- 命令表
CREATE TABLE IF NOT EXISTS commands (
                                        id BIGSERIAL PRIMARY KEY,
                                        pattern VARCHAR(128) NOT NULL,
                                        description VARCHAR(255),
                                        ai_provider_id BIGINT NULL,
                                        ai_model_id BIGINT NULL,
                                        ai_role_id BIGINT NULL
);

COMMENT ON TABLE commands IS '命令表';
COMMENT ON COLUMN commands.id IS '主键，命令ID';
COMMENT ON COLUMN commands.pattern IS '命令的正则或名称';
COMMENT ON COLUMN commands.description IS '命令描述';
COMMENT ON COLUMN commands.ai_provider_id IS 'AI供应商ID';
COMMENT ON COLUMN commands.ai_model_id IS 'AI模型ID';
COMMENT ON COLUMN commands.ai_role_id IS 'AI角色ID';

-- 用户表
CREATE TABLE IF NOT EXISTS users (
                                     id BIGSERIAL PRIMARY KEY,
                                     username VARCHAR(128) NOT NULL,
                                     remark VARCHAR(255)
);

COMMENT ON TABLE users IS '用户表';
COMMENT ON COLUMN users.id IS '主键，用户ID';
COMMENT ON COLUMN users.username IS '用户名';
COMMENT ON COLUMN users.remark IS '用户备注';

-- 聊天-命令-用户权限表
CREATE TABLE IF NOT EXISTS chat_command_auths (
                                                  id BIGSERIAL PRIMARY KEY,
                                                  chat_id BIGINT NOT NULL,
                                                  command_id BIGINT NOT NULL,
                                                  user_id BIGINT NOT NULL
);

COMMENT ON TABLE chat_command_auths IS '聊天-命令-用户权限表';
COMMENT ON COLUMN chat_command_auths.id IS '主键';
COMMENT ON COLUMN chat_command_auths.chat_id IS '聊天对象ID';
COMMENT ON COLUMN chat_command_auths.command_id IS '命令ID';
COMMENT ON COLUMN chat_command_auths.user_id IS '用户ID，允许为null表示所有人可用';

-- 监听列表表
CREATE TABLE IF NOT EXISTS listeners (
                                         id BIGSERIAL PRIMARY KEY,
                                         chat_id BIGINT NOT NULL,
                                         at_reply_enable BOOLEAN DEFAULT FALSE,
                                         keyword_reply_enable BOOLEAN DEFAULT FALSE,
                                         save_pic BOOLEAN DEFAULT FALSE,
                                         save_voice BOOLEAN DEFAULT FALSE,
                                         parse_links BOOLEAN DEFAULT FALSE,
                                         keyword_reply VARCHAR(255)
);

COMMENT ON TABLE listeners IS '监听列表表';
COMMENT ON COLUMN listeners.id IS '主键，监听ID';
COMMENT ON COLUMN listeners.chat_id IS '监听的对象id';
COMMENT ON COLUMN listeners.at_reply_enable IS '是否开启@回复';
COMMENT ON COLUMN listeners.keyword_reply_enable IS '是否开启关键词回复';
COMMENT ON COLUMN listeners.save_pic IS '是否保存图片';
COMMENT ON COLUMN listeners.save_voice IS '是否保存语音';
COMMENT ON COLUMN listeners.parse_links IS '是否解析链接';
COMMENT ON COLUMN listeners.keyword_reply IS '关键词回复，逗号分隔';


-- 消息表
CREATE TABLE IF NOT EXISTS messages (
                                        id BIGSERIAL PRIMARY KEY,
                                        chat_id BIGINT NOT NULL,
                                        type VARCHAR(128) NOT NULL,
                                        content TEXT NOT NULL,
                                        sender VARCHAR(128) NOT NULL,
                                        time TIMESTAMP NOT NULL,
                                        info TEXT NOT NULL,
                                        sender_remark VARCHAR(255)
);

COMMENT ON TABLE messages IS '消息表'; 
COMMENT ON COLUMN messages.id IS '主键，消息ID';
COMMENT ON COLUMN messages.chat_id IS '聊天对象ID';
COMMENT ON COLUMN messages.type IS '消息类型';
COMMENT ON COLUMN messages.content IS '消息内容';
COMMENT ON COLUMN messages.sender IS '发送者';
COMMENT ON COLUMN messages.time IS '消息时间';
COMMENT ON COLUMN messages.info IS '消息信息';
COMMENT ON COLUMN messages.sender_remark IS '发送者备注';

-- 插件表
CREATE TABLE IF NOT EXISTS plugins (
    id BIGSERIAL PRIMARY KEY,
    plugin_id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    version VARCHAR(100),
    author VARCHAR(255),
    description TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'DISABLED',
    source_url VARCHAR(500),
    source_path VARCHAR(500),
    size DECIMAL(10,2),
    parameters TEXT,
    load_type VARCHAR(50) NOT NULL,
    plugin_type VARCHAR(50),
    installed_at TIMESTAMP,
    updated_at TIMESTAMP,
    last_loaded_at TIMESTAMP,
    last_unloaded_at TIMESTAMP
);

COMMENT ON TABLE plugins IS '插件表';
COMMENT ON COLUMN plugins.id IS '主键，插件ID';
COMMENT ON COLUMN plugins.plugin_id IS '主键，插件ID';
COMMENT ON COLUMN plugins.name IS '插件名称';
COMMENT ON COLUMN plugins.version IS '插件版本';
COMMENT ON COLUMN plugins.author IS '插件作者';
COMMENT ON COLUMN plugins.description IS '插件描述';
COMMENT ON COLUMN plugins.status IS '插件状态（ENABLED, DISABLED, ERROR）';
COMMENT ON COLUMN plugins.source_url IS '插件源URL';
COMMENT ON COLUMN plugins.source_path IS '插件源路径';
COMMENT ON COLUMN plugins.size IS '插件文件大小（MB）';
COMMENT ON COLUMN plugins.parameters IS '插件参数（JSON格式）';
COMMENT ON COLUMN plugins.load_type IS '加载类型（REMOTE, LOCAL, SYSTEM）';
COMMENT ON COLUMN plugins.plugin_type IS '插件类型（MESSAGE_HANDLER, COMMAND_HANDLER）';
COMMENT ON COLUMN plugins.installed_at IS '安装时间';
COMMENT ON COLUMN plugins.updated_at IS '更新时间';
COMMENT ON COLUMN plugins.last_loaded_at IS '最后加载时间';
COMMENT ON COLUMN plugins.last_unloaded_at IS '最后卸载时间';

