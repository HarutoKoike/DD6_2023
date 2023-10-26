pro efw::dataset_id, id
compile_opt idl2
;
table  = 'csa.v_dataset'
column = 'dataset_id'
query  = "WHERE+experiments='EFW'+AND+dataset_id+like+'%25C3%25'+ORDER+BY+dataset_id"

md = self->cluster::metadata_request(table=table, column=column, query=query)
id = md['dataset_id']

help, md
print, id
stop

root = file_dirname( routine_filepath() )
file = filepath( 'EFW_dataset_id.txt', root=root )

openw, lun, file, /get_lun
for i = 0, n_elements(id) - 1 do printf, lun, id[i]
free_lun, lun

end


efw = obj_new('efw')
efw->dataset_id
end
