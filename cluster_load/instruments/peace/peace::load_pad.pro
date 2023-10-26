pro peace::load_pad
;
;*---------- dataset id  ----------*
;
sc = string(self.sc, format='(i1)')
;
id = 'C' + sc + '_CP_PEA_PITCH_SPIN_DEFlux'

*(self.dataset_id) = id
self->data_download
files = *(self.local_files)

cdf2tplot, fn, /all

 
;
;*---------- parallel electron  ----------*
;
tname = 'Sweep_Energy__C' + sc +'_CP_PEA_PITCH_SPIN_DEFlux'
get_data, tname, data=e
;
tname = 'Data__C' + sc + '_CP_PEA_PITCH_SPIN_DEFlux'
get_data, tname, data=d, dlim=dlim
IF ISA(d, 'INT') THEN RETURN
;
str_element, dlim, 'spec', 1, /add
tname =  'Parallel_electron__C'+sc
store_data, tname, data={x:d.x, y:REFORM(d.y[*, *, 0]), v:REFORM(e.y[0, *])},$
            dlim=dlim
ylim, tname, min(e.y[0, *], /nan), max(e.y[0, *], /nan), /log
zlim, tname, 0, 0, 1
;
options, tname, 'ytitle', 'Electron!C(0-15)'
options, tname, 'ysubtitle', '[eV]'
;options, tname, 'eV/eV cm!U2!N s sr]'   



;
;*---------- antiparallel electron  ----------*
;
tname =  'antiparallel_electron__C'+sc
store_data, tname, data={x:d.x, y:REFORM(d.y[*, *, -1]), v:REFORM(e.y[0, *])},$
            dlim=dlim
ylim, tname, min(e.y[0, *], /nan), max(e.y[0, *], /nan), /log
zlim, tname, 0, 0, 1
options, tname, 'ytitle', 'Electron!C(165-180)'
options, tname, 'ysubtitle', '[eV]'
;options, tname, '(eV/eV cm!U2!N s sr)'  


;
;*---------- perp electron  ----------*
;
tname =  'perpendicular_electron__C'+sc
store_data, tname, data={x:d.x, y:REFORM(d.y[*, *, 5]+d.y[*, *, 6]), v:REFORM(e.y[0, *])},$
            dlim=dlim
ylim, tname, min(e.y[0, *], /nan), max(e.y[0, *], /nan), /log
zlim, tname, 0, 0, 1
options, tname, 'ytitle', 'Electron!C(75-105)'
options, tname, 'ysubtitle', '[eV]' 

end
