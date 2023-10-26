
pro efw::load_l1
compile_opt idl2
;
;self->burst_interval
id = 'C' + string(self.sc, format='(i1)')  + '_CP_EFW_L1_E'
;id = 'C3_CP_EFW_L2_E'
;id = 'C3_CP_EFW_L1_IB'
;id = 'C3_CP_EFW_L2_BB'
;id = 'C3_CP_EFW_L2_BB'
id = 'C3_CP_EFW_L1_E'
;id = 'C3_CP_EFW_L2_E3D_GSE'

self->cluster::show_dataset_info, id
*(self.dataset_id) = id
;
self->cluster::data_download
fn = self.local_files
end




pro efw::load_l2, gse=gse, inert=inert

sc = string(self.sc, format='(i1)')

id = 'C' + sc + '_CP_EFW_L2_E'
if keyword_set(gse) then $
    id = 'C' + sc + '_CP_EFW_L2_E3D_GSE'
if keyword_set(inert) then $
    id = 'C' + sc + '_CP_EFW_L2_E3D_INERT'



*(self.dataset_id) = id
;

;
;*--------- download and read CDF  ----------*
;
self->data_download
files = *(self.local_files)
cdf2tplot, files, /all

end





pro efw::load, l2=l2, l1=l1, _extra=ex
if keyword_set(l1) then self->load_l1
if keyword_set(l2) then self->load_l2, _extra=ex
end




efw = obj_new('efw')
efw.start_date = time_double('2004-03-10/12:20:00')
efw.end_date   = time_double('2004-03-10/12:40:00')
efw->load, /l2, /inert
end
