pro cis::dataset_id
table  = 'csa.v_dataset'
column = 'dataset_id'
query  = "WHERE+experiments='CIS'+ORDER+BY+dataset_id"


md = self->metadata_request(table=table, column=column, query=query) 
id = md['dataset_id']


file = filepath('cis_dataset_id.txt', root=file_dirname(routine_filepath()))
openw, lun, file, /get_lun
for i = 0, n_elements(id) - 1 do printf, lun, id[i]
free_lun, lun


;for i = 0, n_elements(id) - 1 do begin
;    self->show_dataset_info, id[i]
;endfor
end





;cis = obj_new('cis')
;cis->dataset_id
;end    


