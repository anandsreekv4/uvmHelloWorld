covergroup m_cov;
    option.per_instance = 1;

    cp_wdata: coverpoint m_item.wdata {
        bins zero = {0};
        bins one  = {1};
        bins first_half = { [1            : (2**(DWDTH-1) - 1)] };
        bins sec_half   = { [2**(DWDTH-1) : (2**(DWDTH)   - 1)] };
    }

    cp_wrstn: coverpoint m_item.wrstn {
        bins reset_tx     = {0};
        bins non_reset_tx = {1};
    }
endgroup: m_cov
