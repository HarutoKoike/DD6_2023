
;
; import
;root = file_dirname( routine_filepath() )
cd, current=root
path = '+' + filepath('cluster_load', root=root)  
!path += ':' + expand_path(path)


num = 0

trange       = strarr(6, 2)
trange[0, *] = ['2004-01-01', '2004-02-01']
trange[1, *] = ['2004-02-01', '2004-03-01']
trange[2, *] = ['2004-03-01', '2004-04-01']
trange[3, *] = ['2004-04-01', '2004-05-01']
trange[4, *] = ['2004-05-01', '2004-06-01']
trange[5, *] = ['2004-06-01', '2004-07-01']


trange = trange[num, *]
timespan, trange
cl_load, 3, /cis, /pp



tn = ['N_HIA__C3_PP_CIS', 'B_xyz_gsm__C3_PP_FGM', $
      'pos_x_gsm_c3', 'pos_y_gsm_c3', 'pos_z_gsm_c3']

tn_del = tnames()

foreach tn0, tn do begin
    idx     = where(tn_del ne tn0)
    tn_del  = tn_del[idx]
endforeach


del_data, tn_del



end
