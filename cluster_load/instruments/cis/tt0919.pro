

 
mytimespan, 2004, 3, 10, 12, 20, dmin=20

cis = obj_new('cis')
cis.sc = 3
cis.start_date = time_double('2004-03-10/12:20:00')
cis.end_date   = time_double('2004-03-10/12:40:00')


cl_load, 3, /fgm, /pp

;trange = ['2004-03-10/12:30:00', '2004-03-10/12:40:00']
time = '2004-03-10/12:29:00'
cis->plot_psd, time=time, /ion, /mag, /psd

end
 

 
