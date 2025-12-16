# Picker Pack 模式 UVM 混合验证示例 - 128位加法器

本示例展示了如何使用 Picker 的 `pack -d` 模式将一个 SystemVerilog DUT（128位全加器）封装成 Python 可调用的验证组件，实现 Python-UVM 混合验证环境。

## 1. 概述

### 1.1 什么是 Pack 模式？

Picker 的 `pack` 模式可以将 SystemVerilog Transaction 定义自动转换为：
- **Python DUT 类**：供 Python 测试脚本直接调用
- **UVM xAgent**：包含 Driver、Monitor、Sequencer 的完整 UVM Agent
- **TLM 通信桥**：基于 UVMC 的双向通信机制

### 1.2 本示例的验证架构

```
    Python (example.py)
    ├─ 生成随机激励
    ├─ 调用 dut.Step() 驱动
    └─ 接收结果并验证
         │
         │ TLMPub (Python→SV)
         ↓
    UVM Driver (继承 xdriver)
    ├─ sequence_receive(): 接收 Python 数据
    ├─ 驱动 DUT 接口信号
    └─ 采样 DUT 输出
         │
         │ Virtual Interface
         ↓
    DUT: Adder_128 (Adder.v)
    ├─ 输入: a[127:0], b[127:0], cin
    └─ 输出: sum[127:0], cout
         │
         │ 读取输出
         ↓
    UVM Monitor (自动生成)
    └─ mon_handle.send_tr() 回传结果
         │
         │ TLMSub (SV→Python)
         ↓
    返回到 Python (dut.sum, dut.cout)
```

### 1.3 主要特性

- ✅ **Python 主导**：测试逻辑完全用 Python 编写，无需写 SystemVerilog sequence
- ✅ **自动生成**：Picker 生成所有胶水代码，无需手动编写 DPI/TLM
- ✅ **双向通信**：Python→SV 发送激励，SV→Python 返回结果
- ✅ **UVM 兼容**：生成标准 UVM 组件，可集成到现有 UVM 环境

## 2. 文件结构

### 2.1 源文件（开发者提供）

```
example/Pack/Adder/
├── adder_trans.sv          # Transaction 定义（必需）
├── Adder.v                 # DUT RTL 代码（必需）
├── example.sv              # UVM Testbench（必需）
├── example.py              # Python 测试脚本（必需）
└── README.md               # 本文档
```

**各文件说明：**

| 文件 | 作用 | 关键内容 |
|------|------|----------|
| `adder_trans.sv` | 定义通信数据结构 | 继承 `uvm_sequence_item`，包含所有输入/输出信号 |
| `Adder.v` | 待测设计 | 128位全加器：`{cout, sum} = a + b + cin` |
| `example.sv` | SV 测试平台 | 继承 xdriver，实现 `sequence_receive()` 任务 |
| `example.py` | Python 测试 | 调用 `dut.Step()` 驱动激励并验证结果 |

### 2.2 生成文件（Picker 自动生成）

运行 `picker pack` 后会在输出目录生成：

```
pack_output/adder/
├── adder_trans_pkg/                  # 自动生成的 SV Package
│   ├── adder_trans.py                # Python DUT 包装类
│   ├── adder_trans_xagent.sv         # UVM Agent
│   ├── adder_trans_xdriver.sv        # UVM Driver 基类
│   ├── adder_trans_xmonitor.sv       # UVM Monitor
│   ├── adder_trans_pkg.sv            # SV Package 顶层
│   └── ...                           # 其他支持文件
├── example.sv                        # (复制的) UVM Testbench
├── example.py                        # (复制的) Python 测试
├── Makefile                          # (复制的) 编译脚本
└── filelist.txt                      # VCS 文件列表

## 3. 快速开始

### 3.1 环境要求

- **Picker**：最新版本（支持 pack -d 模式）
- **VCS**：W-2024.09 或更高版本
- **Python**：3.8 或更高版本
- **xspcomm**：Picker 提供的 Python TLM 库

### 3.2 运行步骤

#### 方法一：使用自动化脚本（推荐）

```bash
# 在 picker 项目根目录下执行
bash example/Pack/release-pack.sh adder
```

这个脚本会自动完成以下步骤：
1. 运行 `picker pack -d` 生成代码
2. 复制必要文件到输出目录
3. 编译并运行测试

#### 方法二：手动执行

如果您想了解每一步的细节：

**步骤 1：使用 Picker 打包**

```bash
cd example/Pack/Adder

# 运行 picker pack 命令
picker pack -d \
  -t adder_trans.sv \
  -e Adder.v \
  -o ../../../pack_output/adder
```

**参数说明：**
- `-d`：DUT 模式，生成 Python 可调用的接口
- `-t`：指定 Transaction 定义文件
- `-e`：指定 DUT 文件（可选，用于生成文件列表）
- `-o`：输出目录

**步骤 2：准备测试环境**

```bash
# 复制测试文件到输出目录
cp example.sv example.py ../../../pack_output/adder/
cp ../Makefile ../../../pack_output/adder/
```

**步骤 3：编译与运行**

```bash
cd ../../../pack_output/adder

# 编译（自动检测 *_pkg 目录）
make compile

# 运行测试
make run
```

### 3.3 预期输出

成功运行后，您应该看到类似输出：

```
UVM_INFO example.sv(50) @ 12: uvm_test_top.env.xagent.adder_trans.pub [ADDER_DRV] 
  Received from Python: a=0x1234..., b=0x5678..., cin=0

UVM_INFO example.sv(65) @ 13: uvm_test_top.env.xagent.adder_trans.pub [ADDER_DRV] 
  DUT result: sum=0x68ac..., cout=0

Initialized DUT Adder
Cycle 0 Passed
Cycle 1 Passed
...
Cycle 11450 Passed
Test Passed, destroy DUT Adder
```

## 4. 关键实现详解

### 4.1 Transaction 定义 (`adder_trans.sv`)

Transaction 是 Python 和 SystemVerilog 之间的数据契约：

```systemverilog
class adder_trans extends uvm_sequence_item;
    rand bit [127:0] a, b;  // 输入（Python 设置）
    rand bit cin;
    bit [127:0] sum;        // 输出（Driver 填充后返回 Python）
    bit cout;
    
    `uvm_object_utils_begin(adder_trans)
        `uvm_field_int(a, UVM_ALL_ON)    // 必须注册所有字段
        `uvm_field_int(b, UVM_ALL_ON)
        // ... 其他字段
    `uvm_object_utils_end
endclass
```

**要点：** 所有需要在 Python 中访问的信号都必须定义为类成员并使用 `uvm_field_*` 宏注册

### 4.2 SystemVerilog Testbench (`example.sv`)

#### 4.2.1 自定义 Driver

继承 Picker 生成的 `adder_trans_xdriver`，只负责驱动 DUT：

```systemverilog
class adder_python_driver extends adder_trans_xdriver;
    virtual adder_if vif;
    
    virtual task sequence_receive(adder_trans tr);
        // Driver 只负责驱动 DUT 输入
        vif.a = tr.a;
        vif.b = tr.b;
        vif.cin = tr.cin;
    endtask
endclass
```

**要点：**Driver 不负责采样输出，不调用任何 Monitor 方法

#### 4.2.2 自定义 Monitor

继承 Picker 生成的 `adder_trans_xmonitor`，**独立**监控接口：

```systemverilog
class adder_python_monitor extends adder_trans_xmonitor;
    virtual adder_if vif;
    adder_trans prev_tr;  // 记录上一次采样，避免重复发送
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            // 等待输入信号变化
            @(vif.a or vif.b or vif.cin);
            
            // 等待组合逻辑稳定
            #1step;
            
            // 采样所有信号
            tr = create_transaction();
            tr.a = vif.a; tr.b = vif.b; tr.cin = vif.cin;
            tr.sum = vif.sum; tr.cout = vif.cout;
            
            // 发送到 Python（仅当输入改变时）
            if (is_new_transaction(tr, prev_tr)) begin
                sequence_send(tr);
                prev_tr.copy(tr);
            end
        end
    endtask
endclass
```

**关键设计：**
- Monitor 通过 `@(vif.a or vif.b or vif.cin)` 检测输入变化
- 等待 `#1step` 让组合逻辑稳定后采样
- 完全独立于 Driver，符合 UVM 规范

#### 4.2.3 Environment 配置

在 UVM Environment 中配置使用自定义组件：

```systemverilog
class adder_env extends uvm_env;
    virtual function void build_phase(uvm_phase phase);
        // 配置使用自定义 Driver 和 Monitor
        xagent_config.drv_type = adder_python_driver::get_type();
        xagent_config.mon_type = adder_python_monitor::get_type();
    endfunction
    // 不需要 connect_phase - Monitor 完全独立工作
endclass
```

#### 4.2.4 Top Module

```systemverilog
module sv_main;
    adder_if aif();  // Interface
    Adder_128 dut(.a(aif.a), .b(aif.b), ...);  // DUT 实例
    
    initial begin
        uvm_config_db#(virtual adder_if)::set(null, "*", "vif", aif);
        run_test("adder_test");
    end
endmodule
```

### 4.3 Python 测试脚本 (`example.py`)

```python
from adder_trans_pkg.adder_trans import DUTadder_trans

def main():
    dut = DUTadder_trans()  # 创建 DUT 实例
    
    for cycle in range(11451):
        # 设置输入
        dut.a.value = random.randint(0, 2**128 - 1)
        dut.b.value = random.randint(0, 2**128 - 1)
        dut.cin.value = random.randint(0, 1)
        
        # 驱动 DUT（推进 10ns，触发 SV 端 sequence_receive）
        dut.Step(10)
        
        # 读取输出（Step 返回后自动更新）
        dut_sum = dut.sum.value
        dut_cout = dut.cout.value
        
        # 验证结果
        ref_result = dut.a.value + dut.b.value + dut.cin.value
        assert dut_sum == (ref_result & ((1 << 128) - 1))
        assert dut_cout == ((ref_result >> 128) & 1)
```

**关键 API：**
- `DUTadder_trans()`：创建实例，自动启动仿真
- `dut.a.value = x`：设置输入
- `dut.Step(n)`：推进 n 个时间单位，触发 SV 端处理
- `dut.sum.value`：读取输出（Step 返回后已更新）

## 5. 数据流程详解

完整的一次交互流程：

```
┌─────────────────────────────────────────────────────────────────┐
│ Step 1: Python 设置激励                                           │
│   dut.a.value = 0x1234...                                        │
│   dut.b.value = 0x5678...                                        │
│   dut.cin.value = 0                                              │
└────────────────┬────────────────────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────────────────────┐
│ Step 2: Python 调用 Step()                                        │
│   dut.Step(10)  # 推进 10ns                                       │
└────────────────┬────────────────────────────────────────────────┘
                 │ TLMPub (xspcomm)
                 ↓
┌─────────────────────────────────────────────────────────────────┐
│ Step 3: SV Driver 收到 transaction                                │
│   sequence_receive(adder_trans tr) 被调用                         │
│   tr.a = 0x1234...                                               │
│   tr.b = 0x5678...                                               │
│   tr.cin = 0                                                     │
└────────────────┬────────────────────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────────────────────┐
│ Step 4: Driver 驱动 DUT 接口                                       │
│   vif.a = tr.a                                                   │
│   vif.b = tr.b                                                   │
│   vif.cin = tr.cin                                               │
└────────────────┬────────────────────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────────────────────┐
│ Step 5: 等待组合逻辑稳定                                            │
│   #1step;  // 等待 1 个 delta cycle                               │
└────────────────┬────────────────────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────────────────────┐
│ Step 6: DUT 计算完成                                               │
│   vif.sum = 0x68ac... (DUT 输出)                                 │
│   vif.cout = 0                                                   │
└────────────────┬────────────────────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────────────────────┐
│ Step 7: Driver 采样输出                                            │
│   tr.sum = vif.sum                                               │
│   tr.cout = vif.cout                                             │
└────────────────┬────────────────────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────────────────────┐
│ Step 8: 通过 Monitor 回传                                          │
│   mon_handle.send_tr(tr)                                         │
└────────────────┬────────────────────────────────────────────────┘
                 │ TLMSub (xspcomm)
                 ↓
┌─────────────────────────────────────────────────────────────────┐
│ Step 9: Python 对象更新                                            │
│   dut.sum.value = 0x68ac...                                      │
│   dut.cout.value = 0                                             │
│   dut.Step(10) 返回                                               │
└────────────────┬────────────────────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────────────────────┐
│ Step 10: Python 验证结果                                           │
│   assert dut.sum.value == expected_sum                           │
└─────────────────────────────────────────────────────────────────┘
```

## 6. 常见问题与注意事项

### 6.1 为什么需要 `#1step`？

**问题现象：**
```systemverilog
vif.a = tr.a;
tr.sum = vif.sum;  // sum 总是 0！
```

**原因：**
- 组合逻辑在 SystemVerilog 中不是瞬时完成的
- 信号变化需要一个 delta cycle 传播
- 在同一时间步内读取输出，还没来得及计算

**解决方案：**
```systemverilog
vif.a = tr.a;
#1step;           // 等待 1 个 delta cycle
tr.sum = vif.sum; // 现在可以读到正确值
```

### 6.2 不能使用时间延迟

**错误示例：**
```systemverilog
vif.a = tr.a;
#0;              // 导致 UVMC 任务挂起！
// 或
#1ns;            // 同样会挂起！
// 或
@(posedge clk);  // 也会挂起！
```

**正确做法：**
```systemverilog
vif.a = tr.a;
#1step;          // 仅使用 #1step
```

**原因：**
- UVMC 环境中，Driver task 不应该有阻塞性的时间等待
- `#1step` 是特殊的，只推进 delta cycle，不推进仿真时间

### 6.3 Monitor 必须独立采样

**❌ 错误做法：Driver 触发 Monitor**
```systemverilog
// 违反 UVM 规范！
class driver extends xdriver;
    monitor mon_handle;
    task sequence_receive(tr);
        vif.a = tr.a;
        mon_handle.sample();  // Driver 不应该控制 Monitor
    endtask
endclass
```

**✅ 正确做法：Monitor 独立监控接口**
```systemverilog
// Driver：只负责驱动
class driver extends xdriver;
    task sequence_receive(tr);
        vif.a = tr.a;  // 只驱动，不管 Monitor
    endtask
endclass

// Monitor：独立运行
class monitor extends xmonitor;
    task run_phase(phase);
        forever begin
            @(vif.a);  // 独立检测信号变化
            #1step;
            tr = sample_interface();
            sequence_send(tr);
        end
    endtask
endclass
```

**原因：**
- UVM 要求 **Driver 和 Monitor 完全解耦**
- Monitor 必须能独立验证 Driver 的行为
- 这是 UVM 架构的核心原则

### 6.4 使用信号敏感列表检测变化

### 6.4 使用信号敏感列表检测变化

Monitor 使用 `@(signal)` 检测接口变化：

```systemverilog
task run_phase(uvm_phase phase);
    forever begin
        @(vif.a or vif.b or vif.cin);  // 等待任意输入变化
        #1step;  // 等待组合逻辑稳定
        sample_and_send();
    end
endtask
```

**避免重复采样：**
```systemverilog
adder_trans prev_tr;

if (tr.a != prev_tr.a || tr.b != prev_tr.b || tr.cin != prev_tr.cin) begin
    sequence_send(tr);  // 只有输入变化时才发送
    prev_tr.copy(tr);
end
```

### 6.5 Interface 输出信号使用 `wire`

对于组合逻辑 DUT，interface 中的输出信号应该声明为 `wire`：

```systemverilog
interface adder_if;
    logic [127:0] a;     // 输入可以是 logic
    logic [127:0] b;
    logic cin;
    wire [127:0] sum;    // 输出用 wire
    wire cout;
endinterface
```

### 6.6 Makefile 配置要点

```makefile
# 自动查找 *_pkg 目录
PKG_DIR := $(shell find . -maxdepth 1 -type d -name "*_pkg")

compile:
	vcs -full64 -sverilog -timescale=1ns/1ps \
	    +incdir+$(PKG_DIR) -f filelist.txt example.sv -o simv

run:
	PYTHONPATH=$(PKG_DIR):$$PYTHONPATH ./simv
```

## 7. 进阶话题

### 7.1 支持时序逻辑 DUT

对于带时钟的时序逻辑，可以使用时钟边沿：

```systemverilog
virtual task sequence_receive(adder_trans tr);
    @(posedge vif.clk);  // 时序 DUT 可以用时钟
    vif.a = tr.a;
    
    @(posedge vif.clk);  // 等待一个周期
    tr.sum = vif.sum;
    
    mon_handle.send_tr(tr);
endtask
```

### 7.2 集成到现有 UVM 环境

生成的 xAgent 是标准 UVM 组件，可直接使用：

```systemverilog
class my_env extends uvm_env;
    adder_trans_xagent python_agent;  // Picker 生成的 Agent
    my_other_agent other_agent;       // 现有的其他 Agent
endclass
```

## 8. 参考资料

- **Picker 文档**：`doc/README-DUT-Pack.md`
- **时序问题详解**：`doc/dut-pack-timing-details.md`（关于 `#1step` 的深入分析）
- **FAQ**：`doc/dut-pack-faq.md`
- **最佳实践**：`doc/dut-pack-best-practices.md`

## 9. 总结

使用 Picker Pack 模式的关键步骤：

1. ✅ 定义 Transaction（继承 `uvm_sequence_item`）
2. ✅ 运行 `picker pack -d` 生成代码
3. ✅ 继承 xdriver，实现 `sequence_receive()`
4. ✅ 在 `sequence_receive()` 中：
   - 驱动 DUT 输入
   - 使用 `#1step` 等待（组合逻辑）
   - 采样 DUT 输出
   - 调用 `mon_handle.send_tr()` 回传
5. ✅ Python 端使用 `dut.Step()` 驱动测试

**核心要点：**
- `#1step` 是组合逻辑的唯一正确延迟
- 必须调用 `mon_handle.send_tr()` 回传数据
- Python 和 SV 通过 Transaction 双向通信