;
;*--------- other modules  ----------*
;
; base
@cluster::misc.pro
@cluster::file_search.pro
@cluster::metadata_request.pro
@cluster::const.pro

; tools
@cluster::inventory.pro
@cluster::data_info.pro
@cluster::data_download.pro


; analysis
@cluster::walen_relation.pro



;----------------------------------------------------------+
; 
;----------------------------------------------------------+
function cluster::init
compile_opt idl2
;

;
;*---------   ----------*
;
self.sc             = 3
self.dataset_id     = ptr_new(/allocate)
self.request_type   = 'data'
self.retrieval_type = 'product'
;
self.delivery_format   = 'cdf'
self.delivery_interval = 'daily'
;
self.local_files = ptr_new(/allocate)
;
self.start_date = 0d
self.end_date   = 1d
;
self->delete_buffer

if float(!version.release) lt 8.3 then self->const

return, 1
end




;-------------------------------------------------+
; 
;-------------------------------------------------+
pro cluster::cleanup
compile_opt idl2
self->delete_buffer
end




;----------------------------------------------------------+
; 
;----------------------------------------------------------+
pro cluster::getproperty, start_date = start_date, end_date = end_date, request_type = request_type, $
                          dataset_id = dataset_id, sc = sc, retrieval_type = retrieval_type, $
                          delivery_format = delivery_format, delivery_interval = delivery_interval, $
                          flat = flat, url = url, local_files=local_files, url_path=url_path
compile_opt idl2

if arg_present(start_date)        then start_date = self.start_date
if arg_present(end_date)          then end_date   = self.end_date
if arg_present(dataset_id)        then dataset_id = *(self.dataset_id)
if arg_present(sc)                then sc         = self.sc
if arg_present(retrieval_type)    then retrieval_type = self.sc
if arg_present(delivery_format)   then delivery_format = self.delivery_format 
if arg_present(delivery_interval) then delivery_interval = self.delivery_interval
if arg_present(url)               then url = self.url
if arg_present(url_path)          then url_path = self.url_path
if arg_present(local_files)       then local_files = *(self.local_files)

end




;----------------------------------------------------------+
; 
;----------------------------------------------------------+
pro cluster::setproperty, start_date = start_date, end_date = end_date, request_type = request_type, $
                          dataset_id = dataset_id, sc = sc, retrieval_type = retrieval_type, $
                          delivery_format = delivery_format, delivery_interval = delivery_interval, $
                          url = url, local_files = local_files
;
compile_opt idl2

if keyword_set(start_date) then begin 
    if size(start_date, /type) ne 5 then $
        message, '"start_date" property must be double type (UNIX time)'
    self.start_date  = start_date 
endif
if keyword_set(end_date) then begin 
    if size(end_date, /type) ne 5 then $
        message, '"end_date" property must be double type (UNIX time)'
    self.end_date    = end_date   
endif


if keyword_set(dataset_id)     then self.dataset_id  = ptr_new(dataset_id) 
if keyword_set(sc)             then self.sc          = string(sc, format='(I1)')         
;
if keyword_set(retrieval_type)     then self.retrieval_type    = retrieval_type         
if keyword_set(deliverty_format)   then self.delivery_format   = deliverty_format
if keyword_set(deliverty_interval) then self.delivery_interval = deliverty_interval
;
if keyword_set(url)               then self.url = url
if keyword_set(local_files)       then self.local_files = ptr_new(local_files)

end



;-------------------------------------------------+
; 
;-------------------------------------------------+
function cluster::data_rootdir
compile_opt idl2, hidden
;
root = getenv('DATA_PATH')
if strlen(root) eq 0 then cd, current=root 
;
root = filepath('Cluster', root=root)
if ~file_test(root) then file_mkdir, root
;
return, root
end



;----------------------------------------------------------+
; 
;----------------------------------------------------------+
function cluster::url_path
compile_opt idl2, hidden
;
url_path = "https://csa.esac.esa.int/csa-sl-tap/"
return, url_path
end




;-------------------------------------------------+
; 
;-------------------------------------------------+
pro cluster::delete_buffer
compile_opt idl2, hidden
;
root  = self->data_rootdir()
files = file_search( filepath('CLbuffer*', root=root), count=count)

if count ne 0 then file_delete, files, /quiet
end




;===========================================================+
; ++ NAME ++
pro cluster__define
;
; ++ PURPOSE ++
;  -->
;
; ++ positional arguments ++
;  -->
;
; ++ KEYWORDS ++
; -->
;
; ++ CALLING SEQUENCE ++
;  -->
; 
;===========================================================+
compile_opt idl2

void = {                      $
        cluster,              $
        dataset_id:ptr_new(), $
        start_date:0d,        $
        end_date:0d,          $
        request_type:'',      $
        sc:0,                 $
        retrieval_type:'',    $
        delivery_format:'',   $
        delivery_interval:'', $
        url:'',               $
        url_path:'',          $
        ;
        local_files:ptr_new(),$
        inherits idl_object   $
        }

end
