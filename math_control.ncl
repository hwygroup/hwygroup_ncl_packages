undef("cal_pvalue_cor_ts1_ts2")
function cal_pvalue_cor_ts1_ts2(ts1:numeric,ts2:numeric)
begin
    N   =   dimsizes(ts1)
    r   =   escorc(ts1,ts2)
    df  =   N-2
    tval   =   r*sqrt((df*1.0)/(1.0-r^2))
    prob   =   betainc( df/(df+tval^2), df/2.0, 0.5)
    return(prob)
end

undef("cal_pvalue_reg_ts1_ts2")
function cal_pvalue_reg_ts1_ts2(ts1:numeric,ts2:numeric)
begin
    N   =   dimsizes(ts1)
    rc  =   regline(ts1,ts2)
    df  =   rc@nptxy-2
    prob    =   betainc(df/(df+rc@tval^2), df/2.0, 0.5)
    return(prob)
end
