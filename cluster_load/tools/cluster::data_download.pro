;===========================================================+
; ++ NAME ++
function cluster::data_request_url, split=split
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
compile_opt idl2
;


;----------------------------------------------------------+
; 1. direct synchronous data request (up to 1GB)
;     https://www.cosmos.esa.int/web/csa-guide/data-requests
;----------------------------------------------------------+
url = self->url_path() + 'data?'
;
;
;*--------- mandatory query  ----------*
;
; retrieval type
ret_type = 'RETRIEVAL_TYPE=' + self.retrieval_type
;
; start and end date
st       = 'START_DATE=' + self->time_double2iso( self.start_date )
et       = 'END_DATE='   + self->time_double2iso( self.end_date )
; 
; dataset id
if ~isa( *(self.dataset_id) ) then $
    message, 'Propery "dataset_id" is not set.'
ids      = 'DATASET_ID=' + *(self.dataset_id) 
;
; delivery format 
df       = 'DELIVERY_FORMAT=' + strupcase(self.delivery_format)
;

if keyword_set(split) then begin
    url = url + strjoin([ret_type, st, et], '&') + '&' + ids + '&' + df 
endif else begin
    url = url + strjoin([ret_type, st, et, ids, df], '&')
    self.url = url 
endelse


return, url




;----------------------------------------------------------+
; 2. asynchronous data request (up to 50 GB)
;     https://www.cosmos.esa.int/web/csa-guide/data-requests
;----------------------------------------------------------+
; TBD



end   









;===========================================================+
; ++ NAME ++
pro cluster::data_download, successed
;
; ++ PURPOSE ++
;  --> 
;
; ++ POSITIONAL ARGUMENTS ++
;  -->
;
; ++ KEYWORDS ++
;     
;
; ++ CALLING SEQUENCE ++
;  --> cl = obj_new('cluster')
;      cl.dataset_id = ['C3_PP_FGM', 'C1_PP_FGM']
;      cl.start_date = time_double('2004-01-01/00:00:00')
;      cl.end_date   = time_double('2004-01-01/01:00:00')
;      cl.delivery_format = 'cdf'
;
;      Names of downloaded local files are set to 
;      "local_files" property. 
;
;===========================================================+
;
compile_opt idl2

successed = 0


id = *(self.dataset_id)
st = self->time_double2iso(self.start_date) 
et = self->time_double2iso(self.end_date) 
;
print, ''
print, ''
print, ''
print, '======== Cluster data download ========'
print, ''
print, ' Time range '
print, '   start :  ', st
print, '   end   :  ', et
print, ''
print, ''
print, ' Dataset ID '
for i = 0, n_elements(id) - 1 do begin
    print, '   ', id[i]
endfor
print, ''
print, '======================================='
print, ''
print, ''
print, ''





;
; get data URL
url = self->data_request_url(/split)
;
;
; authentification (ascynchronous data request)
if 0 then self->authentification


file_exists = self->file_test()
files       = self->file_search()

dum = where(file_exists eq 0, count)
; 
; if all files already exists
;
if count eq 0 then begin
    *(self.local_files) = files
    return
endif


;----------------------------------------------------------+
; Download
;----------------------------------------------------------+
;catch, err
err  = 0
for i = 0, n_elements(url) - 1 do begin
    ;


    ;
    ;*---------  error handling ----------*
    ;
    if err ne 0 then begin
        catch, /cancel
        ;
        obj_destroy, ou
        print, 'Failed to get data: "' + url[i] + '"'
        file_delete, buffer, /quiet
        continue
    endif


    ;
    ;*---------- http request  ----------*
    ;
    ou = obj_new('IDLnetURL')
    ou->setproperty, ssl_version=0, ssl_verify_peer=0
    ;
    buffer     = filepath( self->julday2filename(), root=self->data_rootdir() )
    local_file = ou->get(url=url[i], filename=buffer)
    
    
    
    ;
    ;*---------- untar  ----------*
    ;
    ;
    if float(!version.release) lt 8.3 then begin $
        myfile_untar, local_file, files=saved_files  
    endif else begin
        file_untar, local_file, files=fn_tar, /list
        dir = file_dirname(fn_tar)
        file_mkdir, filepath( dir, root=self->data_rootdir() )
        file_untar, local_file, files=saved_files 
    endelse
    file_delete, local_file, /quiet
    
    
    ;
    ;*---------- mkdir directory and move file ----------*
    ;
    local_files = []
    ;
    foreach sf, saved_files do begin
        subdir = strsplit(file_dirname(sf), path_sep(), /extract)
        ;
        ;
        idx    = where( ~strmatch(subdir, 'CSA_Download_*') )
        subdir = subdir[idx]
        ;
        ;
        new_path = path_sep() + strjoin(subdir, path_sep())
        file_mkdir, new_path
        ;
        new_file = filepath(file_basename(sf), root=new_path)
        if ~file_test( new_file ) then $ 
            file_move, sf, new_path 
        ;
        local_files = [local_files, new_file]
    endforeach
    
    *(self.local_files) = [*(self.local_files), local_files]
    
    ;
    ;
    print, ' Downloaded Data'
    foreach lf, local_files do print, lf
    
    ;
    ;*--------- remove directory "CSA_Download..." ----------*
    ;
    remove_dir = self->data_rootdir() + path_sep() + $
                 'CSA_Download*' 
    remove_dir = file_search(remove_dir)
    file_delete, remove_dir, /recursive, /quiet
endfor




successed = 1
end 
