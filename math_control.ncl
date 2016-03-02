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
undef("lan_filter")
function lan_filter(ts1:numeric,if_low:logical,frq:numeric,nwt:numeric)
begin
    fca = frq 
    nsigma = 1.
    lowpass_wgt     =   filwgts_lanczos (nwt, 0, fca, -999., nsigma)
    highpass_wgt    =   filwgts_lanczos (nwt, 1, fca, -999., nsigma)
    if (if_low) then
        ts2 =   wgt_runave_Wrap(ts1,lowpass_wgt,0)
    else
        ts2 =   wgt_runave_Wrap(ts1,highpass_wgt,0)
    end if

    return(ts2)
end
undef("lag_lead")
function lag_lead(ts1:numeric,ts2:numeric,mxlag:numeric)
begin
    x   =   ts1 
    y   =   ts2
    x_Lead_y = esccr(x,y,mxlag)
    y_Lead_x = esccr(y,x,mxlag)    ; switch the order of the series

    ccr = new ( 2*mxlag+1, float)
    ccr(0:mxlag-1) = y_Lead_x(1:mxlag:-1)  ; "negative lag", -1 reverses order
    ccr(mxlag:)    = x_Lead_y(0:mxlag)     ; "positive lag"
    ccr!0   =   "time"
    ccr&time    =   ispan(-mxlag,mxlag,1)
    return(ccr)
end
