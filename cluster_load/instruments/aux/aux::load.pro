;===========================================================+
; ++ NAME ++
pro aux::load, dummy=dummy
; ; ++ PURPOSE ++
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
;
COMPILE_OPT IDL2


;
;*---------- download  ----------*
;
;
id = 'CL_SP_AUX'
*(self.dataset_id) = id
self->cluster::data_download



;
;*---------- read cdf  ----------*
;
cdf2tplot, *(self.local_files), /all



;
;*---------- var label ----------*
;
re = 6378.1369029452326

;
;
get_data, 'sc_r_xyz_gse__CL_SP_AUX', data = r0
sc0 = string(self.sc, format='(i1)')
;
FOR i = 1, 4 DO BEGIN
  sc = STRING(i, FORMAT='(I1)')
  get_data, 'sc_dr'+sc+'_xyz_gse__CL_SP_AUX', data = r1
  ;
  r = (r0.Y + r1.Y) / re  
  ;
  ;
  ;*---------- gse  ----------*
  ;
  store_data, 'pos_x_gse_c'+sc, data={x:r0.x, y:r[*, 0]}
  store_data, 'pos_y_gse_c'+sc, data={x:r0.x, y:r[*, 1]}
  store_data, 'pos_z_gse_c'+sc, data={x:r0.x, y:r[*, 2]}
  store_data, 'pos_gse_c'+sc, data={x:r0.x, y:r}
  ;
  ;*---------- gem  ----------*
  ;
  get_data, 'gse_gsm__CL_SP_AUX', data=ang
  ang = ang.Y * !DTOR
  ;
  x = r[*, 0]
  y = r[*, 1] * COS(ang) - r[*, 2] * SIN(ang)
  z = r[*, 1] * SIN(ang) + r[*, 2] * COS(ang)
  ;
  store_data, 'pos_x_gsm_c'+sc, data={x:r0.x, y:x}
  store_data, 'pos_y_gsm_c'+sc, data={x:r0.x, y:y}
  store_data, 'pos_z_gsm_c'+sc, data={x:r0.x, y:z}
  ;
  options, 'pos_x_gsm_c'+sc, ytitle='X!DGSM!N(R!DE!N)'
  options, 'pos_y_gsm_c'+sc, ytitle='Y!DGSM!N(R!DE!N)'
  options, 'pos_z_gsm_c'+sc, ytitle='Z!DGSM!N(R!DE!N)'
  ;
  ; 
  store_data, 'pos_gsm_c' + sc, data={x:r0.x, y:[[x], [y], [z]]}
  ;

  ;
  ;*---------- velocity  ----------*
  ;
  get_data, 'sc_v_xyz_gse__CL_SP_AUX', data=v
  store_data, 'sc_v_x_gse_c' + sc, data = {x:v.x, y:v.y[*, 0]}
  store_data, 'sc_v_y_gse_c' + sc, data = {x:v.x, y:v.y[*, 1]}
  store_data, 'sc_v_z_gse_c' + sc, data = {x:v.x, y:v.y[*, 2]}
ENDFOR



tplot_options, 'var_label', ['pos_z_gsm_c' + sc0 , 'pos_y_gsm_c' + sc0, $
                             'pos_x_gsm_c'+sc]
END
;
;
;
;aux = obj_new('aux')
;aux.start_date = time_double('2004-03-10/12:00:00')
;aux.end_date   = time_double('2004-03-10/13:00:00')
;aux->load
;
;
;end
