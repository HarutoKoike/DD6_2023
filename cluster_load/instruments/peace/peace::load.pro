PRO peace::load_pp, dummy=dummy
;
COMPILE_OPT IDL2

forward_function tname
;
;*---------- dataset id  ----------*
;
sc = string(self.sc, format='(i1)')
;
id = 'C' + sc + '_PP_PEA'

*(self.dataset_id) = id
self->data_download
files = *(self.local_files)
;
cdf2tplot, files, /all





;-------------------------------------------------+
; tplot
;-------------------------------------------------+
;
;*---------  electron thermal pressure ----------*
;
get_data, 'N_e_den__C' + sc + '_PP_PEA', data=n
get_data, 'T_e_par__C' + sc + '_PP_PEA', data=t_para
get_data, 'T_e_perp__C' + sc + '_PP_PEA', data=t_perp
;
p_para = n.y * !const.k * t_para.y * 1.d21   ; in a unit of nPa
p_perp = n.y * !const.k * t_perp.y * 1.d21   ; in a unit of nPa
store_data, 'Pressure_e_perp__C' + sc, data={x:t_perp.x, y:p_perp}
store_data, 'Pressure_e_para__C' + sc, data={x:t_para.x, y:p_para} 
;

;
;*---------  beta ----------*
;
tn     = tnames()
tn_mag = 'B_mag__C' + sc + '_PP_FGM'
dum    = where( strmatch(tn, tn_mag), count )
;
if count eq 1 then begin
    get_data, tn_mag, data=b_mag 
    ;
    b_mag  = interp(b_mag.Y, b_mag.X, t_perp.x) * 1.d-9 
    b_pres = b_mag^2 / 2. / !const.mu0      ; in a unit of Pa
    ;
    beta_para = p_para * 1.d-9 / b_pres
    beta_perp = p_perp * 1.d-9 / b_pres
    ;
    store_data, 'Electron_Beta_para__C'+sc, data={x:t_perp.x, y:beta_para}
    store_data, 'Electron_Beta_perp__C'+sc, data={x:t_perp.x, y:beta_perp}
    store_data, 'Electron_Beta_total__C'+sc, data={x:t_perp.x, y:(beta_para+2*beta_perp)/3}
endif


end



pro peace::load, pp=pp, pad=pad
if keyword_set(pp)  then self->load_pp
if keyword_set(pad) then self->load_pad
end


  
