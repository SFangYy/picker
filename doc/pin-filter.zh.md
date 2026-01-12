# 引脚过滤功能使用说明

## 功能概述

在使用 `picker pack --from-rtl` 从 RTL 文件自动生成 transaction 时，可以通过 `-p` 或 `--pin-filter` 参数指定一个 YAML 配置文件，来排除不需要的引脚。

## 使用方法

```bash
picker pack --from-rtl design.v -p pin_filter.yaml
```

## 配置文件格式

配置文件使用 YAML 格式，支持两种过滤方式：

### 1. 通配符模式 (exclude_patterns)

使用 `*` 作为通配符进行模式匹配：

```yaml
exclude_patterns:
  - "io_in_*"       # 排除所有 io_in_ 开头的引脚
  - "io_out_*"      # 排除所有 io_out_ 开头的引脚
  - "debug_*"       # 排除所有 debug_ 开头的引脚
  - "test_mode"     # 精确匹配，排除名为 test_mode 的引脚
  - "*_unused"      # 排除所有 _unused 结尾的引脚
```

### 2. 正则表达式模式 (exclude_regex)

使用标准的正则表达式进行更复杂的匹配：

```yaml
exclude_regex:
  - "^io_in_.*$"           # 排除所有 io_in_ 开头的引脚
  - ".*_debug$"            # 排除所有 _debug 结尾的引脚
  - "^temp_.*_[0-9]+$"     # 排除类似 temp_data_0, temp_data_1 的引脚
  - "^(clk|rst|rstn)$"     # 排除 clk, rst, rstn 这些特定引脚
```

## 完整示例

### 1. 创建过滤配置文件 (pin_filter.yaml)

```yaml
exclude_patterns:
  - "io_in_*"
  - "io_out_*"

exclude_regex:
  - "^debug_.*"
  - ".*_test$"
```

### 2. RTL 文件示例 (adder.v)

```verilog
module Adder (
    input        clk,
    input [7:0]  io_in_a,
    input [7:0]  io_in_b,
    output [8:0] io_out_sum,
    input        debug_enable,
    output       status_test
);
    // module implementation
endmodule
```

### 3. 使用 picker pack 生成代码

```bash
picker pack --from-rtl adder.v -p pin_filter.yaml --tdir output/
```

### 4. 输出结果

原始引脚：6 个
- clk
- io_in_a
- io_in_b
- io_out_sum
- debug_enable
- status_test

过滤后引脚：1 个
- clk

被排除的引脚：5 个
- io_in_a (匹配 io_in_*)
- io_in_b (匹配 io_in_*)
- io_out_sum (匹配 io_out_*)
- debug_enable (匹配 ^debug_.*)
- status_test (匹配 .*_test$)

## 调试信息

运行时会显示过滤信息：

```
[PK_MESSAGE] Loaded pin filter: 2 patterns, 2 regexes
[PK_MESSAGE] Pin filtering: 6 pins -> 1 pins (excluded 5 pins)
```

如果设置了 `PICKER_DEBUG=1` 环境变量，还会显示详细的排除信息：

```bash
export PICKER_DEBUG=1
picker pack --from-rtl adder.v -p pin_filter.yaml
```

输出会包含：
```
[PK_DEBUG] Loaded exclude pattern: io_in_*
[PK_DEBUG] Loaded exclude pattern: io_out_*
[PK_DEBUG] Loaded exclude regex: ^debug_.*
[PK_DEBUG] Loaded exclude regex: .*_test$
[PK_DEBUG] Excluded pin: io_in_a
[PK_DEBUG] Excluded pin: io_in_b
[PK_DEBUG] Excluded pin: io_out_sum
[PK_DEBUG] Excluded pin: debug_enable
[PK_DEBUG] Excluded pin: status_test
```

## 注意事项

1. 配置文件路径可以是相对路径或绝对路径
2. 如果配置文件格式错误，picker 会报错并退出
3. 如果正则表达式格式错误，会显示警告并跳过该表达式
4. 过滤后如果没有任何引脚剩余，会显示警告但仍会继续生成代码
5. `exclude_patterns` 和 `exclude_regex` 可以只使用其中一种，也可以同时使用
