

root = getenv('HOME')
sub  = ['work', 'ssjread']
path = '+' + filepath('dummy', root=root, sub=sub)  
path = file_dirname(path)
!path += ':' + expand_path(path)


fn = filepath('*.pro', root=root, sub=sub)
fn = file_search(fn, count=count)


.r  cnv2asc.pro         
.r  conv_struc.pro    
.r  csv_read.pro      
.r  dmsp_routines.pro 
.r  fill_pass_buff.pro
.r  get_sat_facts.pro 
.r  mag_data.pro      
.r  my_cnv2asc.pro    
.r  read_EDR.pro     
.r  read_ssj_file.pro 
.r  set_aurora_red.pro
.r  tom_facts.pro      
.r  aur_routines.pro  
.r  where2D.pro       


