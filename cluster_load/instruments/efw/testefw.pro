
;fn = filepath( 'EFW_description.txt', root=file_dirname(routine_filepath()) )
efw = obj_new('efw')
;efw->dataset_id, id
;efw->data_description, id, out=fn

efw->show_dataset_info, 'C3_CP_EFW_L1_IB'

end    
