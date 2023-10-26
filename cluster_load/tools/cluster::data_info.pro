;===========================================================+
; ++ NAME ++
pro cluster::show_dataset_info, dataset_id
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
; ++ HISTORY ++
;  H.Koike 1/9,2021
;===========================================================+
compile_opt idl2
;
;*---------- TAP query  ----------*
;
table  = 'csa.v_dataset'
column = ['dataset_caveats', 'description', 'time_resolution', 'person_reference', '"level"', $
          'dataset_reference']
;
query  = "WHERE+dataset_id='" + dataset_id + "'"

md = self->metadata_request(table=table, column=column, query=query, csv=csv, $
                            request_url=request_url)
 
str = strarr( file_lines(csv) )
;
;*---------- read  ----------*
;
openr, lun, csv, /get_lun
readf, lun, str
free_lun, lun
;
str = str[1:-1]
 

print, ''
print, ''
print, dataset_id
print, strjoin(column, ', ')
print, '---'
for i = 0, n_elements(str) - 1 do begin
    print, ''
    print, str[i]
endfor

end




















;===========================================================+
; ++ NAME ++
pro cluster::data_description, dataset_id, out=out
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
;  --> cl->data_description, ['C3_PP_FGM', 'C1_PP_EFW'], our='out.txt'
;
; ++ HISTORY ++
;  H.Koike 1/9,2021
;===========================================================+
compile_opt idl2


;
;*---------- TAP query  ----------*
;
table  = 'csa.v_dataset'
column = ['dataset_id', 'description']
;
query  = "WHERE+" + strjoin("dataset_id='" + dataset_id, "'+OR+") + "'"

md = self->metadata_request(table=table, column=column, query=query, csv=csv, $
                            request_url=request_url)
;



str = strarr( file_lines(csv) )


;
;*---------- read  ----------*
;
openr, lun, csv, /get_lun
readf, lun, str
free_lun, lun



;
;*---------- modify  ----------*
;
newline = string(10B)
;newline = '   '
;
; a,"aaa",b,"bbb"
str = str[1:-1]
;print, str[2]
str = strjoin(str, newline)  
str = strsplit(str, '"', /extract)
;
id   = str[0:-1:2]
desc = str[1:-1:2]




;
;*---------- out  ----------*
;
if keyword_set(out) then begin
    openw, lun, out, /get_lun
    for i = 0, n_elements(id) - 1 do begin
        printf, lun, id[i]  
        printf, lun, '---'
        printf, lun, strmid(desc[i], 0, strlen(desc[i]) - 1)
        printf, lun, ''
        printf, lun, ''
    endfor
    free_lun, lun
endif else begin
    for i = 0, n_elements(id) - 1 do begin
        print, id[i]
        print, '---'
        print, strmid(desc[i], 0, strlen(desc[i]) - 1) 
        print, ''
        print, ''
    endfor
endelse


end






pro cluster::data_info
end
