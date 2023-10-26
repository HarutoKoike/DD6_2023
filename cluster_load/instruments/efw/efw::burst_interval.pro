;===========================================================+
; ++ NAME ++
pro efw::burst_interval, inv
;
; ++ PURPOSE ++
;  --> This procedure shows the interval of burst mode operation.
;
; ++ POSITIONAL ARGUMENTS ++
;  --> inv: named variable that receives the inventory data.
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  --> efw = obj_new('efw')
;  --> efw.start_date = time_double('2004-03-01/00:00:00')
;  --> efw.end_date   = time_double('2004-06-01/00:00:00')
;  --> efw->burst_interval, inv
;
; ++ HISTORY ++
;  H.Koike 1/9,2023
;===========================================================+

compile_opt idl2
;
sc  = string(self.sc, format='(i1)')
id  = 'C' + sc + '_CP_EFW_L2_E3D_INERT'
inv = self->inventory(id, self.start_date, self.end_date)

help, inv
stop
st  = inv['start_time']
et  = inv['end_time']
num = inv['num_instances']

idx = where( num ne 0, count )
if count eq 0 then return

st = st[idx]
et = et[idx]
num= num[idx]

print, 'start_time(ISO) end_time(ISO) num instances'
for i = 0, count-1 do begin
    print, st[i], '   ', et[i], num[i]
endfor

end
