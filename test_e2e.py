"""端到端验证：SSL 修复 + DeepSeek API 连通性"""
import sys, os, json, httpx
sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

from dotenv import load_dotenv
load_dotenv(".env")

api_key = os.environ.get("DEEPSEEK_API_KEY", "")
print(f"=== E2E 验证 ===")
print(f"API Key: {'✅ 已配置' if api_key else '❌ 未配置'}")

# 1. 验证 SSL 修复 —— 用 verify=False 模拟用户环境
print(f"\n--- 1. SSL 修复验证 ---")
from tradingagents.llm_clients.openai_client import OpenAIClient
from tradingagents.default_config import DEFAULT_CONFIG

print(f"ssl_verify 默认值: {DEFAULT_CONFIG['ssl_verify']}")
client = OpenAIClient("deepseek-chat", provider="deepseek", api_key=api_key, ssl_verify=False)
llm = client.get_llm()
print(f"LLM 客户端创建: ✅ {type(llm).__name__}")
print(f"http_client verify: {llm.http_client.verify if hasattr(llm, 'http_client') and llm.http_client else 'default'}")

# 2. 验证 API 连通性
print(f"\n--- 2. API 连通性测试 ---")
headers = {"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"}
payload = {
    "model": "deepseek-chat",
    "messages": [{"role": "user", "content": "在10个token内回复OK"}],
    "max_tokens": 20,
}
try:
    r = httpx.post(
        "https://api.deepseek.com/chat/completions",
        json=payload, headers=headers, timeout=30, verify=False,
    )
    print(f"状态码: {r.status_code}")
    if r.status_code == 200:
        data = r.json()
        content = data["choices"][0]["message"]["content"]
        print(f"响应内容: {content}")
        print(f"模型: {data['model']}")
        print(f"token使用: {data['usage']['total_tokens']}")
    else:
        print(f"错误: {r.text[:300]}")
except Exception as e:
    print(f"异常: {type(e).__name__}: {e}")

print(f"\n=== 验证完成 ===")