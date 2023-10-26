;-------------------------------------------------+
; 
;-------------------------------------------------+
function cluster::time_double2iso, td
compile_opt idl2, hidden
;
jd0 = julday(1, 1, 1970, 0, 0, 0)
jd  = jd0 + td / 86400d    ; Julian date
;
caldat, jd, mon, dy, yr, hr, min, sec

iso = string(yr, format='(I04)') + '-' + string(mon, format='(I02)') + '-' + $
      string(dy, format='(I02)') + 'T' + string(hr, format='(I02)')  + ':' + $
      string(min, format='(I02)') + ':' + string(sec, format='(I02)') + 'Z'
;
return, iso 
end





;-------------------------------------------------+
; 
;-------------------------------------------------+
function cluster::julday2filename
compile_opt idl2, hidden
;
timestamp = string(systime(/seconds), format='(F19.7)')
timestamp = strsplit(timestamp, '.', /extract)
timestamp = strjoin(timestamp)
;
filename  = strcompress('CLbuffer'+timestamp, /remove_all)
;
return, filename
end



;----------------------------------------------------------+
; 
;----------------------------------------------------------+
function cluster::parse_iso, iso, string=string
compile_opt idl2, hidden

;
; '2000-01-01T00:00:00Z'
n     = n_elements(iso)
year  = strarr(n)
month = strarr(n)
day   = strarr(n)
hour  = strarr(n)
min   = strarr(n)
sec   = strarr(n)


for i = 0, n-1 do begin
    year[i]  = strmid(iso[i], 0, 4) 
    month[i] = strmid(iso[i], 5, 2) 
    day[i]   = strmid(iso[i], 8, 2) 
    hour[i]  = strmid(iso[i], 11, 2) 
    min[i]   = strmid(iso[i], 14, 2) 
    sec[i]   = strmid(iso[i], 17, 2) 
endfor


if ~keyword_set(string) then begin
    year  = fix(year)
    month = fix(month)
    day   = fix(day)
    hour  = fix(hour)
    min   = fix(min)
    sec   = fix(sec)
endif


if n eq 1 then begin
    year  = year[0]
    month = month[0]
    day   = day[0]
    hour  = hour[0]
    min   = min[0]
    sec   = sec[0]
endif



struc = {year:year, month:month, day:day, hour:hour, min:min, sec:sec}

return, struc
end




 
;-------------------------------------------------+
; 
;-------------------------------------------------+
function cluster::iso2time_double, iso
compile_opt idl2
;
st  = self->parse_iso(iso)
jd  = julday(st.month, st.day, st.year, st.hour, st.min, st.sec) 
jd0 = julday(1, 1, 1970, 0, 0, 0)
;
return, (jd - jd0) * 86400d
end

