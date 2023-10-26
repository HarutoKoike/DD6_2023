pro fgm::load_pp
compile_opt idl2


sc = string(self.sc, format='(i1)')
;
;*---------- dataset id ----------*
;
id = 'C' + sc + '_PP_FGM'
*(self.dataset_id) = id



;
;*---------- download and read CDF files ----------*
;
;
self->data_download
;
files = *(self.local_files)
;
;foreach fn, files do cdf2tplot, fn, /all
cdf2tplot, files, /all



;
;*---------- tplot ----------*
;
tname = 'B_xyz_gse__C' + sc + '_PP_FGM'

;
get_data, tname, data=b
;
IF SIZE(b, /TYPE) EQ 2 THEN RETURN
;
options, tname, 'colors', [220, 140, 50]
options, tname, 'labels', ['Bx', 'By', 'Bz']



;
;*--------- |B| ----------*
;
tname = 'B_mag__C' + sc + '_PP_FGM'
store_data, tname, data={x:b.x, y:sqrt(total(b.y^2, 2))}




;
;*---------- GSE to GSM ----------*
;
aux = obj_new('aux')
aux.start_date = self.start_date
aux.end_date   = self.end_date
aux->load
obj_destroy, aux
;
get_data, 'gse_gsm__CL_SP_AUX', data=ang
;
ang = ang.Y * !DTOR
ang = INTERPOL(ang, N_ELEMENTS(b.X))
;
bx_gsm = b.Y[*, 0]
by_gsm = b.Y[*, 1] * COS(ang) - b.Y[*, 2] * SIN(ang)
bz_gsm = b.Y[*, 1] * SIN(ang) + b.Y[*, 2] * COS(ang)
;
; tname for GSM
tname = 'B_xyz_gsm__C' + sc + '_PP_FGM'
;
store_data, tname, data={X:b.x, Y:[[bx_gsm], [by_gsm], [bz_gsm]]}
options, tname, 'colors', [220, 140, 50]
options, tname, 'labels', ['B!DX!N', 'B!DY!N', 'B!DZ!N']
options, tname, 'databar', {yval:0, linestyle:2}
options, tname, 'ytitle', 'B(GSM)'
options, tname, 'ysubtitle', '[nT]'
;



;
;*---------- angle  ----------*
;
tname = 'B_angle_from_GSM-Z'
th    = bz_gsm / sqrt(bx_gsm^2 + by_gsm^2 + bz_gsm^2)
th    = acos(th) / !dtor
store_data, tname, data={x:b.x, y:th}
ylim, tname, -180, 180

end




;-------------------------------------------------+
; 
;-------------------------------------------------+
pro fgm::load_cp_full
compile_opt idl2

sc = string(self.sc, format='(i1)')
;
;*---------- dataset id ----------*
;
id = 'C' + sc + '_CP_FGM_FULL'
*(self.dataset_id) = id



;
;*---------- download and read CDF files ----------*
;
;
self->data_download
;
files = *(self.local_files)
;
foreach fn, files do cdf2tplot, fn, /all



;
;*---------- tplot ----------*
;
tname = 'B_xyz_gse__C'+sc+'_CP_FGM_FULL'

;
get_data, tname, data=b
;
IF SIZE(b, /TYPE) EQ 2 THEN RETURN
;
options, tname, 'colors', [220, 140, 50]
options, tname, 'labels', ['Bx', 'By', 'Bz']


;
;*---------- GSE to GSM ----------*
;
aux = obj_new('aux')
aux.start_date = self.start_date
aux.end_date   = self.end_date
aux->load
obj_destroy, aux
;
get_data, 'gse_gsm__CL_SP_AUX', data=ang
;
ang = ang.Y * !DTOR
ang = INTERPOL(ang, N_ELEMENTS(b.X))
;
bx_gsm = b.Y[*, 0]
by_gsm = b.Y[*, 1] * COS(ang) - b.Y[*, 2] * SIN(ang)
bz_gsm = b.Y[*, 1] * SIN(ang) + b.Y[*, 2] * COS(ang)
;
; tname for GSM
tname = 'B_xyz_gsm__C'+sc+'_PP_FGM'
;
store_data, tname, data={X:b.x, Y:[[bx_gsm], [by_gsm], [bz_gsm]]}
options, tname, 'colors', [220, 140, 50]
options, tname, 'labels', ['B!DX!N', 'B!DY!N', 'B!DZ!N']
options, tname, 'databar', {yval:0, linestyle:2}
options, tname, 'ytitle', 'B(GSM)'
options, tname, 'ysubtitle', '[nT]'
;
end
 





pro fgm::load, pp=pp, full=full
if keyword_set(pp)   then self->load_pp
if keyword_set(full) then self->load_cp_full
end




