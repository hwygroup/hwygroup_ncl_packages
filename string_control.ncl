undef("get_start_year")
function get_start_year(a:string,b:string,c:string)
begin
    i1  =   indStrSubset(a,b)
    i2  =   indStrSubset(a,c)
    ind1    =   max(i1)+1
    ind2    =   min(i2)-1
    start_year   =   stringtoint(str_get_cols(a,ind1,ind1+3))
    return(start_year)
end
undef("get_start_month")
function get_start_month(a:string,b:string,c:string)
begin
    i1  =   indStrSubset(a,b)
    i2  =   indStrSubset(a,c)
    ind1    =   max(i1)+1
    ind2    =   min(i2)-1
    start_month   =   stringtoint(str_get_cols(a,ind1+4,ind1+5))
    return(start_month)
end
undef("get_end_year")
function get_end_year(a:string,b:string,c:string)
begin
    i1  =   indStrSubset(a,b)
    i2  =   indStrSubset(a,c)
    ind1    =   max(i1)+1
    ind2    =   min(i2)-1
    end_year   =   stringtoint(str_get_cols(a,ind1+7,ind1+10))
    return(end_year)
end
undef("get_end_month")
function get_end_month(a:string,b:string,c:string)
begin
    i1  =   indStrSubset(a,b)
    i2  =   indStrSubset(a,c)
    ind1    =   max(i1)+1
    ind2    =   min(i2)-1
    end_month   =   stringtoint(str_get_cols(a,ind1+11,ind1+12))
    return(end_month)
end
undef("get_center_string")
function get_center_string(a:string,b:string,c:string,d:logical)
begin
    i1  =   indStrSubset(a,b)
    i2  =   indStrSubset(a,c)
    ind1    =   max(i1)+1
    ind2    =   min(i2)-1
    if (d) then
        center_string   =   stringtoint(str_get_cols(a,ind1,ind2))
    else
        center_string   =   str_get_cols(a,ind1,ind2)
    end if
    return(center_string)
end
undef("get_center_strings")
function get_center_strings(a:string,b:string,c:string,d:logical)
begin
    num_a   =   dimsizes(a)
    if (d) then
        center_string   =   new(num_a,"integer")
    else
        center_string   =   a
    end if
    do k = 0, num_a-1
        center_string(k)    =   get_center_string(a(k),b,c,d)
    end do

    return(center_string)
end
undef("get_before_string")
function get_before_string(a:string,b:string,d:logical)
    begin
    i1  =   indStrSubset(a,b)
    ind1    =   min(i1)-1
    if (d) then
        center_string   =   stringtoint(str_get_cols(a,0,ind1))
    else
        center_string   =   str_get_cols(a,0,ind1)
    end if
    return(center_string)
end
undef("get_before_strings")
function get_before_strings(a:string,b:string,d:logical)
    begin
    num_a   =   dimsizes(a)
    if (d) then
        center_string   =   new(num_a,"integer")
    else
        center_string   =   a
    end if
    do k = 0, num_a-1
        center_string(k)    =   get_before_string(a(k),b,d)
    end do
    
    return(center_string)
end
undef("get_after_string")
function get_after_string(a:string,b:string,d:logical)
begin
    i1  =   indStrSubset(a,b)
    ind1    =   max(i1)+1
    if (d) then
        center_string   =   stringtoint(str_get_cols(a,ind1,10000))
    else
        center_string   =   str_get_cols(a,ind1,10000)
    end if
    return(center_string)
end
undef("get_after_strings")
function get_after_strings(a:string,b:string,d:logical)
    begin
    num_a   =   dimsizes(a)
    if (d) then
        center_string   =   new(num_a,"integer")
    else
        center_string   =   a
    end if
    do k = 0, num_a-1
        center_string(k)    =   get_after_string(a(k),b,d)
    end do
    
    return(center_string)
end


undef("set_1d_coord")
function set_1d_coord(a:numeric,b:string)
begin
    a!0 =   b(0)
    return(a)
end


undef("set_2d_coord")
function set_2d_coord(a:numeric,b:string)
begin
    a!0 =   b(0)
    a!1 =   b(1)
    return(a)
end

undef("set_3d_coord")
function set_3d_coord(a:numeric,b:string)
begin
    a!0 =   b(0)
    a!1 =   b(1)
    a!2 =   b(2)
    return(a)
end

undef("set_4d_coord")
function set_4d_coord(a:numeric,b:string)
begin
    a!0 =   b(0)
    a!1 =   b(1)
    a!2 =   b(2)
    a!3 =   b(3)
    return(a)
end
