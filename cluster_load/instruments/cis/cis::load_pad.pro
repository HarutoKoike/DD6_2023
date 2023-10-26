pro cis::load_pad, oxgen=oxgen
;
;
;*--------- download and read CDF  ----------*
;
sc = string(self.sc, format='(i1)')
id = 'C' + sc + '_CP_CIS-HIA_HS_1D_PEF'
id = [id, 'C' + sc + '_CP_CIS-HIA_PAD_HS_MAG_IONS_PF']
;
if keyword_set(oxgen) then $
    id = [id, 'C' + sc + '_CP_CIS-CODIF_PAD_HS_O1_PF']

;
*(self.dataset_id) = id
self->data_download
files = *(self.local_files)


for i = 0, n_elements(id) - 1 do begin
    fn = files[ where(strmatch(files, '*' + id[i] + '*'), count) ]
    if count eq 0 then continue
    ;
    cdf2tplot, fn, /all
endfor



;----------------------------------------------------------+
; tplot variable setting
;----------------------------------------------------------+
;
;*--------- energy flux  ----------*
;
tname = 'flux__C' + sc + '_CP_CIS-HIA_HS_1D_PEF'
options, tname, 'spec', 1
zlim, tname, 0, 0, 1
ylim, tname, 5.559999, 28898.330, 1



;*---------- ion pitch angle distribution (energy integrated)  ----------*
;
tname = 'Differential_Particle_Flux__C' + sc + '_CP_CIS-HIA_PAD_HS_MAG_IONS_PF'
get_data, tname, data=d
;
de       = FLTARR(N_ELEMENTS(d.v2))
de[0]    = d.v2[0] - d.v2[1]
de[-1]   = d.v2[-2] - d.v2[-1]
de[1:-2] = 0.5 * (d.v2[0:-3] - d.v2[2:-1])
;
flux = FLTARR(N_ELEMENTS(d.x), N_ELEMENTS(d.v1))
FOR i = 0, N_ELEMENTS(de) - 1 DO BEGIN
    flux += d.Y[*, i, *] * de[i] * 1.e-3 ; eV -> keV
ENDFOR
;
tname = 'Total_Number_Flux_PAD__C' + sc + '_CP_CIS-HIA_HS_MAG_IONS_PF'
store_data, tname, data={x:d.x, y:flux, v:d.v1}
;
ylim, tname, 0, 180
zlim, tname, 0, 0, 1
get_data, tname, dlim=dlim
str_element, dlim, 'spec', 1, /add
store_data, tname, dlim=dlim
;
options, tname, 'ytitle', 'Ion PAD (C' + sc + ')'
options, tname, 'ysubtitle', '[deg]'
options, tname, 'ztitle', 'cm!U-2!N s!U-1!N st!U-1!N'



end
