undef("read_esrl_psd")
function read_esrl_psd(fi:string,if_submean:logical,start_month:numeric,num_months:numeric)
begin
    data_o      =   readAsciiTable(fi,13,"float",0)
    num_year    =   dimsizes(data_o(:,0))
    start_year  =   tointeger(data_o(0,0))
    end_year    =   tointeger(data_o(num_year-1,0))  
    data_yr_month   =   data_o(:,1:12)
    data_mon        =   ndtooned(data_yr_month)

    time        =   yyyymm_time(start_year,end_year,"integer")
    data_mon!0    =   "time"
    data_mon&time   =   time
    print("minmax check for read_esrl_psd: ")
    printMinMax(data_mon,0)
    delete(time)
    if (.not. if_submean) then
        return(data_mon)
    end if
    if (start_month .lt. 1 .or. start_month .gt. 12) then
        print("Error: check the start_month: "+start_month)
        exit
    end if
    if (num_months .lt. 0 .or. num_months .gt. 12) then
        print("Error: check the num_months: "+num_months)
        exit
    end if
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
        data_year(k)    =   dim_avg(data_mon(ind1:ind2))
    end do
    return(data_year)
end
