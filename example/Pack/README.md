# Picker Pack 模式 - Python-UVM 混合验证完整指南

本目录包含 Picker Pack 功能的完整示例，展示如何使用 Python 驱动 UVM 验证环境，实现高效的芯片设计验证。

## 目录

- [概述](#概述)
- [快速开始](#快速开始)
- [核心概念](#核心概念)
- [命令行参数](#命令行参数)
- [示例说明](#示例说明)
- [主要功能](#主要功能)
- [使用场景](#使用场景)
- [故障排查](#故障排查)

---

## 概述

### 什么是 Picker Pack？

Picker Pack 是一个自动化工具，能够将 RTL 或 Transaction 定义转换为 Python 可调用的验证组件，实现以下功能：

- **Python DUT 类**：在 Python 中直接操作硬件/事物设计的输入输出
- **UVM Agent**：自动生成标准 UVM 组件（Driver、Monitor、Sequencer）
- **双向通信桥**：基于 UVMC 的 Python-SystemVerilog 数据交换机制

### 为什么使用 Picker Pack？

| 传统方法 | Picker Pack 方法 |
|---------|----------------|
| 用 SystemVerilog 写测试 | 用 Python 写测试（更简洁、灵活） |
| 手写 DPI/TLM 胶水代码 | 自动生成所有接口代码 |
| 受限于 UVM/SV 生态 | 利用 Python 丰富的库（NumPy、ML等） |
| 测试数据处理复杂 | Python 强大的数据处理能力 |

### 验证架构

```
Python 测试脚本 (*.py)
  - 生成激励（随机数、边界值、约束求解）
  - 调用 dut.Step() 驱动硬件
  - 读取输出并验证
  - 数据分析、可视化、机器学习
        |
        | TLM (UVMC)
        v
UVM 验证环境 (SystemVerilog)
  - xDriver: 接收 Python 数据并驱动 DUT
  - xMonitor: 采样 DUT 输出并回传 Python
  - xAgent: 完整的 UVM Agent 组件
        |
        | Virtual Interface
        v
DUT (硬件设计)
  - Verilog/SystemVerilog 模块
```

---

## 快速开始

### 方法一：使用自动化脚本（推荐）

```bash
# 在 picker 项目根目录执行
cd /path/to/picker

# 运行任意示例
bash example/Pack/release-pack.sh dut      # 基础示例：生成 DUT 封装
bash example/Pack/release-pack.sh send     # Python → UVM 单向通信
bash example/Pack/release-pack.sh recv     # UVM → Python 单向通信
bash example/Pack/release-pack.sh multi    # 多 Transaction 示例
```

### 方法二：从 Transaction 文件生成

使用已定义的 Transaction 类：

```bash
# 1. 从 transaction 文件生成 Agent 和 Python 接口
picker pack example/Pack/adder_trans.sv -d -e

# 2. 进入生成的目录
cd uvmpy/

# 3. 编译并运行示例
make clean comp copy_xspcomm run
```

### 方法三：从 RTL 直接生成（推荐）

无需手写 Transaction，直接从 RTL 模块生成：

```bash
# 1. 从 RTL 自动生成 Transaction 和验证环境
picker pack --from-rtl example/Adder/Adder.v -d -e

# 2. 进入生成的目录
cd uvmpy/

# 3. 编译并运行
make clean comp copy_xspcomm run
```

### 预期输出

```
Initialized DUT Adder
[UVM_INFO] Received from Python: a=0x1234..., b=0x5678..., cin=0
[UVM_INFO] Sampled: a=0x1234..., b=0x5678... -> sum=0x68ac..., cout=0
Test Passed, destroy DUT Adder
```

---

## 命令行参数

### 基本语法

```bash
picker pack [OPTIONS] [file...]
```

### 常用参数

| 参数 | 简写 | 说明 | 示例 |
|------|------|------|------|
| `--from-rtl <file>` | - | 从 RTL 模块自动生成 Transaction | `--from-rtl design.v` |
| `-p, --pin-filter <file>` | `-p` | 引脚过滤配置文件（YAML 格式） | `-p filter.yaml` |
| `-d, --generate-dut` | `-d` | 生成 DUT 封装类（pin-level 接口） | `-d` |
| `-e, --example` | `-e` | 生成示例测试文件 | `-e` |
| `-f, --filelist <file>` | `-f` | Transaction 文件列表 | `-f trans.txt` |
| `-r, --rename <name>` | `-r` | 重命名生成的 Transaction | `-r MyTrans` |
| `--sname <name>` | - | 指定目标模块名称 | `--sname TopModule` |
| `--tdir <dir>` | - | 指定输出目录 | `--tdir output/` |
| `-c, --force` | `-c` | 强制删除已存在的输出目录 | `-c` |

### 使用示例

#### 1. 基础用法：从 Transaction 文件生成

```bash
# 生成基本的 Agent 和 Python 接口
picker pack adder_trans.sv

# 生成 DUT 封装类和示例
picker pack adder_trans.sv -d -e
```

#### 2. 从 RTL 生成（自动创建 Transaction）

```bash
# 基础生成
picker pack --from-rtl design.v -d

# 指定模块名称（如果文件中有多个模块）
picker pack --from-rtl design.v --sname TopModule -d

# 指定输出目录
picker pack --from-rtl design.v --tdir my_output/ -d -e
```

#### 3. 引脚过滤（排除特定引脚）

```bash
# 创建过滤配置文件
cat > pin_filter.yaml << EOF
exclude_patterns:
  - "io_in_*"
  - "debug_*"
exclude_regex:
  - "^test_.*"
EOF

# 使用过滤器生成
picker pack --from-rtl design.v -p pin_filter.yaml -d
```

**引脚过滤说明：**

- **通配符模式** (`exclude_patterns`): 使用 `*` 匹配任意字符
  - `io_in_*`: 排除所有 `io_in_` 开头的引脚
  - `*_test`: 排除所有 `_test` 结尾的引脚
  - `debug_mode`: 精确匹配特定引脚名

- **正则表达式** (`exclude_regex`): 使用完整的正则表达式语法
  - `^io_in_.*$`: 排除 io_in_ 开头的引脚
  - `.*_debug$`: 排除 _debug 结尾的引脚
  - `^temp_[0-9]+$`: 排除 temp_0, temp_1 等数字结尾的引脚

详细说明请参考：[doc/pin-filter.zh.md](../../doc/pin-filter.zh.md)

#### 4. 多 Transaction 文件

```bash
# 创建文件列表
cat > filelist.txt << EOF
alu_op.sv
alu_result.sv
cache_req.sv
cache_resp.sv
EOF

# 生成统一的 Package
picker pack -f filelist.txt --sname ALU -d
```

---

## 核心概念

### 1. Transaction 定义

Transaction 是 UVM 验证中的核心数据结构，封装了一次完整的接口操作。Picker Pack 通过解析 Transaction 自动推断出所有输入/输出信号及其类型，从而生成 Python-UVM 通信接口。

```systemverilog
// adder_trans.sv
class adder_trans extends uvm_sequence_item;
    rand bit [127:0] a, b;  // 输入信号
    rand bit cin;
    bit [127:0] sum;        // 输出信号
    bit cout;

    `uvm_object_utils_begin(adder_trans)
        `uvm_field_int(a, UVM_ALL_ON)
        `uvm_field_int(b, UVM_ALL_ON)
        `uvm_field_int(cin, UVM_ALL_ON)
        `uvm_field_int(sum, UVM_ALL_ON)
        `uvm_field_int(cout, UVM_ALL_ON)
    `uvm_object_utils_end
endclass
```

### 2. Python DUT 接口

Picker 自动生成的 Python 类：

```python
from Adder import DUTAdder

# 创建 DUT 实例（自动启动仿真）
dut = DUTAdder()

# 设置输入
dut.a.value = 0x1234
dut.b.value = 0x5678
dut.cin.value = 0

# 推进仿真
dut.Step(10)

# 读取输出（已自动更新）
result = dut.sum.value
carry = dut.cout.value
```

### 3. 时序与数据流

**核心原理：** Python 通过 `Step()` 推进仿真时钟，每次 `Step(1)` 推进一个时钟周期。

**时序说明：**

```
Cycle N:
  Python 设置输入 (dut.input.value = x)
       |
       v
  Python 调用 Step(1)
       |
       +---> TLM 传输到 UVM
       +---> UVM Driver 接收并驱动 DUT
       +---> DUT 时钟上升沿，计算输出
       +---> UVM Monitor 采样输出
       +---> TLM 回传到 Python
       |
       v
  Python 读取输出 (result = dut.output.value)
Cycle N + 1:
```
---

## 示例说明

本目录包含以下示例：

### 01_Py2UVM - Python 到 UVM 的单向通信

**场景：** Python 生成测试激励并发送到 UVM 环境

**文件结构：**
```
01_Py2UVM/
├── example.py    # Python 测试脚本（驱动端）
└── example.sv    # UVM testbench（接收端）
```

**运行方式：**
```bash
bash example/Pack/release-pack.sh send
```

**Python 代码示例：**
```python
from adder_trans import Agent, adder_trans
import random

# 创建 Agent 实例
agent = Agent()

# Python 驱动 UVM
for i in range(5):
    tr = adder_trans()
    tr.a.value = random.randint(0, (1 << 128) - 1)
    tr.b.value = random.randint(0, (1 << 128) - 1)
    tr.cin.value = random.randint(0, 1)
    
    print(f"[Driver] Send to UVM: {tr}")
    agent.drive(tr)  # 发送到 UVM
    agent.run(1)     # 推进 1 个时钟周期
```

**关键点：**
- Python 控制测试流程
- `agent.drive(tr)` 发送数据到 UVM
- `agent.run(n)` 推进仿真时钟

---

### 02_UVM2Py - UVM 到 Python 的单向通信

**场景：** UVM 内部生成数据，Python 接收并处理

**文件结构：**
```
02_UVM2Py/
├── example.py    # Python 测试脚本（监控端）
└── example.sv    # UVM testbench（数据源）
```

**运行方式：**
```bash
bash example/Pack/release-pack.sh recv
```

**Python 代码示例：**
```python
from adder_trans import Agent

# 定义监控回调函数
def monitor_callback(trans_type, trans_obj):
    print(f"[Monitor] Received from UVM: a={trans_obj.a.value}, "
          f"b={trans_obj.b.value}, sum={trans_obj.sum.value}")
    # 可以在这里进行数据分析、验证等

agent = Agent(monitor_callback=monitor_callback)

# 运行仿真，接收 UVM 数据
agent.run(100)  # 运行 100 个时钟周期
```

**关键点：**
- UVM Monitor 自动采样数据
- Python 通过回调函数实时接收
- 适合协议监控、性能分析

---

### 03_MultiTrans - 多 Transaction 双向通信

**场景：** 复杂设计中多种数据类型的交互（如 ALU 操作）

**文件结构：**
```
03_MultiTrans/
├── alu_op.sv       # 操作类型 transaction
├── alu_result.sv   # 结果类型 transaction
├── filelist.txt    # Transaction 列表
├── example.py      # Python 测试脚本
└── example.sv      # UVM testbench
```

**运行方式：**
```bash
bash example/Pack/release-pack.sh multi
```

**Transaction 定义：**
```systemverilog
// alu_op.sv - 输入操作
class alu_op extends uvm_sequence_item;
    rand bit [3:0] opcode;      // 操作码
    rand bit [31:0] operand_a;  // 操作数 A
    rand bit [31:0] operand_b;  // 操作数 B
    // ...
endclass

// alu_result.sv - 输出结果
class alu_result extends uvm_sequence_item;
    bit [31:0] result;          // 计算结果
    bit [3:0] flags;            // 状态标志
    // ...
endclass
```

**Python 代码示例：**
```python
from ALU import DutALU, alu_op, alu_result

dut = DutALU()

# 发送操作请求
for i in range(10):
    op = alu_op()
    op.opcode.value = 0x1      # ADD 操作
    op.operand_a.value = i * 10
    op.operand_b.value = i * 20
    
    dut.drive_alu_op(op)       # 发送操作
    dut.Step(1)
    
    # 接收结果（通过回调或直接读取）
    result = dut.get_alu_result()
    print(f"Result: {result.result.value}, Flags: {result.flags.value}")
```

**关键点：**
- 支持多个 Transaction 类型
- 可以同时发送和接收不同类型的数据
- 适合复杂协议、总线验证

---

## 数据流说明

### Python → UVM (Drive)

```
Python 测试脚本
    |
    | agent.drive(transaction)
    |
    v
TLM Port (UVMC)
    |
    | TLM 通信
    |
    v
UVM xDriver
    |
    | virtual interface
    |
    v
DUT 输入端口
```

### UVM → Python (Monitor)

```
DUT 输出端口
    |
    | virtual interface
    |
    v
UVM xMonitor (采样)
    |
    | TLM 通信
    |
    v
TLM Port (UVMC)
    |
    | monitor_callback()
    |
    v
Python 回调函数
```

---

## 主要功能

### 1. 从 RTL 自动生成 Transaction (`--from-rtl`)

**新功能！** 无需手写 Transaction，直接从 RTL 模块自动生成：

```bash
# 自动解析模块端口并生成 transaction
picker pack --from-rtl Adder.v -d
```

**生成内容：**
```systemverilog
// 自动生成的 Adder_trans.sv
class Adder_trans extends uvm_sequence_item;
    rand bit [127:0] a;      // 从 input [127:0] a 生成
    rand bit [127:0] b;      // 从 input [127:0] b 生成
    rand bit cin;            // 从 input cin 生成
    bit [127:0] sum;         // 从 output [127:0] sum 生成
    bit cout;                // 从 output cout 生成
    // ...
endclass
```

**优势：**
- 自动识别输入/输出端口
- 自动推断位宽
- 自动生成字段注册宏
- 减少手动错误
- 快速原型验证

**指定模块名：**
```bash
# 如果 RTL 文件包含多个模块，指定目标模块
picker pack --from-rtl design.v --sname TopModule -d
```

---

### 2. 引脚过滤 (`-p, --pin-filter`)

在从 RTL 生成时，排除不需要的引脚（如调试信号、测试端口）：

```yaml
# pin_filter.yaml
exclude_patterns:
  - "io_in_*"       # 排除所有 io_in_ 开头的引脚
  - "debug_*"       # 排除调试信号
  - "test_mode"     # 精确匹配

exclude_regex:
  - "^scan_.*"      # 排除扫描链相关信号
  - ".*_unused$"    # 排除未使用的信号
```

```bash
picker pack --from-rtl design.v -p pin_filter.yaml -d
```

**应用场景：**
- 排除时钟/复位信号（由 UVM 环境控制）
- 过滤调试端口、测试模式信号
- 简化 Transaction，只保留功能相关引脚
- 减少不必要的接口复杂度

**输出信息：**
```
[PK_MESSAGE] Loaded pin filter: 3 patterns, 2 regexes
[PK_MESSAGE] Pin filtering: 20 pins -> 12 pins (excluded 8 pins)
```

---

### 3. DUT 封装 (`-d, --generate-dut`)

生成 pin-level 的 DUT 封装类，提供更直观的接口：

```bash
picker pack adder_trans.sv -d
```

**生成的 Python 接口：**
```python
from adder_trans import DUTadder_trans

# 创建 DUT 实例
dut = DUTadder_trans()

# 直接访问引脚（类似 Verilog）
dut.a.value = 0x12345678
dut.b.value = 0xABCDEF00
dut.cin.value = 1

# 推进时钟
dut.Step(1)

# 读取输出
result = dut.sum.value
carry = dut.cout.value

print(f"Sum: 0x{result:x}, Carry: {carry}")
```

**优势：**
- 更接近硬件思维方式
- 适合 pin-level 验证
- 支持时钟控制
- 可设置更新回调

---

### 4. 监控回调 (`SetUpdateCallback`)

实时追踪 Monitor 更新：

```python
def debug_callback(dut):
    print(f"[Monitor Update] a={dut.a.value}, sum={dut.sum.value}")

dut = DUTadder_trans()
dut.SetUpdateCallback(debug_callback)

# 每次 Monitor 更新时自动调用 callback
dut.Step(1)  # 触发回调
```

**应用场景：**
- 实时监控 DUT 状态
- 调试信号传输
- 性能分析
- 波形数据收集

---

### 5. 多 Transaction 支持 (`-f` + `--sname`)

处理多个 Transaction 文件的复杂设计：

```bash
# 创建文件列表
cat > filelist.txt << EOF
alu_op.sv
alu_result.sv
cache_req.sv
cache_resp.sv
EOF

# 生成统一的 Package
picker pack -f filelist.txt --sname ALU -d
```

**生成结构：**
```
ALU/                          # 统一的 Package 名
├── ALU_trans.sv              # 包含所有 transaction
├── xagent.sv                 # 支持多类型 transaction 的 Agent
├── xdriver.sv                # 多类型 Driver
├── xmonitor.sv               # 多类型 Monitor
└── __init__.py               # Python 统一接口
```

**Python 使用：**
```python
from ALU import DutALU, alu_op, alu_result

dut = DutALU()

# 驱动不同类型的 transaction
dut.drive_alu_op(op_trans)
dut.drive_cache_req(req_trans)

# 接收不同类型的结果
result = dut.get_alu_result()
response = dut.get_cache_resp()
```

---

### 6. 示例代码生成 (`-e, --example`)

自动生成完整的测试示例：

```bash
picker pack --from-rtl design.v -d -e
```

**生成内容：**
- `example.py`: Python 测试脚本模板
- `example.sv`: UVM testbench 模板
- `Makefile`: 编译运行脚本

**适合：**
- 快速入门学习
- 项目模板生成
- 参考代码

---
