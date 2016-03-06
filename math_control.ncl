undef("cal_pvalue_cor_ts1_ts2")
function cal_pvalue_cor_ts1_ts2(ts1:numeric,ts2:numeric)
begin
    if(any(ismissing(ts1)) .or. any(ismissing(ts2))) then
        print("ts1 or ts2 contains one or more missing values, cannot continue.")
        exit 
    end if
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
    if(any(ismissing(ts1)) .or. any(ismissing(ts2))) then
        print("ts1 or ts2 contains one or more missing values, cannot continue.")
        exit 
    end if
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

undef("with_month_coord_1d")
function with_month_coord_1d(data:numeric,start_year:numeric,end_year:numeric)
begin
    data_out    =   data
    time        =   yyyymm_time(start_year,end_year,"integer")
    data_out!0      =   "time"
    data_out&time   =   time
    return(data_out)
end
undef("with_year_coord_1d")
function with_year_coord_1d(data:numeric,start_year:numeric,end_year:numeric)
begin
    data_out    =   data
    time        =   ispan(start_year,end_year,1) 
    data_out!0      =   "time"
    data_out&time   =   time
    return(data_out)
end
undef("calc_year_from_mon")
function calc_year_from_mon(data_in:numeric,start_month:numeric,num_months:numeric)
begin
    if (start_month .lt. 1 .or. start_month .gt. 12) then
        print("Error: check the start_month: "+start_month)
        exit
    end if
    if (num_months .lt. 0 .or. num_months .gt. 12) then
        print("Error: check the num_months: "+num_months)
        exit
    end if
    mon_time    =   data_in&time
    num_mon_time    =   dimsizes(mon_time)
    start_year      =   tointeger(mon_time(0)/100)
    end_year        =   tointeger(mon_time(num_mon_time-1)/100)
    first_end_month =   start_month+num_months-1
    if (first_end_month .gt. 12) then
        end_year    =   end_year-1
    end if
    time        =   ispan(start_year,end_year,1)
    num_year    =   end_year-start_year+1
    data_year   =   new(num_year,"float",1.0e+20)
    data_year!0 =   "time"
    data_year&time  =   time

    do k = 0, num_year-1
        ind1    =   start_month-1+12*k
        ind2    =   ind1+num_months-1
        data_year(k)    =   dim_avg(data_in(ind1:ind2))
    end do
    return(data_year)
end


undef("cut_year")
function cut_year(ts_in:numeric,start_year:numeric,end_year:numeric)
begin
    time_in =   ts_in&time
    time    =   ispan(start_year,end_year,1)
    num_time    =   dimsizes(time) 
    ts      =   new(num_time,typeof(ts_in),ts_in@_FillValue)
    ts!0    =   "time"
    ts&time =   time
    time_in_start   =   min(time_in)
    time_in_end     =   max(time_in)
    if (time_in_start .gt. end_year .or. time_in_end .lt. start_year) then
        print("error: time_in_start .gt. end_year .or. time_in_end .lt. start_year")
        exit
    end if
    sub_time_start  =   max((/time_in_start,start_year/))
    sub_time_end    =   min((/time_in_end,end_year/))
    sub_time        =   ispan(sub_time_start,sub_time_end,1)
    ts({sub_time})  =   ts_in({sub_time})
    return(ts)

end

undef("calc_year_from_mon_TLL")
function calc_year_from_mon_TLL(data_in:numeric,start_month:numeric,num_months:numeric)
begin
    if (start_month .lt. 1 .or. start_month .gt. 12) then
        print("Error: check the start_month: "+start_month)
        exit
    end if
    if (num_months .lt. 0 .or. num_months .gt. 12) then
        print("Error: check the num_months: "+num_months)
        exit
    end if
    mon_time    =   data_in&time
    lat         =   data_in&lat
    lon         =   data_in&lon
    num_mon_time    =   dimsizes(mon_time)
    num_lat         =   dimsizes(lat)
    num_lon         =   dimsizes(lon)
    start_year      =   tointeger(mon_time(0)/100)
    end_year        =   tointeger(mon_time(num_mon_time-1)/100)
    first_end_month =   start_month+num_months-1
    if (first_end_month .gt. 12) then
        end_year    =   end_year-1
    end if
    time        =   ispan(start_year,end_year,1)
    num_year    =   end_year-start_year+1
    data_year   =   new((/num_year,num_lat,num_lon/),typeof(data_in),data_in@_FillValue)
    data_year!0 =   "time"
    data_year&time  =   time
    data_year!1 =   "lat"
    data_year&lat   =   lat
    data_year!2 =   "lon"
    data_year&lon   =   lon

    do k = 0, num_year-1
        ind1    =   start_month-1+12*k
        ind2    =   ind1+num_months-1
        data_year(k,:,:)    =   dim_avg_n_Wrap(data_in(ind1:ind2,:,:),0)
    end do
    return(data_year)
end

undef("regcoef_lead_TLL")
function regcoef_lead_TLL(ts_in:numeric,var_in:numeric,lead_years:numeric,if_dtrend:logical,if_cover:logical,sig:numeric)
begin
    if(if_dtrend) then
        ts    =   dtrend_n(ts_in,False,0)
        var   =   dtrend_n(var_in,False,0)
        copy_VarMeta(ts_in,ts)
        copy_VarMeta(var_in,var)
    else
        ts  =   ts_in
        var =   var_in
    end if
    time    =   ts&time 
    num_time    =   dimsizes(time)
    if (lead_years .ge. 0) then
        ts_move     =   ts(0:num_time-1-lead_years)
        var_move    =   var(lead_years:num_time-1,:,:)
    else
        ts_move     =   ts(-lead_years:num_time-1)
        var_move    =   var(0:num_time-1+lead_years,:,:)  
    end if
    var_move_LLT    =   var_move(lat|:,lon|:,time|:)
    rc  =   regCoef(ts_move, var_move_LLT(lat|:,lon|:,time|:))
    copy_VarMeta(var_move_LLT(:,:,0),rc)
    tval = onedtond(rc@tval , dimsizes(rc))
    df   = onedtond(rc@nptxy, dimsizes(rc)) - 2
    b = tval    ; b must be same size as tval (and df)
    b = 0.5
    prob = betainc(df/(df+tval^2),df/2.0,b)       ; prob(nlat,nlon)
    if( if_cover ) then
        rc    =   where(prob .le. sig, rc, rc@_FillValue)
    end if
    return(rc)
end


undef("escorc_lead")
function escorc_lead(ts1_in:numeric,ts2_in:numeric,lead_years:numeric,if_dtrend:logical)
begin
    if(if_dtrend) then
        ts1    =   dtrend(ts1_in,False)
        ts2    =   dtrend(ts2_in,False)
        copy_VarMeta(ts1_in,ts1)
        copy_VarMeta(ts2_in,ts2)
    else
        ts1  =   ts1_in
        ts2  =   ts2_in
    end if
    time    =   ts1&time 
    num_time    =   dimsizes(time)
    if (lead_years .ge. 0) then
        ts1_move    =   ts1(0:num_time-1-lead_years)
        ts2_move    =   ts2(lead_years:num_time-1)
    else
        ts1_move    =   ts1(-lead_years:num_time-1)
        ts2_move    =   ts2(0:num_time-1+lead_years)  
    end if
    cor =   escorc(ts1_move,ts2_move)
    pval    =   cal_pvalue_cor_ts1_ts2(ts1_move,ts2_move)
    cor@pval    =   pval 
    return(cor)
end

undef("escorc_window")
function escorc_window(ts1:numeric,ts2:numeric,mxlag:numeric,if_dtrend:logical,if_pval:logical)
begin
    time    =   ispan(-mxlag,mxlag,1)
    num_time    =   dimsizes(time)
    pval        =   new(num_time,"float")
    pval!0      =   "time"
    pval&time   =   time
    cor         =   pval

    do k = 0, num_time-1
        temp    =   escorc_lead(ts1,ts2,time(k),True)
        cor(k)  =   temp 
        pval(k) =   temp@pval
    end do
    if(if_pval) then
        return(pval)
    else
        return(cor)
    end if
end

