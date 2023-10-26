;===========================================================+
; ++ NAME ++
function cluster::inventory, dataset_id, start_date, end_date
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
;===========================================================+
compile_opt idl2, logical_predicate
;
if size(dataset_id, /type) ne 7 and $
    n_elements(dataset_id) ne 1 then $
    message, 'dataset_id must be string.'


table  = 'csa.v_dataset_inventory'
column = 'dataset_id,start_time,end_time,num_instances,inventory_version'



;
;*--------- query ----------*
;
; dataset id
query = "WHERE+dataset_id='" + dataset_id + "'+AND+"
;
; date
start_date = self->time_double2iso( start_date )
start_date = strmid(start_date, 0, strlen(start_date) - 1)
end_date   = self->time_double2iso( end_date )
end_date   = strmid(end_date, 0, strlen(end_date) - 1)
query     += "start_time<='" + end_date + "'+AND+end_time>='" + start_date + "'"


inv = self->metadata_request(table=table, column=column, query=query)
return, inv
end
