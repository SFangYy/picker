//=========================================================
//File name    : CSR_in_agent_xaction.sv
//Author       : nanyunhao
//Module name  : CSR_in_agent_xaction
//Discribution : CSR_in_agent_xaction : agent transaction
//Date         : 2026-01-22
//=========================================================
`ifndef CSR_IN_AGENT_XACTION__SV
`define CSR_IN_AGENT_XACTION__SV

class CSR_in_agent_xaction  extends tcnt_data_base;
    rand bit         io_csr_intrBitSet ;
    rand bit         io_csr_wfiEvent   ;
    rand bit         io_csr_criticalErrorState;
    rand bit         io_snpt_snptDeq   ;
    rand bit         io_snpt_useSnpt   ;
    rand bit [1:0]   io_snpt_snptSelect;
    rand bit         io_snpt_flushVec_0;
    rand bit         io_snpt_flushVec_1;
    rand bit         io_snpt_flushVec_2;
    rand bit         io_snpt_flushVec_3;
    rand bit         io_wfi_safeFromMem;
    rand bit         io_wfi_safeFromFrontend;
    rand bit         io_wfi_enable     ;
    rand bit         io_fromVecExcpMod_busy;
    rand bit [55:0]  io_readGPAMemData_gpaddr;
    rand bit         io_readGPAMemData_isForVSnonLeafPTE;
    rand bit         io_vstartIsZero   ;
    rand bit         io_debugEnqLsq_canAccept;
    rand bit [1:0]   io_debugEnqLsq_needAlloc_0;
    rand bit [1:0]   io_debugEnqLsq_needAlloc_1;
    rand bit [1:0]   io_debugEnqLsq_needAlloc_2;
    rand bit [1:0]   io_debugEnqLsq_needAlloc_3;
    rand bit [1:0]   io_debugEnqLsq_needAlloc_4;
    rand bit [1:0]   io_debugEnqLsq_needAlloc_5;
    rand bit         io_debugEnqLsq_req_0_valid;
    rand bit [7:0]   io_debugEnqLsq_req_0_bits_robIdx_value;
    rand bit [6:0]   io_debugEnqLsq_req_0_bits_lqIdx_value;
    rand bit         io_debugEnqLsq_req_1_valid;
    rand bit [7:0]   io_debugEnqLsq_req_1_bits_robIdx_value;
    rand bit [6:0]   io_debugEnqLsq_req_1_bits_lqIdx_value;
    rand bit         io_debugEnqLsq_req_2_valid;
    rand bit [7:0]   io_debugEnqLsq_req_2_bits_robIdx_value;
    rand bit [6:0]   io_debugEnqLsq_req_2_bits_lqIdx_value;
    rand bit         io_debugEnqLsq_req_3_valid;
    rand bit [7:0]   io_debugEnqLsq_req_3_bits_robIdx_value;
    rand bit [6:0]   io_debugEnqLsq_req_3_bits_lqIdx_value;
    rand bit         io_debugEnqLsq_req_4_valid;
    rand bit [7:0]   io_debugEnqLsq_req_4_bits_robIdx_value;
    rand bit [6:0]   io_debugEnqLsq_req_4_bits_lqIdx_value;
    rand bit         io_debugEnqLsq_req_5_valid;
    rand bit [7:0]   io_debugEnqLsq_req_5_bits_robIdx_value;
    rand bit [6:0]   io_debugEnqLsq_req_5_bits_lqIdx_value;
    rand bit         io_debugInstrAddrTransType_bare;
    rand bit         io_debugInstrAddrTransType_sv39;
    rand bit         io_debugInstrAddrTransType_sv39x4;
    rand bit         io_debugInstrAddrTransType_sv48;
    rand bit         io_debugInstrAddrTransType_sv48x4;
    rand bit [7:0]   io_storeDebugInfo_0_robidx_value;
    rand bit [7:0]   io_storeDebugInfo_1_robidx_value;

    extern constraint default_io_csr_intrBitSet_cons;
    extern constraint default_io_csr_wfiEvent_cons;
    extern constraint default_io_csr_criticalErrorState_cons;
    extern constraint default_io_snpt_snptDeq_cons;
    extern constraint default_io_snpt_useSnpt_cons;
    extern constraint default_io_snpt_snptSelect_cons;
    extern constraint default_io_snpt_flushVec_0_cons;
    extern constraint default_io_snpt_flushVec_1_cons;
    extern constraint default_io_snpt_flushVec_2_cons;
    extern constraint default_io_snpt_flushVec_3_cons;
    extern constraint default_io_wfi_safeFromMem_cons;
    extern constraint default_io_wfi_safeFromFrontend_cons;
    extern constraint default_io_wfi_enable_cons;
    extern constraint default_io_fromVecExcpMod_busy_cons;
    extern constraint default_io_readGPAMemData_gpaddr_cons;
    extern constraint default_io_readGPAMemData_isForVSnonLeafPTE_cons;
    extern constraint default_io_vstartIsZero_cons;
    extern constraint default_io_debugEnqLsq_canAccept_cons;
    extern constraint default_io_debugEnqLsq_needAlloc_0_cons;
    extern constraint default_io_debugEnqLsq_needAlloc_1_cons;
    extern constraint default_io_debugEnqLsq_needAlloc_2_cons;
    extern constraint default_io_debugEnqLsq_needAlloc_3_cons;
    extern constraint default_io_debugEnqLsq_needAlloc_4_cons;
    extern constraint default_io_debugEnqLsq_needAlloc_5_cons;
    extern constraint default_io_debugEnqLsq_req_0_valid_cons;
    extern constraint default_io_debugEnqLsq_req_0_bits_robIdx_value_cons;
    extern constraint default_io_debugEnqLsq_req_0_bits_lqIdx_value_cons;
    extern constraint default_io_debugEnqLsq_req_1_valid_cons;
    extern constraint default_io_debugEnqLsq_req_1_bits_robIdx_value_cons;
    extern constraint default_io_debugEnqLsq_req_1_bits_lqIdx_value_cons;
    extern constraint default_io_debugEnqLsq_req_2_valid_cons;
    extern constraint default_io_debugEnqLsq_req_2_bits_robIdx_value_cons;
    extern constraint default_io_debugEnqLsq_req_2_bits_lqIdx_value_cons;
    extern constraint default_io_debugEnqLsq_req_3_valid_cons;
    extern constraint default_io_debugEnqLsq_req_3_bits_robIdx_value_cons;
    extern constraint default_io_debugEnqLsq_req_3_bits_lqIdx_value_cons;
    extern constraint default_io_debugEnqLsq_req_4_valid_cons;
    extern constraint default_io_debugEnqLsq_req_4_bits_robIdx_value_cons;
    extern constraint default_io_debugEnqLsq_req_4_bits_lqIdx_value_cons;
    extern constraint default_io_debugEnqLsq_req_5_valid_cons;
    extern constraint default_io_debugEnqLsq_req_5_bits_robIdx_value_cons;
    extern constraint default_io_debugEnqLsq_req_5_bits_lqIdx_value_cons;
    extern constraint default_io_debugInstrAddrTransType_bare_cons;
    extern constraint default_io_debugInstrAddrTransType_sv39_cons;
    extern constraint default_io_debugInstrAddrTransType_sv39x4_cons;
    extern constraint default_io_debugInstrAddrTransType_sv48_cons;
    extern constraint default_io_debugInstrAddrTransType_sv48x4_cons;
    extern constraint default_io_storeDebugInfo_0_robidx_value_cons;
    extern constraint default_io_storeDebugInfo_1_robidx_value_cons;

    extern function new(string name="CSR_in_agent_xaction");
    extern function void pack();
    extern function void unpack();
    extern function void pre_randomize();
    extern function void post_randomize();
    extern function string psdisplay(string prefix = "");
    extern function bit compare(uvm_object rhs, uvm_comparer comparer=null);

    `uvm_object_utils_begin(CSR_in_agent_xaction)
        `uvm_field_int(io_csr_intrBitSet, UVM_ALL_ON);
        `uvm_field_int(io_csr_wfiEvent, UVM_ALL_ON);
        `uvm_field_int(io_csr_criticalErrorState, UVM_ALL_ON);
        `uvm_field_int(io_snpt_snptDeq, UVM_ALL_ON);
        `uvm_field_int(io_snpt_useSnpt, UVM_ALL_ON);
        `uvm_field_int(io_snpt_snptSelect, UVM_ALL_ON);
        `uvm_field_int(io_snpt_flushVec_0, UVM_ALL_ON);
        `uvm_field_int(io_snpt_flushVec_1, UVM_ALL_ON);
        `uvm_field_int(io_snpt_flushVec_2, UVM_ALL_ON);
        `uvm_field_int(io_snpt_flushVec_3, UVM_ALL_ON);
        `uvm_field_int(io_wfi_safeFromMem, UVM_ALL_ON);
        `uvm_field_int(io_wfi_safeFromFrontend, UVM_ALL_ON);
        `uvm_field_int(io_wfi_enable, UVM_ALL_ON);
        `uvm_field_int(io_fromVecExcpMod_busy, UVM_ALL_ON);
        `uvm_field_int(io_readGPAMemData_gpaddr, UVM_ALL_ON);
        `uvm_field_int(io_readGPAMemData_isForVSnonLeafPTE, UVM_ALL_ON);
        `uvm_field_int(io_vstartIsZero, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_canAccept, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_needAlloc_0, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_needAlloc_1, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_needAlloc_2, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_needAlloc_3, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_needAlloc_4, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_needAlloc_5, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_0_valid, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_0_bits_robIdx_value, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_0_bits_lqIdx_value, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_1_valid, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_1_bits_robIdx_value, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_1_bits_lqIdx_value, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_2_valid, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_2_bits_robIdx_value, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_2_bits_lqIdx_value, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_3_valid, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_3_bits_robIdx_value, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_3_bits_lqIdx_value, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_4_valid, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_4_bits_robIdx_value, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_4_bits_lqIdx_value, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_5_valid, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_5_bits_robIdx_value, UVM_ALL_ON);
        `uvm_field_int(io_debugEnqLsq_req_5_bits_lqIdx_value, UVM_ALL_ON);
        `uvm_field_int(io_debugInstrAddrTransType_bare, UVM_ALL_ON);
        `uvm_field_int(io_debugInstrAddrTransType_sv39, UVM_ALL_ON);
        `uvm_field_int(io_debugInstrAddrTransType_sv39x4, UVM_ALL_ON);
        `uvm_field_int(io_debugInstrAddrTransType_sv48, UVM_ALL_ON);
        `uvm_field_int(io_debugInstrAddrTransType_sv48x4, UVM_ALL_ON);
        `uvm_field_int(io_storeDebugInfo_0_robidx_value, UVM_ALL_ON);
        `uvm_field_int(io_storeDebugInfo_1_robidx_value, UVM_ALL_ON);

    `uvm_object_utils_end

endclass:CSR_in_agent_xaction

constraint CSR_in_agent_xaction::default_io_csr_intrBitSet_cons{

}

constraint CSR_in_agent_xaction::default_io_csr_wfiEvent_cons{

}

constraint CSR_in_agent_xaction::default_io_csr_criticalErrorState_cons{

}

constraint CSR_in_agent_xaction::default_io_snpt_snptDeq_cons{

}

constraint CSR_in_agent_xaction::default_io_snpt_useSnpt_cons{

}

constraint CSR_in_agent_xaction::default_io_snpt_snptSelect_cons{

}

constraint CSR_in_agent_xaction::default_io_snpt_flushVec_0_cons{

}

constraint CSR_in_agent_xaction::default_io_snpt_flushVec_1_cons{

}

constraint CSR_in_agent_xaction::default_io_snpt_flushVec_2_cons{

}

constraint CSR_in_agent_xaction::default_io_snpt_flushVec_3_cons{

}

constraint CSR_in_agent_xaction::default_io_wfi_safeFromMem_cons{

}

constraint CSR_in_agent_xaction::default_io_wfi_safeFromFrontend_cons{

}

constraint CSR_in_agent_xaction::default_io_wfi_enable_cons{

}

constraint CSR_in_agent_xaction::default_io_fromVecExcpMod_busy_cons{

}

constraint CSR_in_agent_xaction::default_io_readGPAMemData_gpaddr_cons{

}

constraint CSR_in_agent_xaction::default_io_readGPAMemData_isForVSnonLeafPTE_cons{

}

constraint CSR_in_agent_xaction::default_io_vstartIsZero_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_canAccept_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_needAlloc_0_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_needAlloc_1_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_needAlloc_2_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_needAlloc_3_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_needAlloc_4_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_needAlloc_5_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_0_valid_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_0_bits_robIdx_value_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_0_bits_lqIdx_value_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_1_valid_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_1_bits_robIdx_value_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_1_bits_lqIdx_value_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_2_valid_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_2_bits_robIdx_value_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_2_bits_lqIdx_value_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_3_valid_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_3_bits_robIdx_value_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_3_bits_lqIdx_value_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_4_valid_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_4_bits_robIdx_value_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_4_bits_lqIdx_value_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_5_valid_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_5_bits_robIdx_value_cons{

}

constraint CSR_in_agent_xaction::default_io_debugEnqLsq_req_5_bits_lqIdx_value_cons{

}

constraint CSR_in_agent_xaction::default_io_debugInstrAddrTransType_bare_cons{

}

constraint CSR_in_agent_xaction::default_io_debugInstrAddrTransType_sv39_cons{

}

constraint CSR_in_agent_xaction::default_io_debugInstrAddrTransType_sv39x4_cons{

}

constraint CSR_in_agent_xaction::default_io_debugInstrAddrTransType_sv48_cons{

}

constraint CSR_in_agent_xaction::default_io_debugInstrAddrTransType_sv48x4_cons{

}

constraint CSR_in_agent_xaction::default_io_storeDebugInfo_0_robidx_value_cons{

}

constraint CSR_in_agent_xaction::default_io_storeDebugInfo_1_robidx_value_cons{

}

function CSR_in_agent_xaction::new(string name = "CSR_in_agent_xaction");
    super.new();
endfunction:new

function void CSR_in_agent_xaction::pack();
    super.pack();
endfunction:pack
function void CSR_in_agent_xaction::unpack();
    super.unpack();
endfunction:unpack
function void CSR_in_agent_xaction::pre_randomize();
    super.pre_randomize();
endfunction:pre_randomize
function void CSR_in_agent_xaction::post_randomize();
    super.post_randomize();
    //this.pack();
endfunction:post_randomize

function string CSR_in_agent_xaction::psdisplay(string prefix = "");
    string pkt_str;
    pkt_str = $sformatf("%s for packet[%0d] >>>>",prefix,this.pkt_index);
    pkt_str = $sformatf("%schannel_id=%0d ",pkt_str,this.channel_id);
    pkt_str = $sformatf("%sstart=%0f finish=%0f >>>>\n",pkt_str,this.start,this.finish);
    //foreach(this.pload_q[i]) begin
    //    pkt_str = $sformatf("%spload_q[%0d]=0x%2h  ",pkt_str,i,this.pload_q[i]);
    //end
    pkt_str = $sformatf("%sio_csr_intrBitSet = 0x%0h ",pkt_str,this.io_csr_intrBitSet);
    pkt_str = $sformatf("%sio_csr_wfiEvent = 0x%0h ",pkt_str,this.io_csr_wfiEvent);
    pkt_str = $sformatf("%sio_csr_criticalErrorState = 0x%0h ",pkt_str,this.io_csr_criticalErrorState);
    pkt_str = $sformatf("%sio_snpt_snptDeq = 0x%0h ",pkt_str,this.io_snpt_snptDeq);
    pkt_str = $sformatf("%sio_snpt_useSnpt = 0x%0h ",pkt_str,this.io_snpt_useSnpt);
    pkt_str = $sformatf("%sio_snpt_snptSelect = 0x%0h ",pkt_str,this.io_snpt_snptSelect);
    pkt_str = $sformatf("%sio_snpt_flushVec_0 = 0x%0h ",pkt_str,this.io_snpt_flushVec_0);
    pkt_str = $sformatf("%sio_snpt_flushVec_1 = 0x%0h ",pkt_str,this.io_snpt_flushVec_1);
    pkt_str = $sformatf("%sio_snpt_flushVec_2 = 0x%0h ",pkt_str,this.io_snpt_flushVec_2);
    pkt_str = $sformatf("%sio_snpt_flushVec_3 = 0x%0h ",pkt_str,this.io_snpt_flushVec_3);
    pkt_str = $sformatf("%sio_wfi_safeFromMem = 0x%0h ",pkt_str,this.io_wfi_safeFromMem);
    pkt_str = $sformatf("%sio_wfi_safeFromFrontend = 0x%0h ",pkt_str,this.io_wfi_safeFromFrontend);
    pkt_str = $sformatf("%sio_wfi_enable = 0x%0h ",pkt_str,this.io_wfi_enable);
    pkt_str = $sformatf("%sio_fromVecExcpMod_busy = 0x%0h ",pkt_str,this.io_fromVecExcpMod_busy);
    pkt_str = $sformatf("%sio_readGPAMemData_gpaddr = 0x%0h ",pkt_str,this.io_readGPAMemData_gpaddr);
    pkt_str = $sformatf("%sio_readGPAMemData_isForVSnonLeafPTE = 0x%0h ",pkt_str,this.io_readGPAMemData_isForVSnonLeafPTE);
    pkt_str = $sformatf("%sio_vstartIsZero = 0x%0h ",pkt_str,this.io_vstartIsZero);
    pkt_str = $sformatf("%sio_debugEnqLsq_canAccept = 0x%0h ",pkt_str,this.io_debugEnqLsq_canAccept);
    pkt_str = $sformatf("%sio_debugEnqLsq_needAlloc_0 = 0x%0h ",pkt_str,this.io_debugEnqLsq_needAlloc_0);
    pkt_str = $sformatf("%sio_debugEnqLsq_needAlloc_1 = 0x%0h ",pkt_str,this.io_debugEnqLsq_needAlloc_1);
    pkt_str = $sformatf("%sio_debugEnqLsq_needAlloc_2 = 0x%0h ",pkt_str,this.io_debugEnqLsq_needAlloc_2);
    pkt_str = $sformatf("%sio_debugEnqLsq_needAlloc_3 = 0x%0h ",pkt_str,this.io_debugEnqLsq_needAlloc_3);
    pkt_str = $sformatf("%sio_debugEnqLsq_needAlloc_4 = 0x%0h ",pkt_str,this.io_debugEnqLsq_needAlloc_4);
    pkt_str = $sformatf("%sio_debugEnqLsq_needAlloc_5 = 0x%0h ",pkt_str,this.io_debugEnqLsq_needAlloc_5);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_0_valid = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_0_valid);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_0_bits_robIdx_value = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_0_bits_robIdx_value);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_0_bits_lqIdx_value = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_0_bits_lqIdx_value);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_1_valid = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_1_valid);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_1_bits_robIdx_value = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_1_bits_robIdx_value);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_1_bits_lqIdx_value = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_1_bits_lqIdx_value);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_2_valid = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_2_valid);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_2_bits_robIdx_value = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_2_bits_robIdx_value);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_2_bits_lqIdx_value = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_2_bits_lqIdx_value);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_3_valid = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_3_valid);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_3_bits_robIdx_value = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_3_bits_robIdx_value);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_3_bits_lqIdx_value = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_3_bits_lqIdx_value);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_4_valid = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_4_valid);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_4_bits_robIdx_value = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_4_bits_robIdx_value);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_4_bits_lqIdx_value = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_4_bits_lqIdx_value);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_5_valid = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_5_valid);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_5_bits_robIdx_value = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_5_bits_robIdx_value);
    pkt_str = $sformatf("%sio_debugEnqLsq_req_5_bits_lqIdx_value = 0x%0h ",pkt_str,this.io_debugEnqLsq_req_5_bits_lqIdx_value);
    pkt_str = $sformatf("%sio_debugInstrAddrTransType_bare = 0x%0h ",pkt_str,this.io_debugInstrAddrTransType_bare);
    pkt_str = $sformatf("%sio_debugInstrAddrTransType_sv39 = 0x%0h ",pkt_str,this.io_debugInstrAddrTransType_sv39);
    pkt_str = $sformatf("%sio_debugInstrAddrTransType_sv39x4 = 0x%0h ",pkt_str,this.io_debugInstrAddrTransType_sv39x4);
    pkt_str = $sformatf("%sio_debugInstrAddrTransType_sv48 = 0x%0h ",pkt_str,this.io_debugInstrAddrTransType_sv48);
    pkt_str = $sformatf("%sio_debugInstrAddrTransType_sv48x4 = 0x%0h ",pkt_str,this.io_debugInstrAddrTransType_sv48x4);
    pkt_str = $sformatf("%sio_storeDebugInfo_0_robidx_value = 0x%0h ",pkt_str,this.io_storeDebugInfo_0_robidx_value);
    pkt_str = $sformatf("%sio_storeDebugInfo_1_robidx_value = 0x%0h ",pkt_str,this.io_storeDebugInfo_1_robidx_value);

    return pkt_str;
endfunction:psdisplay

function bit CSR_in_agent_xaction::compare(uvm_object rhs, uvm_comparer comparer=null);
    bit super_result;
    CSR_in_agent_xaction  rhs_;
    if(!$cast(rhs_, rhs)) begin
        `uvm_fatal(get_type_name(),$sformatf("rhs is not a CSR_in_agent_xaction or its extend"))
    end
    super_result = super.compare(rhs_,comparer);
    if(super_result==0) begin
        super_result = 1;
        //foreach(this.pload_q[i]) begin
        //    if(this.pload_q[i]!=rhs_.pload_q[i]) begin
        //        super_result = 0;
        //        `uvm_info(get_type_name(),$sformatf("compare fail for this.pload[%0d]=0x%2h while the rhs_.pload[%0d]=0x%2h",i,this.pload_q[i],i,rhs_.pload_q[i]),UVM_NONE)
        //    end
        //end

        if(this.io_csr_intrBitSet!=rhs_.io_csr_intrBitSet) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_csr_intrBitSet=0x%0h while the rhs_.io_csr_intrBitSet=0x%0h",this.io_csr_intrBitSet,rhs_.io_csr_intrBitSet),UVM_NONE)
        end

        if(this.io_csr_wfiEvent!=rhs_.io_csr_wfiEvent) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_csr_wfiEvent=0x%0h while the rhs_.io_csr_wfiEvent=0x%0h",this.io_csr_wfiEvent,rhs_.io_csr_wfiEvent),UVM_NONE)
        end

        if(this.io_csr_criticalErrorState!=rhs_.io_csr_criticalErrorState) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_csr_criticalErrorState=0x%0h while the rhs_.io_csr_criticalErrorState=0x%0h",this.io_csr_criticalErrorState,rhs_.io_csr_criticalErrorState),UVM_NONE)
        end

        if(this.io_snpt_snptDeq!=rhs_.io_snpt_snptDeq) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_snpt_snptDeq=0x%0h while the rhs_.io_snpt_snptDeq=0x%0h",this.io_snpt_snptDeq,rhs_.io_snpt_snptDeq),UVM_NONE)
        end

        if(this.io_snpt_useSnpt!=rhs_.io_snpt_useSnpt) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_snpt_useSnpt=0x%0h while the rhs_.io_snpt_useSnpt=0x%0h",this.io_snpt_useSnpt,rhs_.io_snpt_useSnpt),UVM_NONE)
        end

        if(this.io_snpt_snptSelect!=rhs_.io_snpt_snptSelect) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_snpt_snptSelect=0x%0h while the rhs_.io_snpt_snptSelect=0x%0h",this.io_snpt_snptSelect,rhs_.io_snpt_snptSelect),UVM_NONE)
        end

        if(this.io_snpt_flushVec_0!=rhs_.io_snpt_flushVec_0) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_snpt_flushVec_0=0x%0h while the rhs_.io_snpt_flushVec_0=0x%0h",this.io_snpt_flushVec_0,rhs_.io_snpt_flushVec_0),UVM_NONE)
        end

        if(this.io_snpt_flushVec_1!=rhs_.io_snpt_flushVec_1) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_snpt_flushVec_1=0x%0h while the rhs_.io_snpt_flushVec_1=0x%0h",this.io_snpt_flushVec_1,rhs_.io_snpt_flushVec_1),UVM_NONE)
        end

        if(this.io_snpt_flushVec_2!=rhs_.io_snpt_flushVec_2) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_snpt_flushVec_2=0x%0h while the rhs_.io_snpt_flushVec_2=0x%0h",this.io_snpt_flushVec_2,rhs_.io_snpt_flushVec_2),UVM_NONE)
        end

        if(this.io_snpt_flushVec_3!=rhs_.io_snpt_flushVec_3) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_snpt_flushVec_3=0x%0h while the rhs_.io_snpt_flushVec_3=0x%0h",this.io_snpt_flushVec_3,rhs_.io_snpt_flushVec_3),UVM_NONE)
        end

        if(this.io_wfi_safeFromMem!=rhs_.io_wfi_safeFromMem) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_wfi_safeFromMem=0x%0h while the rhs_.io_wfi_safeFromMem=0x%0h",this.io_wfi_safeFromMem,rhs_.io_wfi_safeFromMem),UVM_NONE)
        end

        if(this.io_wfi_safeFromFrontend!=rhs_.io_wfi_safeFromFrontend) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_wfi_safeFromFrontend=0x%0h while the rhs_.io_wfi_safeFromFrontend=0x%0h",this.io_wfi_safeFromFrontend,rhs_.io_wfi_safeFromFrontend),UVM_NONE)
        end

        if(this.io_wfi_enable!=rhs_.io_wfi_enable) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_wfi_enable=0x%0h while the rhs_.io_wfi_enable=0x%0h",this.io_wfi_enable,rhs_.io_wfi_enable),UVM_NONE)
        end

        if(this.io_fromVecExcpMod_busy!=rhs_.io_fromVecExcpMod_busy) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_fromVecExcpMod_busy=0x%0h while the rhs_.io_fromVecExcpMod_busy=0x%0h",this.io_fromVecExcpMod_busy,rhs_.io_fromVecExcpMod_busy),UVM_NONE)
        end

        if(this.io_readGPAMemData_gpaddr!=rhs_.io_readGPAMemData_gpaddr) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_readGPAMemData_gpaddr=0x%0h while the rhs_.io_readGPAMemData_gpaddr=0x%0h",this.io_readGPAMemData_gpaddr,rhs_.io_readGPAMemData_gpaddr),UVM_NONE)
        end

        if(this.io_readGPAMemData_isForVSnonLeafPTE!=rhs_.io_readGPAMemData_isForVSnonLeafPTE) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_readGPAMemData_isForVSnonLeafPTE=0x%0h while the rhs_.io_readGPAMemData_isForVSnonLeafPTE=0x%0h",this.io_readGPAMemData_isForVSnonLeafPTE,rhs_.io_readGPAMemData_isForVSnonLeafPTE),UVM_NONE)
        end

        if(this.io_vstartIsZero!=rhs_.io_vstartIsZero) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_vstartIsZero=0x%0h while the rhs_.io_vstartIsZero=0x%0h",this.io_vstartIsZero,rhs_.io_vstartIsZero),UVM_NONE)
        end

        if(this.io_debugEnqLsq_canAccept!=rhs_.io_debugEnqLsq_canAccept) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_canAccept=0x%0h while the rhs_.io_debugEnqLsq_canAccept=0x%0h",this.io_debugEnqLsq_canAccept,rhs_.io_debugEnqLsq_canAccept),UVM_NONE)
        end

        if(this.io_debugEnqLsq_needAlloc_0!=rhs_.io_debugEnqLsq_needAlloc_0) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_needAlloc_0=0x%0h while the rhs_.io_debugEnqLsq_needAlloc_0=0x%0h",this.io_debugEnqLsq_needAlloc_0,rhs_.io_debugEnqLsq_needAlloc_0),UVM_NONE)
        end

        if(this.io_debugEnqLsq_needAlloc_1!=rhs_.io_debugEnqLsq_needAlloc_1) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_needAlloc_1=0x%0h while the rhs_.io_debugEnqLsq_needAlloc_1=0x%0h",this.io_debugEnqLsq_needAlloc_1,rhs_.io_debugEnqLsq_needAlloc_1),UVM_NONE)
        end

        if(this.io_debugEnqLsq_needAlloc_2!=rhs_.io_debugEnqLsq_needAlloc_2) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_needAlloc_2=0x%0h while the rhs_.io_debugEnqLsq_needAlloc_2=0x%0h",this.io_debugEnqLsq_needAlloc_2,rhs_.io_debugEnqLsq_needAlloc_2),UVM_NONE)
        end

        if(this.io_debugEnqLsq_needAlloc_3!=rhs_.io_debugEnqLsq_needAlloc_3) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_needAlloc_3=0x%0h while the rhs_.io_debugEnqLsq_needAlloc_3=0x%0h",this.io_debugEnqLsq_needAlloc_3,rhs_.io_debugEnqLsq_needAlloc_3),UVM_NONE)
        end

        if(this.io_debugEnqLsq_needAlloc_4!=rhs_.io_debugEnqLsq_needAlloc_4) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_needAlloc_4=0x%0h while the rhs_.io_debugEnqLsq_needAlloc_4=0x%0h",this.io_debugEnqLsq_needAlloc_4,rhs_.io_debugEnqLsq_needAlloc_4),UVM_NONE)
        end

        if(this.io_debugEnqLsq_needAlloc_5!=rhs_.io_debugEnqLsq_needAlloc_5) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_needAlloc_5=0x%0h while the rhs_.io_debugEnqLsq_needAlloc_5=0x%0h",this.io_debugEnqLsq_needAlloc_5,rhs_.io_debugEnqLsq_needAlloc_5),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_0_valid!=rhs_.io_debugEnqLsq_req_0_valid) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_0_valid=0x%0h while the rhs_.io_debugEnqLsq_req_0_valid=0x%0h",this.io_debugEnqLsq_req_0_valid,rhs_.io_debugEnqLsq_req_0_valid),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_0_bits_robIdx_value!=rhs_.io_debugEnqLsq_req_0_bits_robIdx_value) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_0_bits_robIdx_value=0x%0h while the rhs_.io_debugEnqLsq_req_0_bits_robIdx_value=0x%0h",this.io_debugEnqLsq_req_0_bits_robIdx_value,rhs_.io_debugEnqLsq_req_0_bits_robIdx_value),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_0_bits_lqIdx_value!=rhs_.io_debugEnqLsq_req_0_bits_lqIdx_value) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_0_bits_lqIdx_value=0x%0h while the rhs_.io_debugEnqLsq_req_0_bits_lqIdx_value=0x%0h",this.io_debugEnqLsq_req_0_bits_lqIdx_value,rhs_.io_debugEnqLsq_req_0_bits_lqIdx_value),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_1_valid!=rhs_.io_debugEnqLsq_req_1_valid) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_1_valid=0x%0h while the rhs_.io_debugEnqLsq_req_1_valid=0x%0h",this.io_debugEnqLsq_req_1_valid,rhs_.io_debugEnqLsq_req_1_valid),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_1_bits_robIdx_value!=rhs_.io_debugEnqLsq_req_1_bits_robIdx_value) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_1_bits_robIdx_value=0x%0h while the rhs_.io_debugEnqLsq_req_1_bits_robIdx_value=0x%0h",this.io_debugEnqLsq_req_1_bits_robIdx_value,rhs_.io_debugEnqLsq_req_1_bits_robIdx_value),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_1_bits_lqIdx_value!=rhs_.io_debugEnqLsq_req_1_bits_lqIdx_value) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_1_bits_lqIdx_value=0x%0h while the rhs_.io_debugEnqLsq_req_1_bits_lqIdx_value=0x%0h",this.io_debugEnqLsq_req_1_bits_lqIdx_value,rhs_.io_debugEnqLsq_req_1_bits_lqIdx_value),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_2_valid!=rhs_.io_debugEnqLsq_req_2_valid) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_2_valid=0x%0h while the rhs_.io_debugEnqLsq_req_2_valid=0x%0h",this.io_debugEnqLsq_req_2_valid,rhs_.io_debugEnqLsq_req_2_valid),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_2_bits_robIdx_value!=rhs_.io_debugEnqLsq_req_2_bits_robIdx_value) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_2_bits_robIdx_value=0x%0h while the rhs_.io_debugEnqLsq_req_2_bits_robIdx_value=0x%0h",this.io_debugEnqLsq_req_2_bits_robIdx_value,rhs_.io_debugEnqLsq_req_2_bits_robIdx_value),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_2_bits_lqIdx_value!=rhs_.io_debugEnqLsq_req_2_bits_lqIdx_value) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_2_bits_lqIdx_value=0x%0h while the rhs_.io_debugEnqLsq_req_2_bits_lqIdx_value=0x%0h",this.io_debugEnqLsq_req_2_bits_lqIdx_value,rhs_.io_debugEnqLsq_req_2_bits_lqIdx_value),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_3_valid!=rhs_.io_debugEnqLsq_req_3_valid) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_3_valid=0x%0h while the rhs_.io_debugEnqLsq_req_3_valid=0x%0h",this.io_debugEnqLsq_req_3_valid,rhs_.io_debugEnqLsq_req_3_valid),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_3_bits_robIdx_value!=rhs_.io_debugEnqLsq_req_3_bits_robIdx_value) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_3_bits_robIdx_value=0x%0h while the rhs_.io_debugEnqLsq_req_3_bits_robIdx_value=0x%0h",this.io_debugEnqLsq_req_3_bits_robIdx_value,rhs_.io_debugEnqLsq_req_3_bits_robIdx_value),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_3_bits_lqIdx_value!=rhs_.io_debugEnqLsq_req_3_bits_lqIdx_value) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_3_bits_lqIdx_value=0x%0h while the rhs_.io_debugEnqLsq_req_3_bits_lqIdx_value=0x%0h",this.io_debugEnqLsq_req_3_bits_lqIdx_value,rhs_.io_debugEnqLsq_req_3_bits_lqIdx_value),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_4_valid!=rhs_.io_debugEnqLsq_req_4_valid) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_4_valid=0x%0h while the rhs_.io_debugEnqLsq_req_4_valid=0x%0h",this.io_debugEnqLsq_req_4_valid,rhs_.io_debugEnqLsq_req_4_valid),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_4_bits_robIdx_value!=rhs_.io_debugEnqLsq_req_4_bits_robIdx_value) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_4_bits_robIdx_value=0x%0h while the rhs_.io_debugEnqLsq_req_4_bits_robIdx_value=0x%0h",this.io_debugEnqLsq_req_4_bits_robIdx_value,rhs_.io_debugEnqLsq_req_4_bits_robIdx_value),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_4_bits_lqIdx_value!=rhs_.io_debugEnqLsq_req_4_bits_lqIdx_value) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_4_bits_lqIdx_value=0x%0h while the rhs_.io_debugEnqLsq_req_4_bits_lqIdx_value=0x%0h",this.io_debugEnqLsq_req_4_bits_lqIdx_value,rhs_.io_debugEnqLsq_req_4_bits_lqIdx_value),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_5_valid!=rhs_.io_debugEnqLsq_req_5_valid) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_5_valid=0x%0h while the rhs_.io_debugEnqLsq_req_5_valid=0x%0h",this.io_debugEnqLsq_req_5_valid,rhs_.io_debugEnqLsq_req_5_valid),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_5_bits_robIdx_value!=rhs_.io_debugEnqLsq_req_5_bits_robIdx_value) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_5_bits_robIdx_value=0x%0h while the rhs_.io_debugEnqLsq_req_5_bits_robIdx_value=0x%0h",this.io_debugEnqLsq_req_5_bits_robIdx_value,rhs_.io_debugEnqLsq_req_5_bits_robIdx_value),UVM_NONE)
        end

        if(this.io_debugEnqLsq_req_5_bits_lqIdx_value!=rhs_.io_debugEnqLsq_req_5_bits_lqIdx_value) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugEnqLsq_req_5_bits_lqIdx_value=0x%0h while the rhs_.io_debugEnqLsq_req_5_bits_lqIdx_value=0x%0h",this.io_debugEnqLsq_req_5_bits_lqIdx_value,rhs_.io_debugEnqLsq_req_5_bits_lqIdx_value),UVM_NONE)
        end

        if(this.io_debugInstrAddrTransType_bare!=rhs_.io_debugInstrAddrTransType_bare) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugInstrAddrTransType_bare=0x%0h while the rhs_.io_debugInstrAddrTransType_bare=0x%0h",this.io_debugInstrAddrTransType_bare,rhs_.io_debugInstrAddrTransType_bare),UVM_NONE)
        end

        if(this.io_debugInstrAddrTransType_sv39!=rhs_.io_debugInstrAddrTransType_sv39) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugInstrAddrTransType_sv39=0x%0h while the rhs_.io_debugInstrAddrTransType_sv39=0x%0h",this.io_debugInstrAddrTransType_sv39,rhs_.io_debugInstrAddrTransType_sv39),UVM_NONE)
        end

        if(this.io_debugInstrAddrTransType_sv39x4!=rhs_.io_debugInstrAddrTransType_sv39x4) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugInstrAddrTransType_sv39x4=0x%0h while the rhs_.io_debugInstrAddrTransType_sv39x4=0x%0h",this.io_debugInstrAddrTransType_sv39x4,rhs_.io_debugInstrAddrTransType_sv39x4),UVM_NONE)
        end

        if(this.io_debugInstrAddrTransType_sv48!=rhs_.io_debugInstrAddrTransType_sv48) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugInstrAddrTransType_sv48=0x%0h while the rhs_.io_debugInstrAddrTransType_sv48=0x%0h",this.io_debugInstrAddrTransType_sv48,rhs_.io_debugInstrAddrTransType_sv48),UVM_NONE)
        end

        if(this.io_debugInstrAddrTransType_sv48x4!=rhs_.io_debugInstrAddrTransType_sv48x4) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_debugInstrAddrTransType_sv48x4=0x%0h while the rhs_.io_debugInstrAddrTransType_sv48x4=0x%0h",this.io_debugInstrAddrTransType_sv48x4,rhs_.io_debugInstrAddrTransType_sv48x4),UVM_NONE)
        end

        if(this.io_storeDebugInfo_0_robidx_value!=rhs_.io_storeDebugInfo_0_robidx_value) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_storeDebugInfo_0_robidx_value=0x%0h while the rhs_.io_storeDebugInfo_0_robidx_value=0x%0h",this.io_storeDebugInfo_0_robidx_value,rhs_.io_storeDebugInfo_0_robidx_value),UVM_NONE)
        end

        if(this.io_storeDebugInfo_1_robidx_value!=rhs_.io_storeDebugInfo_1_robidx_value) begin
            super_result = 0;
            `uvm_info(get_type_name(),$sformatf("compare fail for this.io_storeDebugInfo_1_robidx_value=0x%0h while the rhs_.io_storeDebugInfo_1_robidx_value=0x%0h",this.io_storeDebugInfo_1_robidx_value,rhs_.io_storeDebugInfo_1_robidx_value),UVM_NONE)
        end

    end
    return super_result;
endfunction:compare

`endif

