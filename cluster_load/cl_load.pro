;===========================================================+
; ++ NAME ++
pro cl_load, sc, aux=aux, fgm=fgm, cis=cis, peace=peace, efw=efw, $
             psd_cis=psd_cis, trange=trange, time=time, _extra=ex
;
; ++ PURPOSE ++
;  -->
;
; ++ POSITIONAL ARGUMENTS ++
;  -->
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  --> cl_load, [1, 3], /fgm, /cis, /pp, /full
;
;===========================================================+



;
;*---------- get time range  ----------*
;
get_timespan, ts
st = ts[0]
et = ts[1]


;
;*--------- instruments ----------*
;
inst = []
if keyword_set(aux)   then inst = [inst, 'AUX']
if keyword_set(fgm)   then inst = [inst, 'FGM']
if keyword_set(cis)   then inst = [inst, 'CIS']
if keyword_set(peace) then inst = [inst, 'PEACE']
if keyword_set(efw)   then inst = [inst, 'EFW']


;
;*---------- load  ----------*
;
for i = 0, n_elements(inst) - 1 do begin
    obj = obj_new(inst[i])
    obj.start_date = st
    obj.end_date   = et
    ;
    for j = 0, n_elements(sc) - 1 do begin
        obj.sc = sc[j]
        obj->load, _extra=ex
    endfor
    obj_destroy, obj
endfor




;
;*---------- plot  ----------*
;
if keyword_set(psd_cis) then begin
    cis = obj_new('CIS')
    cis.start_date = st
    cis.end_date   = et
    cis->plot_psd, trange=trange, time=time, _extra=ex
endif

end




;mytimespan, 2004, 3, 10, 12, dhr=1
;cl_load, 3, /cis, /pad
;end
