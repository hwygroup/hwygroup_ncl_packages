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
    time        =   ispan(-mxlag,mxlag,1)
    max_ccr     =   max(ccr)
    min_ccr     =   min(ccr)
    indMax      =   ind_resolve(ind(ccr.eq.max_ccr),dimsizes(ccr))
    indMin      =   ind_resolve(ind(ccr.eq.min_ccr),dimsizes(ccr))
    print("max of ccr: "+max_ccr+" obtained when "+time(indMax(0,0))+ " ts1 lags")
    print("min of ccr: "+min_ccr+" obtained when "+time(indMin(0,0))+ " ts1 leads")
    
    return(ccr)
end

undef("move_ts")
function move_ts(ts:numeric,step:numeric)
begin
    time    =   ts&time
    time    =   time+step
    ts_out  =   ts
    ts_out&time =   time
    return(ts_out)
end 

undef("like_time")
function like_time(ts1:numeric,ts2:numeric,if_ts1:logical)
begin
    time1   =   ts1&time 
    time2   =   ts2&time
    time_s  =   min((/min(time1),min(time2)/))
    time_e  =   max((/max(time1),max(time2)/))
    time    =   ispan(time_s,time_e,1)
    num_time    =   dimsizes(time) 
    if (if_ts1) then
        ts  =   new(num_time,typeof(ts1),ts1@_FillValue)
        ts!0    =   "time"
        ts&time =   time
        ts({time1}) =   ts1
        return(ts)
    end if
        ts  =   new(num_time,typeof(ts2),ts2@_FillValue)
        ts!0    =   "time"
        ts&time =   time
        ts({time2}) =   ts2
        return(ts)
end





