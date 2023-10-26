
pro myfile_untar, tar_archive, directory_out, verbose=verbose, $
                  files=files
	
if ~isa(directory_out, 'string') then $
    directory_out = file_dirname(tar_archive)

;
;*-redirect file names in the archive to the buffer file
;
ts   = STRING(SYSTIME(/SECONDS), FORMAT='(F19.7)')
ts   = STRJOIN(STRSPLIT(ts, '.', /EXTRACT))
fn   = 'tar-buff_' + ts + '.txt'
fn   = STRCOMPRESS(fn, /REMOVE)
buff = FILEPATH(fn, ROOT=directory_out)
;
count = 0
WHILE FILE_TEST(buff) DO BEGIN
    buff = 'c' + STRING(count, FORMAT='(I03)') + '_' + buff
    count ++
ENDWHILE
;
SPAWN, 'tar -tf ' + tar_archive + ' > ' + buff
;
;*---------- read buffer file  ----------*
;
;
f         = ''
file_list = []
OPENR, lun, buff, /GET_LUN
i = 0
WHILE ~EOF(lun) DO BEGIN
	READF, lun, f
	file_list = [file_list, FILEPATH(f, root_dir=directory_out)]
    i ++
ENDWHILE
FREE_LUN, lun
file_list = file_list[UNIQ(files)]

;
;*---------- untar archive ----------*
;
SPAWN, 'tar -xf ' + tar_archive + ' -C ' + directory_out

if arg_present(files) then files = file_list

FILE_DELETE, tar_archive, buff

END
