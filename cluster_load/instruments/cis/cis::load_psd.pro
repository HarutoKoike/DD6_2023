
;===========================================================+
; ++ NAME ++
PRO cis::load_psd, _EXTRA=ex, proton=proton, ion=ion, hs=hs, ls=ls, rpa=rpa, $
                   mag=mag, sw=sw, pef=pef, pf=pf, cs=cs, psd=psd, time=time,$
                   dim=dim, trange=trange, ignore_load=ignore_load, $
                   rotation=rotation
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
;  --> cis->plot_psd, /ion, /mag, /psd, time='2004-03-10/12:27:00'
; 
; ++ NOTE ++
; http://themis.ssl.berkeley.edu/socware/spedas_4_1/idl/projects/mms/fpi/mms_get_fpi_dist.pro ;
; 
; 
; ++ HISTORY ++
;  H.Koike 1/9,2021
;===========================================================+
;
COMPILE_OPT IDL2
;
sc = string(self.sc, format='(i1)')
;

;
;-------------------------------------------------+
; determine dataset ID
;-------------------------------------------------+
;
; default ID
; ion 3-D phase space density (default)
id = 'C' + sc + '_CP_CIS-HIA_HS_MAG_IONS_PSD'
;
;*---------- proton  ----------*
;
;
; proton 3-D phase space density (high-sensitivity side, differential energy flux)  
IF KEYWORD_SET(proton) AND KEYWORD_SET(hs) AND KEYWORD_SET(pef) THEN $
  id = 'C' + sc + '_CP_CIS-CODIF_HS_H1_PEF'
;
; proton 3-D phase space density (low-sensitybity side, differential energy flux)  
IF KEYWORD_SET(proton) AND KEYWORD_SET(hs) AND KEYWORD_SET(pf) THEN $
  id = 'C' + sc + '_CP_CIS-CODIF_HS_H1_PF'
;
; proton 3-D phase space density (differential energy flux)  
IF KEYWORD_SET(proton) AND KEYWORD_SET(hs) AND KEYWORD_SET(psd) THEN $
  id = 'C' + sc + '_CP_CIS-CODIF_HS_H1_PSD'
;
; proton 3-D phase space density (differential energy flux)  
IF KEYWORD_SET(proton) AND KEYWORD_SET(hs) AND KEYWORD_SET(cs) THEN $
  id = 'C' + sc + '_CP_CIS-CODIF_HS_H1_CS'
;
; proton 3-D phase space density (differential energy flux)  
IF KEYWORD_SET(proton) AND KEYWORD_SET(rpa) AND KEYWORD_SET(cs) THEN $
  id = 'C' + sc + '_CP_CIS-CODIF_RPA_H1_CS'
;
; proton 3-D phase space density (differential energy flux)  
IF KEYWORD_SET(proton) AND KEYWORD_SET(rpa) AND KEYWORD_SET(pef) THEN $
  id = 'C' + sc + '_CP_CIS-CODIF_RPA_H1_PEF'


;
;*---------- ion  ----------*
;
IF KEYWORD_SET(ion) AND KEYWORD_SET(mag) AND KEYWORD_SET(pef) THEN $
  id = 'C' + sc + '_CP_CIS-HIA_HS_MAG_IONS_PEF'
IF KEYWORD_SET(ion) AND KEYWORD_SET(mag) AND KEYWORD_SET(pf) THEN $
  id = 'C' + sc + '_CP_CIS-HIA_HS_MAG_IONS_PF'
IF KEYWORD_SET(ion) AND KEYWORD_SET(mag) AND KEYWORD_SET(psd) THEN $
  id = 'C' + sc + '_CP_CIS-HIA_HS_MAG_IONS_PSD'
;
IF KEYWORD_SET(ion) AND KEYWORD_SET(sw) AND KEYWORD_SET(hs) AND KEYWORD_SET(pef) THEN $
  id = 'C' + sc + '_CP_CIS-HIA_HS_MAG_IONS_PEF'
IF KEYWORD_SET(ion) AND KEYWORD_SET(sw) AND KEYWORD_SET(hs) AND KEYWORD_SET(pf)  THEN $
  id = 'C' + sc + '_CP_CIS-HIA_HS_MAG_IONS_PF'
IF KEYWORD_SET(ion) AND KEYWORD_SET(sw) AND KEYWORD_SET(hs) AND KEYWORD_SET(pf)  THEN $
  id = 'C' + sc + '_CP_CIS-HIA_HS_MAG_IONS_PSD'
IF KEYWORD_SET(ion) AND KEYWORD_SET(sw) AND KEYWORD_SET(ls) AND KEYWORD_SET(pef) THEN $
  id = 'C' + sc + '_CP_CIS-HIA_LS_MAG_IONS_PEF'
IF KEYWORD_SET(ion) AND KEYWORD_SET(sw) AND KEYWORD_SET(ls) AND KEYWORD_SET(pf)  THEN $
  id = 'C' + sc + '_CP_CIS-HIA_LS_MAG_IONS_PF'
IF KEYWORD_SET(ion) AND KEYWORD_SET(sw) AND KEYWORD_SET(ls) AND KEYWORD_SET(pf)  THEN $
  id = 'C' + sc + '_CP_CIS-HIA_LS_MAG_IONS_PSD'



;
;*---------- downlowd  ----------*
;
*(self.dataset_id) = id
self->data_download
files = *(self.local_files)
cdf2tplot, files, /all


;
;*---------- make Energy-PSD ----------*;
;
tn = '3d_ions__' + id
get_data, tn, data=d
;
self->instrument, energy=e
psd = total(d.y, 4)
psd = total(psd, 3)
;
psd = {x:d.x, y:psd*1.d-18, v:e}
tn  = '1d_ions__' + id
store_data, tn, data=psd
options, tn, 'spec', 1
zlim, tn, 0, 0, 1

end





;==========================================================+
; ++ NAME ++
pro cis::plot_psd, trange=trange, time=time, dim=dim, $
                   rotation=rotation, _extra=ex
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
;==========================================================+
self->load_psd, _extra=ex
sc = string(self.sc, format='(i1)')
;
;*---------- SPEDAS distribution structure  ----------*
;
id = *(self.dataset_id)
if strmatch(id, '*PEF') then unit = 'eflux'
if strmatch(id, '*PF')  then unit = 'flux'
if strmatch(id, '*PSD') then unit = 'df_km'
if strmatch(id, '*CS')  then unit = ''

data_name = 'CIS'
 

struct = {$
          project_name    : 'Cluster'          , $
          spacecraft      : sc                 , $
          data_name       : data_name          , $
          units_name      : unit               , $
          units_procedure : ''                 , $
          speces          : 'i'                , $
          valid           : 1                  , $
          charge          : 1.                 , $
          mass            : 0.0104535          , $
          time            : 0d                 , $
          end_time        : 0d                 , $
          data            : FLTARR(31, 16, 8)  , $
          bins            : FLTARR(31, 16, 8)+1, $
          energy          : FLTARR(31, 16, 8)  , $
          denergy         : FLTARR(31, 16, 8)  , $
          nenergy         : 31L                , $
          nbins           : 128L               , $
          phi             : FLTARR(31, 16, 8)  , $
          dphi            : FLTARR(31, 16, 8)  , $
          theta           : FLTARR(31, 16, 8)  , $
          dtheta          : FLTARR(31, 16, 8)    $
          }


;
;*---------- get ion distribution  ----------*
;

tn = '3d_ions__' + id
get_data, tn, data=distr
IF ISA(distr, 'INT') or ~isa(distr) THEN $
    MESSAGE, 'No velocity distribution data is loaded'
;
n_time      = N_ELEMENTS(distr.x)
dist_struct = REPLICATE(struct, n_time) 
dist_struct.data   = TRANSPOSE(distr.y, [1, 2, 3, 0]) 



;
;*---------- time  ----------*
;
dist_struct.time     = time_double(distr.X)
;
delta_t    = distr.X[1:*]-distr.X[*]
integ_time = average(delta_t, /nan, /ret_median)
dist_struct.end_time = time_double(distr.X) + integ_time
                                                       



;
;*----------  energy bin  ----------*
;
codif = strmatch(id, '*CODIF*')
hia   = strmatch(id, '*HIA*')
;
self->instrument, energy=ebin, codif=codif, hia=hia  
dist_struct.energy = REBIN(ebin, 31, 16, 8) 
 

;
;*---------- phi  ----------*
;
phi = REBIN(distr.v2 , 16, 8)
phi = TRANSPOSE( REBIN(phi, 16, 8, 31), [2, 0, 1])
;
dist_struct.phi   = phi
dist_struct.dphi += 22.5



;
;*---------- theta  ----------*
;
theta = REBIN(distr.v1,  8, 16)
theta = TRANSPOSE( REBIN(theta, 8, 16, 31), [2, 1, 0])
dist_struct.theta = theta
dist_struct.dtheta += 22.5

 


;
;*---------- bulk velocity  ----------*
;
vel_data = 'V_HIA_xyz_gse__C' + sc + '_PP_CIS'
IF KEYWORD_SET(proton) THEN $
    vel_data = 'V_p_xyz_gse__C' + sc + '_PP_CIS'
;
self->load_pp


 


;-------------------------------------------------+
;  make slice plot
;-------------------------------------------------+

dist_ptr = PTR_NEW(dist_struct, /no_copy)
mag_data = 'B_xyz_gse__C' + sc + '_PP_FGM'

;
IF KEYWORD_SET(trange) AND ~KEYWORD_SET(time) THEN $
    time = time_double(trange[0])
IF ~KEYWORD_SET(rotation) THEN rotation = 'BE'
;
slice = spd_slice2d(dist_ptr, time=time, trange=trange,   $
                    mag_data=mag_data, vel_data=vel_data, $
                    rotation=rotation)



;
;*---------- plot  ----------*
;
IF ~KEYWORD_SET(dim) THEN dim = 2
;
; 2-D cut
;
IF dim EQ 2 THEN BEGIN
    spd_slice2d_plot, slice, background_color_index=0, _extra=ex 
ENDIF ELSE BEGIN
    ; 1-D cut ( pitch angle 0 )
    ;fmax = MAX(slice.data, /NAN)
    ;pow  = CEIL(ALOG10(fmax)) 
    ;yrange = [10^(pow-4), 10^pow] 
    ;
    ;yval = [slice.ygrid[0], slice.ygrid[-1]]
    ;yval = 0 
    yval = [-1000, 1000]
    yval = 0    
    spd_slice1d_plot, slice, 'x', yval, _extra=ex, /ylog
    ;OPLOT, [0, 0], yrange, linestyle=2
ENDELSE


PTR_FREE, dist_ptr   
END              






cis = obj_new('cis')
;trange = ['2004-03-10/12:25:00', '2004-03-10/12:27:00']
cis.start_date = time_double('2004-03-10/12:20:00')
cis.end_date   = time_double('2004-03-10/12:40:00')
cis->plot_psd, /ion, /mag, /ls, /psd, time=time_double('2004-03-10/12:31:00')
end






