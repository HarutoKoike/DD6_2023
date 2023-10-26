
;===========================================================+
; ++ NAME ++
pro cis::load_pp
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
;  -->
;
; ++ HISTORY ++
;  H.Koike 1/9,2021
;===========================================================+
compile_opt idl2
;
;
;*--------- download and read CDF  ----------*
;
sc = string(self.sc, format='(i1)')
id = 'C' + sc + '_PP_CIS'
;
*(self.dataset_id) = id

self->data_download
files = *(self.local_files)
cdf2tplot, files, /all
;



;-------------------------------------------------+
; tplot variable setting
;-------------------------------------------------+
;
;*---------- ion density ----------*
;
tname = 'N_HIA__C'+sc+'_PP_CIS'
ylim, tname, 0, 0, /log
options, tname, ytitle='N!Di!N'
options, tname, ysubtitle='[cm!U-3!N]'


;
;*---------- ion velocity ----------*
;
tname = 'V_HIA_xyz_gse__C'+sc+'_PP_CIS'
options, tname, 'labels', ['Vx', 'Vy', 'Vz']
options, tname, 'colors', [0, 50, 230]
options, tname, ytitle='Ion Velocity(GSE)'
options, tname, ysubtitle='[km/s]'
options, tname, 'databar', {yval:0, linestyle:2}
;
;
get_data, tname, data=v
IF SIZE(v, /TYPE) EQ 2 THEN RETURN
;
tname = 'V_HIA_mag__C' + sc + '_PP_CIS'
vx = v.Y[*, 0]
vy = v.Y[*, 1]
vz = v.Y[*, 2]
vmag  = SQRT(vx^2 + vy^2 + vz^2) 
;
;
; load FGM data
fgm            = obj_new('FGM')
fgm.sc         = self.sc
fgm.start_date = self.start_date
fgm.end_date   = self.end_date
fgm->load, /pp
obj_destroy, fgm


;
get_data, 'B_xyz_gse__C'+sc+'_PP_FGM', data=b
IF SIZE(b, /TYPE) EQ 2 THEN GOTO, no_mag
;
bx = b.Y[*, 0]
by = b.Y[*, 1]
bz = b.Y[*, 2]
bmag  = SQRT(bx^2 + by^2 + bz^2) 
;
v_para = (vx*bx + vy*by + vz*bz) / bmag
v_perp = SQRT(vmag^2 - v_para^2)
;
store_data, 'V_para__C'+sc, data={x:v.x, y:v_para}
store_data, 'V_perp__C'+sc, data={x:v.x, y:v_perp}
store_data, 'V_mag__C' + sc, data={x:v.x, y:SQRT(v_para^2+v_perp^2)}
;
options, 'V_perp__C'+ sc, 'labels', 'perp'
options, 'V_para__C'+ sc, 'labels', 'para'
options, 'V_mag__C'+ sc, 'labels', '|V|'
;
store_data, 'V_para_perp__C'+sc, data=['V_para__C'+sc, 'V_perp__C'+sc, 'V_mag__C'+sc]
options, 'V_para_perp__C'+ sc, 'colors', [50, 220, 0]
options, 'V_para_perp__C'+sc, 'databar', {yval:0, linestyle:2}
options, 'V_para_perp__C'+sc, 'ytitle', 'V!Dpara!N/V!Dperp!N'
options, 'V_para_perp__C'+sc, 'ysubtitle', '[km/s]'





no_mag:
;
;*---------- ion velocity GSE to GSM  ----------*
;
aux = obj_new('aux')
aux.start_date = self.start_date
aux.end_date   = self.end_date
aux->load
obj_destroy, aux
;


;
get_data, 'gse_gsm__CL_SP_AUX', data=ang
IF SIZE(ang, /TYPE) EQ 2 THEN RETURN
;
ang = ang.Y * !DTOR
ang = INTERPOL(ang, N_ELEMENTS(b.X))
;
vx_gsm = v.Y[*, 0] 
vy_gsm = v.Y[*, 1] * COS(ang) - v.Y[*, 2] * SIN(ang)
vz_gsm = v.Y[*, 1] * SIN(ang) + v.Y[*, 2] * COS(ang)
;
vx_gsm = INTERPOL(vx_gsm, N_ELEMENTS(v.x))
vy_gsm = INTERPOL(vy_gsm, N_ELEMENTS(v.x))
vz_gsm = INTERPOL(vz_gsm, N_ELEMENTS(v.x))
;                                         
tname = 'V_HIA_xyz_gsm__C' + sc + '_PP_CIS'
store_data, tname, data={X:v.x, Y:[[vx_gsm], [vy_gsm], [vz_gsm]]}
options, tname, 'colors', [0, 50, 220] 
options, tname, 'labels', ['V!DX!N', 'V!DY!N', 'V!DZ!N']
options, tname, 'databar', {yval:0, linestyle:2} 
options, tname, 'ytitle', 'V!Di!Ni(GSM)'
options, tname, 'ysubtitle', '[km/s]'

 

;
;*---------- ion temperature  ----------*
;
options, 'T_HIA_par__C' + sc + '_PP_CIS', 'ytitle', 'Ti!Dpara!N'
options, 'T_HIA_perp__C' + sc + '_PP_CIS', 'ytitle', 'Ti!Dperp!N'
options, 'T_HIA_par__C' + sc + '_PP_CIS', 'ysubtitle', '[MK]'
options, 'T_HIA_perp__C' + sc + '_PP_CIS', 'ysubtitle', '[MK]'
;
tname = 'T_HIA__C' + sc + '_PP_CIS'
store_data, tname, data = ['T_HIA_par__C'+sc+'_PP_CIS', $
            'T_HIA_perp__C'+sc+'_PP_CIS']
options, tname, 'colors', [50, 220]
ylim, tname, 1., 100, /log
options, tname, ytitle='T!Di!N'
options, tname, ysubtitle='[10!U6!NK]'
options, tname, labels=['para', 'perp']

;
; scholar temperature
tn_para = 'T_HIA_par__C' + sc + '_PP_CIS'
tn_perp = 'T_HIA_perp__C' + sc + '_PP_CIS'
;
get_data, tn_para, data=ti_para
get_data, tn_perp, data=ti_perp

ti = (ti_para.y + 2*ti_perp.y) / 3. 
store_data, 'T_HIA__C' + sc + '_PP_CIS', data={x:ti_para.x, y:ti}




;
;*---------- ion omni directional ion flux  ----------*
;
tname = 'flux__C'+sc+'_CP_CIS-HIA_HS_1D_PEF'
get_data, tname, dlim=dlim, lim=lim
;
str_element, dlim, 'spec', 1, /add
store_data, tname, dlim=dlim
ylim, tname, 5, 32.e3, /log
zlim, tname, 0, 0, 1
;
options, tname, 'ytitle', 'Ion(C' + sc + ')' 
options, tname, ysubtitle='[eV]'
options, tname, '[eV/eV cm!U2!N s sr]'
                   


;
;*---------- plasma frequency & inertial length  ----------*
;
get_data, 'N_HIA__C'+sc+'_PP_CIS', data=n
np = n.Y * 1.e6
;
;
tname   = 'Proton_plasma_frequancy__C' + sc  
omega_p = SQRT( !CONST.E^2 * np / (!CONST.EPS0 * !CONST.MP) ) 
store_data, tname, data={x:n.X, y:omega_p/!PI/2.}
options, tname, 'ytitle', 'f!Dpi!N'
options, tname, 'ysubtitle', '[Hz]'
;
;
tname = 'Proton_inertial_length__C' + sc
intl  = !CONST.C / omega_p * 1.e-3
store_data, tname, data={x:n.X, y:intl}
options, tname, 'ytitle', 'Inertial Length(C' + sc + ')'
options, tname, 'ysubtitle', '[km]'




;
;*---------- ion beta & pressure anisotropy ----------*
;
;
bmag   = SQRT(b.Y[*, 0]^2 + b.Y[*, 1]^2 + b.Y[*, 2]^2) * 1.d-9
tmag   = b.X
b_pres = bmag^2  / 2. / !CONST.MU0  ; magnetic pressure
;
get_data, 'T_HIA_par__C' + sc + '_PP_CIS', data=t_para 
get_data, 'T_HIA_perp__C' + sc + '_PP_CIS', data=t_perp 
get_data, 'N_HIA__C'+sc+'_PP_CIS', data=n
;
np     = interp(n.Y, n.X, tmag) * 1.d6
t_para = interp(t_para.Y, t_para.X, tmag) * 1.d6 
t_perp = interp(t_perp.Y, t_perp.X, tmag) * 1.d6 
;
beta_para = np * !CONST.K * t_para / b_pres 
beta_perp = np * !CONST.K * t_perp / b_pres 
alpha     = (beta_para - beta_perp) * 2.   ; see Paschmann et al.(1986)
;
tname_para  = 'Ion_Beta_para__C' + sc
tname_perp  = 'Ion_Beta_perp__C' + sc
tname_alpha = 'Pressure_anisotropy__C' + sc
store_data, tname_para, data={X:tmag, Y:beta_para} 
store_data, tname_perp, data={X:tmag, Y:beta_perp} 
store_data, tname_alpha, data={x:tmag, y:alpha}
;
ylim, tname_para, 0, 0, 1
ylim, tname_perp, 0, 0, 1
;
tname_beta = 'Ion_Beta__C' + sc
store_data, tname_beta, data=[tname_para, tname_perp]
options, tname_beta, 'colors', [50, 230]
options, tname_beta, 'labels', ['para', 'perp']
options, tname_beta, 'databar', {yval:1., linestyle:2}
ylim, tname_beta, 0.0001, 100, 1


;
tname_beta = 'Ion_Beta_total__C' + sc
store_data, tname_beta, data={x:tmag, y:(beta_para+2*beta_perp)/3}



;
;*---------- Frequency ratio (F_pi / F_ci)  ----------*
;
tname = 'Frequency_ratio_ion__C' + sc
ratio = SQRT( !CONST.MP * np / !CONST.EPS0 / bmag^2)
store_data, tname, data={x:tmag, y:ratio}
options, tname, 'databar', {yval:1, linestyle:2}
options, tname, 'ytitle', 'f!Dpi!N/f!Dci!N (C' + sc + ')'
ylim, tname, 0, 0, /log
;
;
tname = 'Frequency_ratio_electron__C' + sc
ratio = ratio * SQRT(!CONST.ME / !CONST.MP)
store_data, tname, data={x:tmag, y:ratio}
options, tname, 'databar', {yval:1, linestyle:2}
options, tname, 'ytitle', 'f!Dpe!N/f!Dce!N (C' + sc + ')'
ylim, tname, 0, 0, /log     


;
;*---------- anisotropy  ----------*
;
get_data, 'T_HIA_par__C' + sc + '_PP_CIS', data=t
;
tname_aniso = 'Ion_Anisotropy__C' + sc 
store_data, tname_aniso, data={X:t.X, Y:t_para/t_perp}
options, tname_aniso, 'ytitle', 'T!Dpara!N/T!Dperp!N (C' + sc + ')'
options, tname_aniso, 'databar', {yval:1., linestyle:2}
ylim, tname_aniso, 0, 0, 1



;
;*---------- -V x B electric field  ----------*
;
tcrossp, 'B_xyz_gsm__C'+sc+'_PP_FGM', 'V_HIA_xyz_gsm__C'+sc+'_PP_CIS', $
         /diff_tsize_ok, newname='E_gsm_VxB__C' + sc

; mV/m  
calc, '"E_gsm_VxB__C' + sc + '" *= 1.e-3'
options, 'E_gsm_VxB__C' + sc, 'ytitle', 'E_field(GSM, C' + sc + ')'
options, 'E_gsm_VxB__C' + sc, 'ysubtitle', 'mV/m'




;
;*---------- Alfven Velocity (proton) ----------*
;
get_data, 'B_xyz_gsm__C'+sc+'_PP_FGM', data=b
get_data, 'N_HIA__C'+sc+'_PP_CIS', data=n
;
np = interp(n.Y, n.X, b.X) * 1.e6
t  = b.X
b  = b.Y * 1.e-9
;
va = FLTARR(N_ELEMENTS(t), 3)
va[*, 0] = b[*, 0] / SQRT( !CONST.MU0 * np * !CONST.MP ) * 1.e-3
va[*, 1] = b[*, 1] / SQRT( !CONST.MU0 * np * !CONST.MP ) * 1.e-3
va[*, 2] = b[*, 2] / SQRT( !CONST.MU0 * np * !CONST.MP ) * 1.e-3
;
tname = 'Alfven_Velocity_gsm__C' + sc
store_data, tname, data = {X:t, Y:va}
;
options, tname, 'ytitle', 'V!DA!N (C' + sc + ')'
options, tname, 'ysubtitle', '[km/s]'
options, tname, 'colors', [230, 150, 50]
options, tname, 'labels', ['x', 'y', 'z']     

;
;
; Alfven mach number
tname = 'V_HIA_xyz_gsm__C'+sc+'_PP_CIS'
get_data, tname, data=v
;
vmag   = sqrt( total(v.y^2, 2) )
va_mag = sqrt( total(va^2, 2) )
vmag   = interp(vmag, v.x, t)

M_va = vmag / va_mag 

tn = 'Alfven_Mach_Number__C' + sc
store_data, tn, data={x:t, y:M_va}
options, tn, 'ytitle', 'M!DA!N__C' + sc


end






pro cis::load, pp=pp, pad=pad, psd=psd, _extra=ex
if keyword_set(pp)  then self->load_pp
if keyword_set(pad) then self->load_pad
if keyword_set(psd) then self->load_psd, _extra=ex
end



