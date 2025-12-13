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
        // New directory structure:
        // <TransactionName>/                    <- Top level folder
        //   ├── Makefile
        //   ├── example_dut.py
        //   ├── example_uvm_dut.sv
        //   └── DUT<TransactionName>/          <- Python module package
        //       ├── __init__.py
        //       ├── DUT<TransactionName>.py
        //       ├── <TransactionName>_xagent.py
        //       ├── <TransactionName>_xagent.sv
        //       ├── xspcomm/
        //       └── csrc/                       <- Build artifacts
        
        std::string topFolder = filename;  // Top level: <TransactionName>/
        std::string dutModule = topFolder + "/DUT" + filename;  // Module: DUT<TransactionName>/
        std::string csrcFolder = dutModule + "/csrc";  // Build folder
        
        // Check if top folder exists
        if (std::filesystem::exists(topFolder) && !opts.force) {
            PK_MESSAGE("folder already exists");
            exit(0);
        } else {
            if (std::filesystem::exists(topFolder)) {
                std::filesystem::remove_all(topFolder);
            }
            // Create directory structure
            std::filesystem::create_directories(dutModule);
            std::filesystem::create_directories(csrcFolder);
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
        data["useType"]             = 1;
        data["filepath"]            = transaction.filepath;
        data["version"]             = transaction.version;
        data["datenow"]             = transaction.data_now;
        data["className"]           = transaction.name;
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
        
        // Generate core module files in DUT<TransactionName>/
        gen_uvm_code(data, template_path + "/uvm/xagent.py", dutModule + "/" + filename + "_xagent.py");
        gen_uvm_code(data, template_path + "/uvm/xagent.sv", dutModule + "/" + filename + "_xagent.sv");
        gen_uvm_code(data, template_path + "/uvm/__init__.py", dutModule + "/__init__.py");
        
        // Generate DUT class if requested (always in -d mode based on requirements)
        if (opts.generate_dut) {
            gen_uvm_code(data, template_path + "/uvm/xdut.py", dutModule + "/DUT" + filename + ".py");
        }
        
        // Generate example files in top folder
        if (opts.example) {
            gen_uvm_code(data, template_path + "/uvm/example_dut.py", topFolder + "/example_dut.py");
            gen_uvm_code(data, template_path + "/uvm/example_uvm_dut.sv", topFolder + "/example_uvm_dut.sv");
            gen_uvm_code(data, template_path + "/uvm/Makefile", topFolder + "/Makefile");
        }
        
        std::cout << "generate " + filename + " code successfully." << std::endl;
    }

}} // namespace picker::codegen
