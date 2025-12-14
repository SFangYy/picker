#include "codegen/sv.hpp"

namespace picker { namespace codegen {

    void gen_uvm_code(inja::json data, std::string templateName, std::string outputName)
    {
        // std::cout << className << std::endl;
        std::ifstream template_file(templateName);
        std::string template_str((std::istreambuf_iterator<char>(template_file)), std::istreambuf_iterator<char>());
        template_file.close();

        inja::Environment env;
        std::string rendered = env.render(template_str, data);
        std::ofstream output_file(outputName);
        output_file << rendered;
        output_file.close();
    }

    // namespace sv
    void gen_uvm_param(picker::pack_opts &opts, uvm_transaction_define transaction, std::string filename)
    {
        // Optimized directory structure:
        // Without -e (场景 A/B): <TransactionName>_pkg/ in current directory
        // With -e (场景 C/D): <TransactionName>/ (project root) -> <TransactionName>_pkg/ (package)
        
        std::string topFolder;      // Project root (only for -e mode)
        std::string pkgFolder;      // Package folder: <name>_pkg
        std::string buildFolder;    // Build artifacts folder
        
        if (opts.example) {
            // 场景 C/D: -e mode, create project root and package
            topFolder = filename;                    // e.g., "adder_trans/"
            pkgFolder = topFolder + "/" + filename + "_pkg";  // e.g., "adder_trans/adder_trans_pkg/"
            buildFolder = pkgFolder + "/build";      // e.g., "adder_trans/adder_trans_pkg/build/"
            
            // Check if top folder exists
            if (std::filesystem::exists(topFolder) && !opts.force) {
                PK_MESSAGE("folder already exists");
                exit(0);
            } else {
                if (std::filesystem::exists(topFolder)) {
                    std::filesystem::remove_all(topFolder);
                }
                std::filesystem::create_directories(buildFolder);
            }
        } else {
            // 场景 A/B: no -e, create package directly in current directory
            pkgFolder = filename + "_pkg";           // e.g., "adder_trans_pkg/"
            buildFolder = pkgFolder + "/build";      // e.g., "adder_trans_pkg/build/"
            
            // Check if package folder exists
            if (std::filesystem::exists(pkgFolder) && !opts.force) {
                PK_MESSAGE("folder already exists");
                exit(0);
            } else {
                if (std::filesystem::exists(pkgFolder)) {
                    std::filesystem::remove_all(pkgFolder);
                }
                std::filesystem::create_directories(buildFolder);
            }
        }

        inja::json data;
        std::string erro_message;
        auto python_location = picker::get_xcomm_lib("python/xspcomm", erro_message);
        if (python_location.empty()) { PK_FATAL("%s\n", erro_message.c_str()); }
        data["__XSPCOMM_PYTHON__"]    = python_location;
        auto xspcomm_include_location = picker::get_xcomm_lib("include", erro_message);
        if (python_location.empty()) { PK_FATAL("%s\n", erro_message.c_str()); }
        data["__XSPCOMM_INCLUDE__"] = xspcomm_include_location;
        data["variables"]           = inja::json::array();
        data["transactions"]        = inja::json::array();  // Empty for single-transaction mode
        data["useType"]             = 1;
        data["filepath"]            = transaction.filepath;
        data["version"]             = transaction.version;
        data["datenow"]             = transaction.data_now;
        data["className"]           = transaction.name;
        data["pkgName"]             = filename + "_pkg";  // Package name for templates
        int byte_stream_count       = 0;
        for (int i = 0; i < transaction.parameters.size(); i++) {
            inja::json parameter;
            parameter["nums"]        = transaction.parameters[i].byte_count;
            parameter["bit_count"]   = transaction.parameters[i].bit_count;
            parameter["macro"]       = transaction.parameters[i].is_marcro;
            parameter["name"]        = transaction.parameters[i].name;
            parameter["macro_name"]  = transaction.parameters[i].macro_name;
            parameter["start_index"] = "0";
            parameter["end_index"]   = "0";
            data["variables"].push_back(parameter);
            byte_stream_count += transaction.parameters[i].byte_count;
        }
        data["byte_stream_count"] = byte_stream_count;
        std::string template_path = picker::get_template_path();
        
        // Generate core package files in <name>_pkg/
        gen_uvm_code(data, template_path + "/uvm/xagent.py", pkgFolder + "/" + filename + "_xagent.py");
        gen_uvm_code(data, template_path + "/uvm/xagent.sv", pkgFolder + "/" + filename + "_xagent.sv");
        gen_uvm_code(data, template_path + "/uvm/__init__.py", pkgFolder + "/__init__.py");
        
        // Generate DUT class if requested
        if (opts.generate_dut) {
            gen_uvm_code(data, template_path + "/uvm/xdut.py", pkgFolder + "/" + filename + ".py");
        }
        
        // Generate example files in project root (only when -e is used)
        if (opts.example) {
            if (opts.generate_dut) {
                // 场景 D: DUT mode with example
                gen_uvm_code(data, template_path + "/uvm/example_dut.py", topFolder + "/example_dut.py");
                gen_uvm_code(data, template_path + "/uvm/example_uvm_dut.sv", topFolder + "/example_uvm_dut.sv");
            } else {
                // 场景 C: Non-DUT mode with example
                gen_uvm_code(data, template_path + "/uvm/example_python.py", topFolder + "/example_python.py");
                gen_uvm_code(data, template_path + "/uvm/example_uvm.sv", topFolder + "/example_uvm.sv");
            }
            gen_uvm_code(data, template_path + "/uvm/Makefile", topFolder + "/Makefile");
        }
        
        std::cout << "generate " + filename + " code successfully." << std::endl;
    }

    // Multi-transaction unified agent generation
    void gen_uvm_multi_param(picker::pack_opts &opts, const std::vector<uvm_transaction_define> &transactions, 
                            const std::vector<std::string> &filenames, const std::string &dut_name)
    {
        // Optimized directory structure for multi-transaction:
        // Without -e: <DUTName>_pkg/ in current directory
        // With -e: <DUTName>/ (project root) -> <DUTName>_pkg/ (package)
        
        std::string topFolder;      // Project root (only for -e mode)
        std::string pkgFolder;      // Package folder: <name>_pkg
        std::string buildFolder;    // Build artifacts folder
        
        if (opts.example) {
            // With -e: create project root and package
            topFolder = dut_name;                        // e.g., "ALU/"
            pkgFolder = topFolder + "/" + dut_name + "_pkg";  // e.g., "ALU/ALU_pkg/"
            buildFolder = pkgFolder + "/build";          // e.g., "ALU/ALU_pkg/build/"
            
            // Check if top folder exists
            if (std::filesystem::exists(topFolder) && !opts.force) {
                PK_MESSAGE("folder already exists, use -c/--force to overwrite");
                exit(0);
            } else {
                if (std::filesystem::exists(topFolder)) {
                    std::filesystem::remove_all(topFolder);
                }
                std::filesystem::create_directories(buildFolder);
            }
        } else {
            // Without -e: create package directly in current directory
            pkgFolder = dut_name + "_pkg";               // e.g., "ALU_pkg/"
            buildFolder = pkgFolder + "/build";          // e.g., "ALU_pkg/build/"
            
            // Check if package folder exists
            if (std::filesystem::exists(pkgFolder) && !opts.force) {
                PK_MESSAGE("folder already exists, use -c/--force to overwrite");
                exit(0);
            } else {
                if (std::filesystem::exists(pkgFolder)) {
                    std::filesystem::remove_all(pkgFolder);
                }
                std::filesystem::create_directories(buildFolder);
            }
        }

        // Prepare data for template rendering
        inja::json data;
        std::string erro_message;
        auto python_location = picker::get_xcomm_lib("python/xspcomm", erro_message);
        if (python_location.empty()) { PK_FATAL("%s\n", erro_message.c_str()); }
        data["__XSPCOMM_PYTHON__"] = python_location;
        
        auto xspcomm_include_location = picker::get_xcomm_lib("include", erro_message);
        if (xspcomm_include_location.empty()) { PK_FATAL("%s\n", erro_message.c_str()); }
        data["__XSPCOMM_INCLUDE__"] = xspcomm_include_location;
        
        data["className"] = dut_name;
        data["pkgName"] = dut_name + "_pkg";  // Package name for templates
        data["version"] = transactions[0].version;
        data["datenow"] = transactions[0].data_now;
        data["useType"] = 1;
        
        // Collect all transactions and their variables
        data["transactions"] = inja::json::array();
        data["variables"] = inja::json::array();  // All variables flattened
        int total_byte_count = 0;
        
        for (size_t i = 0; i < transactions.size(); i++) {
            inja::json trans_data;
            trans_data["name"] = transactions[i].name;
            trans_data["filename"] = filenames[i];
            trans_data["filepath"] = transactions[i].filepath;
            trans_data["variables"] = inja::json::array();
            
            int trans_byte_count = 0;
            for (const auto &param : transactions[i].parameters) {
                inja::json parameter;
                parameter["nums"] = param.byte_count;
                parameter["bit_count"] = param.bit_count;
                parameter["macro"] = param.is_marcro;
                parameter["name"] = param.name;
                parameter["macro_name"] = param.macro_name;
                parameter["start_index"] = "0";
                parameter["end_index"] = "0";
                parameter["transaction_name"] = transactions[i].name;  // For DUT class generation
                
                trans_data["variables"].push_back(parameter);
                data["variables"].push_back(parameter);  // Add to flattened list
                trans_byte_count += param.byte_count;
            }
            
            trans_data["byte_stream_count"] = trans_byte_count;
            total_byte_count += trans_byte_count;
            data["transactions"].push_back(trans_data);
        }
        
        data["byte_stream_count"] = total_byte_count;
        data["transaction_count"] = transactions.size();
        
        std::string template_path = picker::get_template_path();
        
        // Generate individual agent files for each transaction type in package
        for (size_t i = 0; i < transactions.size(); i++) {
            // Create single-transaction data for this specific transaction
            inja::json single_data;
            single_data["__XSPCOMM_PYTHON__"] = data["__XSPCOMM_PYTHON__"];
            single_data["__XSPCOMM_INCLUDE__"] = data["__XSPCOMM_INCLUDE__"];
            single_data["version"] = transactions[i].version;
            single_data["datenow"] = transactions[i].data_now;
            single_data["className"] = transactions[i].name;
            single_data["pkgName"] = dut_name + "_pkg";
            single_data["filepath"] = transactions[i].filepath;
            single_data["useType"] = 1;
            single_data["transactions"] = inja::json::array();  // Empty for per-transaction SV file
            single_data["variables"] = inja::json::array();
            
            int trans_byte_count = 0;
            for (const auto &param : transactions[i].parameters) {
                inja::json parameter;
                parameter["nums"] = param.byte_count;
                parameter["bit_count"] = param.bit_count;
                parameter["macro"] = param.is_marcro;
                parameter["name"] = param.name;
                parameter["macro_name"] = param.macro_name;
                parameter["start_index"] = "0";
                parameter["end_index"] = "0";
                single_data["variables"].push_back(parameter);
                trans_byte_count += param.byte_count;
            }
            single_data["byte_stream_count"] = trans_byte_count;
            
            // Generate SV agent for this transaction in package
            gen_uvm_code(single_data, template_path + "/uvm/xagent.sv", 
                        pkgFolder + "/" + transactions[i].name + "_xagent.sv");
        }
        
        // Generate unified Python agent with all transactions in package
        gen_uvm_code(data, template_path + "/uvm/xagent.py", pkgFolder + "/" + dut_name + "_xagent.py");
        gen_uvm_code(data, template_path + "/uvm/__init__.py", pkgFolder + "/__init__.py");
        
        // Generate unified DUT class in package
        if (opts.generate_dut) {
            gen_uvm_code(data, template_path + "/uvm/xdut.py", pkgFolder + "/" + dut_name + ".py");
        }
        
        // Generate example files in project root (only when -e is used)
        if (opts.example) {
            if (opts.generate_dut) {
                // DUT mode with example
                gen_uvm_code(data, template_path + "/uvm/example_dut.py", topFolder + "/example_dut.py");
                gen_uvm_code(data, template_path + "/uvm/example_uvm_dut.sv", topFolder + "/example_uvm_dut.sv");
            } else {
                // Non-DUT mode with example
                gen_uvm_code(data, template_path + "/uvm/example_python.py", topFolder + "/example_python.py");
                gen_uvm_code(data, template_path + "/uvm/example_uvm.sv", topFolder + "/example_uvm.sv");
            }
            gen_uvm_code(data, template_path + "/uvm/Makefile", topFolder + "/Makefile");
        }
        
        std::cout << "generate " + dut_name + " multi-transaction agent successfully." << std::endl;
    }

}} // namespace picker::codegen
