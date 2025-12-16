#include "codegen/sv.hpp"

namespace picker { namespace codegen {

    void gen_uvm_code(inja::json data, std::string templateName, std::string outputName)
    {
        std::ifstream template_file(templateName);
        std::string template_str((std::istreambuf_iterator<char>(template_file)), std::istreambuf_iterator<char>());
        template_file.close();

        inja::Environment env;
        std::string rendered = env.render(template_str, data);
        std::ofstream output_file(outputName);
        output_file << rendered;
        output_file.close();
    }

    // ============ Helper Functions ============

    // 设置目录结构并返回pkg和top路径
    std::pair<std::string, std::string> setup_directories(const pack_opts& opts, const std::string& packageName) {
        std::string topFolder, pkgFolder, buildFolder;

        if (opts.example) {
            topFolder = "uvmpy";
            pkgFolder = topFolder + "/" + packageName;
            buildFolder = pkgFolder + "/build";

            if (std::filesystem::exists(topFolder) && !opts.force) {
                PK_MESSAGE("folder already exists, use -c/--force to overwrite");
                exit(0);
            }
            if (std::filesystem::exists(topFolder)) {
                std::filesystem::remove_all(topFolder);
            }
            std::filesystem::create_directories(buildFolder);
        } else {
            pkgFolder = packageName;
            buildFolder = pkgFolder + "/build";

            if (std::filesystem::exists(pkgFolder) && !opts.force) {
                PK_MESSAGE("folder already exists, use -c/--force to overwrite");
                exit(0);
            }
            if (std::filesystem::exists(pkgFolder)) {
                std::filesystem::remove_all(pkgFolder);
            }
            std::filesystem::create_directories(buildFolder);
        }

        return {pkgFolder, topFolder};
    }

    // 计算单个字段的元数据（byte_offset, struct_fmt, is_standard_aligned）
    void compute_field_metadata(inja::json& param, int& byte_offset) {
        int byte_count = param["nums"];
        param["byte_offset"] = byte_offset;

        switch(byte_count) {
            case 1:
                param["struct_fmt"] = "B";
                param["is_standard_aligned"] = true;
                break;
            case 2:
                param["struct_fmt"] = "H";
                param["is_standard_aligned"] = true;
                break;
            case 4:
                param["struct_fmt"] = "I";
                param["is_standard_aligned"] = true;
                break;
            case 8:
                param["struct_fmt"] = "Q";
                param["is_standard_aligned"] = true;
                break;
            default:
                param["struct_fmt"] = "";
                param["is_standard_aligned"] = false;
                break;
        }

        byte_offset += byte_count;
    }

    // ============ Unified Generation Function ============

    // 统一的UVM代码生成函数（支持单事务和多事务）
    void gen_uvm_unified(picker::pack_opts &opts,
                        const std::vector<uvm_transaction_define> &transactions,
                        const std::vector<std::string> &filenames,
                        const std::string &package_name) {

        // 1. 设置目录结构
        auto [pkgFolder, topFolder] = setup_directories(opts, package_name);

        // 2. 准备模板数据
        inja::json data;
        std::string erro_message;

        // 设置xspcomm路径
        auto python_location = picker::get_xcomm_lib("python/xspcomm", erro_message);
        if (python_location.empty()) { PK_FATAL("%s\n", erro_message.c_str()); }
        data["__XSPCOMM_PYTHON__"] = python_location;

        auto xspcomm_include_location = picker::get_xcomm_lib("include", erro_message);
        if (xspcomm_include_location.empty()) { PK_FATAL("%s\n", erro_message.c_str()); }
        data["__XSPCOMM_INCLUDE__"] = xspcomm_include_location;

        data["className"] = package_name;
        data["pkgName"] = package_name;
        data["version"] = transactions[0].version;
        data["datenow"] = transactions[0].data_now;
        data["useType"] = 1;
        data["generate_dut"] = opts.generate_dut;  // Add DUT mode flag
        data["transactions"] = inja::json::array();
        data["variables"] = inja::json::array();

        // 3. 收集所有事务和变量
        int total_byte_count = 0;
        bool is_single_transaction = (transactions.size() == 1);

        for (size_t i = 0; i < transactions.size(); i++) {
            inja::json trans_data;
            trans_data["name"] = transactions[i].name;
            trans_data["filename"] = filenames[i];
            trans_data["filepath"] = transactions[i].filepath;
            trans_data["variables"] = inja::json::array();

            int trans_byte_offset = 0;
            int trans_byte_count = 0;

            for (const auto &param : transactions[i].parameters) {
                inja::json parameter;
                parameter["nums"] = param.byte_count;
                parameter["bit_count"] = param.bit_count;
                parameter["macro"] = param.is_marcro;
                parameter["name"] = param.name;
                parameter["macro_name"] = param.macro_name;

                if (!is_single_transaction) {
                    parameter["transaction_name"] = transactions[i].name;
                }

                // 计算字段元数据
                compute_field_metadata(parameter, trans_byte_offset);

                trans_data["variables"].push_back(parameter);
                data["variables"].push_back(parameter);
                trans_byte_count += param.byte_count;
            }

            trans_data["byte_stream_count"] = trans_byte_count;
            total_byte_count += trans_byte_count;

            // Always add to transactions array for unified template
            data["transactions"].push_back(trans_data);
        }

        data["byte_stream_count"] = total_byte_count;
        data["transaction_count"] = is_single_transaction ? 0 : transactions.size();

        // 单事务模式：添加额外字段
        if (is_single_transaction) {
            data["filepath"] = transactions[0].filepath;
            data["className"] = transactions[0].name;  // 使用transaction name而不是package name
        }

        // 4. 生成核心package文件
        std::string template_path = picker::get_template_path();
        std::string agent_name = is_single_transaction ?
            transactions[0].name : package_name;

        gen_uvm_code(data, template_path + "/uvm/xagent.py",
                     pkgFolder + "/xagent.py");
        gen_uvm_code(data, template_path + "/uvm/xagent.sv",
                     pkgFolder + "/xagent.sv");
        gen_uvm_code(data, template_path + "/uvm/__init__.py",
                     pkgFolder + "/__init__.py");
        gen_uvm_code(data, template_path + "/uvm/picker_uvm_utils_pkg.sv",
                     pkgFolder + "/utils_pkg.sv");

        // Note: DUT implementation is now integrated into __init__.py
        // No separate xdut.py file needed

        // 5. 生成example文件（如果需要）
        if (opts.example) {
            // Python example
            if (opts.generate_dut) {
                gen_uvm_code(data, template_path + "/uvm/example_dut.py",
                            topFolder + "/example.py");
            } else {
                gen_uvm_code(data, template_path + "/uvm/example.py",
                            topFolder + "/example.py");
            }

            // SV example and Makefile
            gen_uvm_code(data, template_path + "/uvm/example.sv",
                        topFolder + "/example.sv");
            gen_uvm_code(data, template_path + "/uvm/Makefile",
                        topFolder + "/Makefile");
        }

        std::cout << "generate " + package_name + " code successfully." << std::endl;
    }

    // ============ Wrapper Functions ============

    // 单事务模式包装函数（保持原有接口兼容）
    void gen_uvm_param(picker::pack_opts &opts, uvm_transaction_define transaction, std::string filename) {
        std::string packageName = opts.name.empty() ? filename : opts.name;
        gen_uvm_unified(opts, {transaction}, {filename}, packageName);
    }

    // 多事务模式包装函数（保持原有接口兼容）
    void gen_uvm_multi_param(picker::pack_opts &opts,
                            const std::vector<uvm_transaction_define> &transactions,
                            const std::vector<std::string> &filenames,
                            const std::string &dut_name) {
        gen_uvm_unified(opts, transactions, filenames, dut_name);
    }

}} // namespace picker::codegen
