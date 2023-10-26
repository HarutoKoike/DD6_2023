;----------------------------------------------------------+
; 
;----------------------------------------------------------+
function cluster::file_expr 

compile_opt idl2, hidden, LOGICAL_PREDICATE
;
if ~isa( *(self.dataset_id) ) then $ 
    message, 'property "dataset_id" is not set.'

root = self->data_rootdir() + path_sep() + $
       *(self.dataset_id)



;
;*---------  devide ----------*
;
if self.delivery_interval eq 'daily'  then interval = 86400D
if self.delivery_interval eq 'hourly' then interval = 3600D


t0     = self.start_date
t1     = self.end_date
nfiles = ceil( (t1 - t0) / interval )

st     = dindgen(nfiles)*interval + t0
et     = st + interval
et[-1] = t1


iso_st = self->parse_iso( self->time_double2iso(st), /string )
iso_ed = self->parse_iso( self->time_double2iso(et), /string )



;
;*--------- filename expression ----------*
;
span = '__' + iso_st.year + iso_st.month + iso_st.day + '_' + $
       iso_st.hour + iso_st.min + iso_st.sec + '_' + $
       iso_ed.year + iso_ed.month + iso_ed.day + '_' + $
       iso_ed.hour + iso_ed.min + iso_ed.sec + '*.'  + self.delivery_format
        
filename = []
id       = *(self.dataset_id)
for i = 0, n_elements(id) - 1 do begin
    filename = [filename, root[i] + path_sep() + id[i] + span]
endfor


return, filename
end




;----------------------------------------------------------+
; 
;----------------------------------------------------------+
function cluster::file_search
compile_opt idl2, hidden 

fn0 = self->file_expr()
fn  = []

for i = 0, n_elements(fn0) - 1 do begin
    fn = [fn, file_search(fn0[i])]
endfor

return, fn
end



;----------------------------------------------------------+
; 
;----------------------------------------------------------+
function cluster::file_test
compile_opt idl2, hidden 
;
return, file_test( self->file_search() )
end      





;cl = obj_new('cluster')
;cl.dataset= ['aaa', 'bbb', 'ccc']
;cl.start_date = time_double('2004-01-02/22:00:00')
;cl.end_date   = time_double('2004-01-11/20:00:00')
;a = cl->file_expr()
;end
