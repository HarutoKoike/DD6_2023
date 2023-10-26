
function cluster::metadata_tables
compile_opt idl2

tables = [ $
           'csa.v_dataset'             ,$
           'csa.v_dataset_inventory'   ,$ 
           'csa.v_dataset_referenced'  ,$ 
           'csa.v_experiment' ,$ 
           'csa.v_file' ,$ 
           'csa.v_instrument' ,$ 
           'csa.v_mission' ,$ 
           'csa.v_observatory' ,$ 
           'csa.v_parameter' ,$ 
           'csa.v_pregen_inventory' ,$ 
           'csa.v_quick_look_dataset' $
           ]


return, tables
end



;===========================================================+
; ++ NAME ++
function cluster::metadata_request, table=table, column=column, query=query, request_url=request_url, $
                                    csv=csv
;
; ++ PURPOSE ++
;  --> This function returns a HASH of metadata request.
;      This executes the Table Access Procotol (TAP) query. 
;      https://www.cosmos.esa.int/web/csa-guide/tap-tables-and-views
;      SELECT <column> FROM <view>
;
; ++ POSITIONAL ARGUMENTS ++
;  -->
;
; ++ KEYWORDS ++
; -->  table(string) : table view name (e.g., 'csa.v_dataset')
; -->  column(string): column name (e.g., ['dataset_id', 'description']) 
;                      wild card is also accepted.
; -->  table(string) : table view name (e.g., 'csa.v_dataset')
; -->  request_url   : This keyword receives the url for TAP access.
; -->  csv           : Set this to named variable that contains the name of the CSV file. 
;
;
; ++ CALLING SEQUENCE ++
;  -->
; 
;===========================================================+
compile_opt idl2, logical_predicate
;

url = self->url_path() + 'tap/sync?REQUEST=doQuery&LANG=ADQL&FORMAT=CSV&'





;
;*--------- column  ----------*
;
if ~keyword_set(column) then column = '*'
if size(column, /type) ne 7 then $
    message, 'Keyword "column" must be string.'

url += 'QUERY=SELECT+' + strjoin(column, ',')
 

;
;*--------- check validity of table  ----------*
;
if ~keyword_set(table) then table = 'csa.v_dataset'
if n_elements(table) ne 1  or size(table, /type) ne 7 then $
    message, 'Keyword "table" must be 1-element string.'
;
dum = where( strmatch(self->metadata_tables(), table), count )
if count eq 0 then $
    message, 'Table must be select as follows: ' + self->metadata_tables()

url += '+FROM+' + table



;
;*---------  query ----------*
;
if keyword_set(query) then $
    url += '+' + query


if arg_present(request_url) then request_url = url



;
;*--------- HTTP request ----------*
;
catch, err
if err ne 0 then begin
    catch, /cancel
    obj_destroy, ourl
    print, 'Failed to get data: "' + url + '"'
    return, 0
endif

ourl     = obj_new('IDLnetURL')
ourl->setproperty, ssl_version=0, ssl_verify_peer=0
;
filename = filepath( self->julday2filename(), root=self->data_rootdir() ) + '.csv'
csvfile  = ourl->get(url=url, filename=filename)



;
;*---------  read CSV file ----------*
;
metadata = read_csv(csvfile, n_table_header=1, table_header=th)
th       = strsplit(th, ',', /extract)

if arg_present(csv) then begin
    csv = csvfile
endif else begin
    file_delete, csvfile
endelse

md = hash()
for i = 0, n_elements(th) - 1 do $
    md[th[i]] = metadata.(i)        

return, md
end
